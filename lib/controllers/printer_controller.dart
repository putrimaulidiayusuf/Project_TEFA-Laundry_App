import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kMac   = 'printer_mac';
const _kName  = 'printer_name';
const _prefix = 'custom_struk_';

class PrinterController extends GetxController {
  final isScanning    = false.obs;
  final isConnecting  = false.obs;
  final connectedMac  = RxnString();
  final connectedName = RxnString();
  final devices       = <BluetoothInfo>[].obs;

  bool get isConnected => connectedMac.value != null;

  @override
  void onInit() {
    super.onInit();
    _loadSavedPrinter();
    _requestPermissionsAndScan();
  }

  // ── Persistence ────────────────────────────────────────────────
  Future<void> _loadSavedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    final mac   = prefs.getString(_kMac);
    final name  = prefs.getString(_kName);
    if (mac != null) {
      connectedMac.value  = mac;
      connectedName.value = name;
    }
  }

  Future<void> _savePrinter(String mac, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kMac, mac);
    await prefs.setString(_kName, name);
  }

  Future<void> _clearSavedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kMac);
    await prefs.remove(_kName);
  }

  // ── Bluetooth ──────────────────────────────────────────────────
  Future<void> _requestPermissionsAndScan() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();
    await scan();
  }

  Future<void> scan() async {
    isScanning.value = true;
    try {
      final enabled = await PrintBluetoothThermal.bluetoothEnabled;
      if (!enabled) {
        Get.snackbar('Bluetooth', 'Bluetooth tidak aktif');
        return;
      }
      devices.value = await PrintBluetoothThermal.pairedBluetooths;
    } catch (e) {
      Get.snackbar('Error', 'Gagal scan: $e');
    } finally {
      isScanning.value = false;
    }
  }

  Future<void> connect(BluetoothInfo device) async {
    isConnecting.value = true;
    try {
      await PrintBluetoothThermal.disconnect;
      final ok = await PrintBluetoothThermal.connect(
          macPrinterAddress: device.macAdress);
      if (ok) {
        connectedMac.value  = device.macAdress;
        connectedName.value = device.name;
        await _savePrinter(device.macAdress, device.name);
        Get.snackbar('Printer', 'Terhubung ke ${device.name}');
      } else {
        Get.snackbar('Printer', 'Gagal terhubung');
      }
    } catch (e) {
      Get.snackbar('Error', '$e');
    } finally {
      isConnecting.value = false;
    }
  }

  Future<void> disconnect() async {
    await PrintBluetoothThermal.disconnect;
    connectedMac.value  = null;
    connectedName.value = null;
    await _clearSavedPrinter();
    Get.snackbar('Printer', 'Perangkat terputus');
  }

  Future<bool> _ensureConnected() async {
    if (await PrintBluetoothThermal.connectionStatus) return true;
    if (connectedMac.value == null) return false;
    Get.snackbar(
      'Printer', 'Menghubungkan ke ${connectedName.value}...',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
    final ok = await PrintBluetoothThermal.connect(
        macPrinterAddress: connectedMac.value!);
    if (!ok) {
      Get.snackbar('Printer', 'Gagal reconnect ke ${connectedName.value}',
          snackPosition: SnackPosition.BOTTOM);
    }
    return ok;
  }

  Future<bool> testPrint() async {
    if (!await _ensureConnected()) return false;
    return await PrintBluetoothThermal.writeBytes([
      ...'\n================================\n'.codeUnits,
      ...'        TEST PRINT              \n'.codeUnits,
      ...'================================\n'.codeUnits,
      ...'\n\n\n'.codeUnits,
    ]);
  }

  // ── Custom struk settings ──────────────────────────────────────
  Future<Map<String, bool>> _loadCustomSettings() async {
    final prefs = await SharedPreferences.getInstance();
    const keys = [
      'logo', 'nama_outlet', 'alamat_outlet', 'no_nota',
      'nama_pelanggan', 'tanggal', 'tanggal_estimasi', 'nama_kasir',
      'status_transaksi', 'metode_bayar', 'sembunyikan_diskon_0',
      'sembunyikan_kembalian_0', 'keterangan', 'catatan', 'footer_message',
    ];
    return {for (final k in keys) k: prefs.getBool('$_prefix$k') ?? true};
  }

  // ── Logo → ESC/POS raster bytes ───────────────────────────────
  /// Load logo dari [fotoPath] (file lokal outlet) atau fallback ke
  /// assets/layanan.png jika fotoPath kosong/tidak ada.
  /// Lebar dicetak max [printWidth] pixel.
  Future<List<int>> _logoBytes({
    String? fotoPath,
    int printWidth = 384,
  }) async {
    try {
      // 1. Load gambar: prioritas fotoPath, fallback assets
      Uint8List imageBytes;
      if (fotoPath != null && fotoPath.isNotEmpty) {
        final file = File(fotoPath);
        if (await file.exists()) {
          imageBytes = await file.readAsBytes();
        } else {
          // File tidak ada, coba assets
          final data = await rootBundle.load('assets/layanan.png');
          imageBytes = data.buffer.asUint8List();
        }
      } else {
        final data = await rootBundle.load('assets/layanan.png');
        imageBytes = data.buffer.asUint8List();
      }

      final codec = await ui.instantiateImageCodec(
        imageBytes,
        targetWidth: printWidth,
      );
      final frame = await codec.getNextFrame();
      final image = frame.image;

      // 2. Ambil pixel RGBA
      final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData == null) return [];

      final imgW = image.width;
      final imgH = image.height;

      // 3. Konversi ke 1-bit (threshold: luminance < 128 → cetak, else → putih)
      // ESC/POS GS v 0 raster: setiap row = (imgW / 8) byte
      final widthBytes = (imgW / 8).ceil();

      List<int> result = [];

      // ESC/POS: GS v 0  (raster bit image)
      // GS v 0 m xL xH yL yH d1...dk
      // m=0 (normal density), xL/xH = width in bytes, yL/yH = height in dots
      result.addAll([
        0x1D, 0x76, 0x30, 0x00,
        widthBytes & 0xFF, (widthBytes >> 8) & 0xFF,
        imgH & 0xFF, (imgH >> 8) & 0xFF,
      ]);

      final rgba = byteData.buffer.asUint8List();

      for (int y = 0; y < imgH; y++) {
        for (int xByte = 0; xByte < widthBytes; xByte++) {
          int b = 0;
          for (int bit = 0; bit < 8; bit++) {
            final x = xByte * 8 + bit;
            if (x < imgW) {
              final idx = (y * imgW + x) * 4;
              final r = rgba[idx];
              final g = rgba[idx + 1];
              final bC = rgba[idx + 2];
              final a = rgba[idx + 3];
              // Alpha rendah → anggap putih
              final lum = (a < 128) ? 255 : (0.299 * r + 0.587 * g + 0.114 * bC).round();
              if (lum < 128) b |= (0x80 >> bit); // pixel gelap → cetak
            }
          }
          result.add(b);
        }
      }

      return result;
    } catch (e) {
      // Jika gagal load logo, lewati saja (tidak error)
      return [];
    }
  }

  // ── printStruk ─────────────────────────────────────────────────
  Future<bool> printStruk({
    required String template,
    required String namaToko,
    required String alamat,
    required String? fotoPath,      // ← path foto outlet (dari OutletVM.fotoPath)
    required String catatan,
    required String footerMessage,
    required String pelanggan,
    required String noOrder,
    required String tanggal,
    required String estimasiSelesai,
    required String namaKasir,
    required String metodeBayar,
    required String statusTransaksi,
    required String keterangan,
    required List<Map<String, dynamic>> items,
    required int total,
    required int bayar,
    required int kembalian,
    required int diskon,
    bool autoCut    = false,
    bool cashdrawer = false,
  }) async {
    if (!await _ensureConnected()) return false;

    final isCustom   = template.contains('custom');
    final customConf = isCustom ? await _loadCustomSettings() : <String, bool>{};

    // Load logo bytes jika perlu
    final bool showLogo = isCustom ? (customConf['logo'] ?? true) : true;
    final List<int> logoBytes = showLogo ? await _logoBytes(
      fotoPath: fotoPath,
      printWidth: template.contains('80') ? 113 : 85, // ~1.5cm
    ) : [];

    final bytes = _buildStruk(
      template:        template,
      customConf:      customConf,
      logoBytes:       logoBytes,
      namaToko:        namaToko,
      alamat:          alamat,
      catatan:         catatan,
      footerMessage:   footerMessage,
      pelanggan:       pelanggan,
      noOrder:         noOrder,
      tanggal:         tanggal,
      estimasiSelesai: estimasiSelesai,
      namaKasir:       namaKasir,
      metodeBayar:     metodeBayar,
      statusTransaksi: statusTransaksi,
      items:           items,
      total:           total,
      bayar:           bayar,
      kembalian:       kembalian,
      diskon:          diskon,
      autoCut:         autoCut,
      cashdrawer:      cashdrawer,
    );

    return await PrintBluetoothThermal.writeBytes(bytes);
  }

  // ── ESC/POS helpers ────────────────────────────────────────────
  static const _centerAlign = [0x1B, 0x61, 0x01];
  static const _leftAlign   = [0x1B, 0x61, 0x00];
  static const _boldOn      = [0x1B, 0x45, 0x01];
  static const _boldOff     = [0x1B, 0x45, 0x00];
  static const _doubleSize  = [0x1B, 0x21, 0x30];
  static const _normalSize  = [0x1B, 0x21, 0x00];
  static const _cut         = [0x1D, 0x56, 0x41, 0x00];
  static const _drawer      = [0x1B, 0x70, 0x00, 0x19, 0xFA];

  // Konversi string ke bytes ESC/POS
  // Karakter Indonesia umum tetap aman karena masih dalam range Latin-1
  List<int> _txt(String text) {
    return text.codeUnits.map((c) {
      if (c <= 255) return c; // ASCII + Latin-1 aman
      // Fallback karakter unicode umum
      switch (c) {
        case 0x2013: return 45;  // en dash → -
        case 0x2014: return 45;  // em dash → -
        case 0x2018:
        case 0x2019: return 39;  // curly quote → '
        case 0x201C:
        case 0x201D: return 34;  // curly double quote → "
        default:     return 63;  // ? untuk yang lain
      }
    }).toList();
  }

  List<int> _buildStruk({
    required String template,
    required Map<String, bool> customConf,
    required List<int> logoBytes,
    required String namaToko,
    required String alamat,
    required String catatan,
    required String footerMessage,
    required String pelanggan,
    required String noOrder,
    required String tanggal,
    required String estimasiSelesai,
    required String namaKasir,
    required String metodeBayar,
    required String statusTransaksi,
    required List<Map<String, dynamic>> items,
    required int total,
    required int bayar,
    required int kembalian,
    required int diskon,
    bool autoCut    = false,
    bool cashdrawer = false,
  }) {
    final is80mm   = template.contains('80');
    final isCustom = template.contains('custom');
    final w        = is80mm ? 48 : 32;

    bool show(String key) => isCustom ? (customConf[key] ?? true) : true;

    final divider   = '${'─' * w}\n'.replaceAll('─', '-');
    final dividerEq = '${'═' * w}\n'.replaceAll('═', '=');

    // row: kiri rata kiri, kanan rata kanan
    String row(String left, String right) {
      final space = w - left.length - right.length;
      return '$left${space > 0 ? ' ' * space : ' '}$right\n';
    }

    // Format rupiah sederhana
    String rp(int v) {
      final s = v.abs().toString();
      final buf = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
        buf.write(s[i]);
      }
      return 'Rp${v < 0 ? '-' : ''}${buf}';
    }

    List<int> bytes = [];

    // ── LOGO ──────────────────────────────────────────────────────
    if (show('logo') && logoBytes.isNotEmpty) {
      bytes += _centerAlign;
      bytes += logoBytes;
      bytes += _txt('\n');
    }

    // ── HEADER ────────────────────────────────────────────────────
    bytes += _centerAlign;

    if (isCustom) {
      if (show('nama_outlet') && namaToko.isNotEmpty) {
        bytes += _boldOn;
        bytes += _doubleSize;
        bytes += _txt('$namaToko\n');
        bytes += _normalSize;
        bytes += _boldOff;
      }
      if (show('alamat_outlet') && alamat.isNotEmpty) {
        bytes += _txt('$alamat\n');
      }
    } else {
      bytes += _txt('\n$namaToko\n');
      if (alamat.isNotEmpty) bytes += _txt('$alamat\n');
    }

    bytes += _leftAlign;
    bytes += _txt(dividerEq);

    // ── INFO TRANSAKSI ────────────────────────────────────────────
    // FIX: pelanggan & noOrder dijamin tidak kosong, ada guard
    if (show('no_nota') && noOrder.isNotEmpty)
      bytes += _txt('No Order  : $noOrder\n');
    if (show('nama_pelanggan') && pelanggan.isNotEmpty)
      bytes += _txt('Pelanggan : $pelanggan\n');
    if (show('tanggal') && tanggal.isNotEmpty)
      bytes += _txt('Tanggal   : $tanggal\n');
    if (show('tanggal_estimasi') && estimasiSelesai.isNotEmpty)
      bytes += _txt('Est.Selesai: $estimasiSelesai\n');
    if (show('nama_kasir') && namaKasir.isNotEmpty)
      bytes += _txt('Kasir     : $namaKasir\n');
    if (show('status_transaksi') && statusTransaksi.isNotEmpty)
      bytes += _txt('Status    : $statusTransaksi\n');
    if (show('metode_bayar') && metodeBayar.isNotEmpty)
      bytes += _txt('Metode Pembayaran    : $metodeBayar\n');

    bytes += _txt(divider);

    // ── ITEMS ─────────────────────────────────────────────────────
    for (final item in items) {
      if (isCustom) bytes += _boldOn;
      bytes += _txt('${item['nama']}\n');
      if (isCustom) bytes += _boldOff;
      bytes += _txt(row(
        '  ${item['qty']}x ${rp((item['harga'] as num).toInt())}',
        rp((item['subtotal'] as num).toInt()),
      ));
    }

    bytes += _txt(divider);

    // ── TOTAL & PEMBAYARAN ────────────────────────────────────────
    // Diskon
    final sembunyikanDiskon = show('sembunyikan_diskon_0');
    if (diskon > 0 || !sembunyikanDiskon) {
      bytes += _txt(row('DISKON', rp(diskon)));
    }

    // Total
    if (isCustom) bytes += _boldOn;
    bytes += _txt(row('TOTAL', rp(total)));
    if (isCustom) bytes += _boldOff;

    // FIX: Bayar — selalu tampil (tidak ada kondisi yang menyembunyikannya)
    bytes += _txt(row('BAYAR', rp(bayar)));

    // Kembalian — sembunyikan jika 0 dan toggle aktif
    final sembunyikanKembalian = show('sembunyikan_kembalian_0');
    if (kembalian > 0 || !sembunyikanKembalian) {
      bytes += _txt(row('KEMBALIAN', rp(kembalian)));
    }

    bytes += _txt(dividerEq);

    // ── CATATAN TRANSAKSI ─────────────────────────────────────────
    // FIX: 'catatan' di sini sudah berisi keterangan TRANSAKSI
    // (dikirim dari TransaksiBerhasilPage dengan nilai `keterangan`)
    if (show('keterangan') && catatan.isNotEmpty) {
      bytes += _txt('Catatan: $catatan\n');
      bytes += _txt(divider);
    }

    // ── FOOTER ────────────────────────────────────────────────────
    bytes += _centerAlign;
    if (show('footer_message') && footerMessage.isNotEmpty) {
      bytes += _txt('$footerMessage\n');
    } else {
      bytes += _txt('Terima kasih!\n');
    }
    bytes += _leftAlign;
    bytes += _txt('\n\n\n');

    if (cashdrawer) bytes += _drawer;
    if (autoCut)    bytes += _cut;

    return bytes;
  }
}