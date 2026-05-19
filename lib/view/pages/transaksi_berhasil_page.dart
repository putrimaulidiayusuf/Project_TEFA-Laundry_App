import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:app_laundry/controllers/printer_controller.dart';
import 'package:app_laundry/view/viewmodels/outlet_vm.dart';

const _blue     = Color(0xFF0A4174);
const _blueDark = Color(0xFF063059);

class TransaksiBerhasilPage extends StatelessWidget {
  final double totalHarga;
  final double jumlahBayar;
  final VoidCallback onBuatBaru;
  final String pelanggan;
  final String noOrder;
  final String tanggal;
  final String estimasiSelesai;
  final String namaKasir;
  final String metodeBayar;
  final String statusTransaksi;
  final String keterangan;
  final int diskon;
  final List<Map<String, dynamic>> items;

  const TransaksiBerhasilPage({
    super.key,
    required this.totalHarga,
    required this.jumlahBayar,
    required this.onBuatBaru,
    required this.pelanggan,
    required this.noOrder,
    required this.tanggal,
    required this.estimasiSelesai,
    required this.namaKasir,
    required this.metodeBayar,
    required this.statusTransaksi,
    required this.keterangan,
    required this.diskon,
    required this.items,
  });

  String _fmt(double v) =>
      'Rp ${NumberFormat('#,###', 'id_ID').format(v.toInt())}';

  // ── Cetak struk ke printer thermal ──────────────────────────────
  Future<void> _cetak(BuildContext context) async {
    final printer  = Get.find<PrinterController>();
    final outletVM = context.read<OutletVM>();

    final kembalian = (jumlahBayar - totalHarga).toInt();

    final ok = await printer.printStruk(
      template:        outletVM.templateStruk,
      namaToko:        outletVM.nama,
      alamat:          outletVM.alamat,
      fotoPath:        outletVM.fotoPath,
      footerMessage:   outletVM.footerMessage,
      pelanggan:       pelanggan,
      noOrder:         noOrder,
      tanggal:         tanggal,
      estimasiSelesai: estimasiSelesai,
      namaKasir:       namaKasir,
      metodeBayar:     metodeBayar,
      statusTransaksi: statusTransaksi,
      catatan:         keterangan,
      keterangan:      keterangan,
      items:           items,
      total:           totalHarga.toInt(),
      bayar:           jumlahBayar.toInt(),
      kembalian:       kembalian,
      diskon:          diskon,
      autoCut:         outletVM.autoCut,
      cashdrawer:      outletVM.cashdrawer,
    );

    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal print, printer tidak terhubung')),
      );
    }
  }

  // ── Bagikan ringkasan transaksi via share sheet ──────────────────
  Future<void> _bagikan(BuildContext context) async {
    final outletVM  = context.read<OutletVM>();
    final kembalian = jumlahBayar - totalHarga;

    // Susun baris item
    final StringBuffer itemLines = StringBuffer();
    for (final item in items) {
      final namaItem = item['nama']     ?? item['name'] ?? '-';
      final qty      = item['qty']      ?? item['jumlah'] ?? 1;
      final harga    = item['harga']    ?? item['price'] ?? 0;
      final subtotal = (qty is int ? qty : (qty as num).toInt()) *
                       (harga is double ? harga : (harga as num).toDouble());
      itemLines.writeln(
        '  • $namaItem (${qty}x) ........... ${_fmt(subtotal)}',
      );
    }

    // Teks struk teks yang akan dibagikan
    final String pesan = '''
🧺 *${outletVM.nama}*
${outletVM.alamat.isNotEmpty ? '📍 ${outletVM.alamat}' : ''}
${'─' * 32}
📋 *Struk Transaksi*

🔖 No Order     : $noOrder
👤 Pelanggan    : $pelanggan
📅 Tanggal      : $tanggal
🕐 Est. Selesai : $estimasiSelesai
💳 Metode Bayar : $metodeBayar
👨‍💼 Kasir         : $namaKasir
📦 Status       : $statusTransaksi
${'─' * 32}
*Detail Layanan:*
$itemLines${'─' * 32}
${diskon > 0 ? '🏷️ Diskon       : $diskon%\n' : ''}💰 Total        : ${_fmt(totalHarga)}
💵 Bayar        : ${_fmt(jumlahBayar)}
💚 Kembalian    : ${_fmt(kembalian < 0 ? 0 : kembalian)}
${'─' * 32}
${keterangan.isNotEmpty ? '📝 Catatan: $keterangan\n' : ''}${outletVM.footerMessage.isNotEmpty ? '\n${outletVM.footerMessage}' : ''}

_Terima kasih telah menggunakan layanan kami!_ 🙏
''';

    await Share.share(
      pesan.trim(),
      subject: 'Struk Laundry - No Order $noOrder',
    );
  }

  @override
  Widget build(BuildContext context) {
    final kembalian = jumlahBayar - totalHarga;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Konten tengah ──────────────────────────────────────
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon sukses
                  Container(
                    width: 100, height: 100,
                    decoration: const BoxDecoration(
                        color: _blue, shape: BoxShape.circle),
                    child: const Icon(Icons.check,
                        color: Colors.white, size: 56),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Transaksi Berhasil Disimpan!',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Ringkasan pembayaran
                  _InfoCard(children: [
                    _InfoRow(label: 'No Order',    value: noOrder),
                    _InfoRow(label: 'Pelanggan',   value: pelanggan),
                    _InfoRow(
                      label: 'Total Harga',
                      value: _fmt(totalHarga),
                      bold: true,
                    ),
                    _InfoRow(
                      label: 'Jumlah Bayar',
                      value: _fmt(jumlahBayar),
                    ),
                    _InfoRow(
                      label: 'Kembalian',
                      value: _fmt(kembalian < 0 ? 0 : kembalian),
                      bold: kembalian > 0,
                      valueColor:
                          kembalian > 0 ? Colors.green.shade700 : null,
                    ),
                  ]),
                ],
              ),
            ),

            // ── Tombol aksi ────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _RoundBtn(
                    icon: Icons.check,
                    label: 'Selesai',
                    onTap: onBuatBaru,
                  ),
                  _RoundBtn(
                    icon: Icons.print,
                    label: 'Cetak',
                    onTap: () => _cetak(context),
                  ),
                  _RoundBtn(
                    icon: Icons.share,
                    label: 'Bagikan',
                    onTap: () => _bagikan(context), // ← terhubung sekarang
                  ),
                ],
              ),
            ),

            // ── Tombol buat transaksi baru ─────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blueDark,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: onBuatBaru,
                child: const Text(
                  'Buat Transaksi Baru',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Widget helpers ─────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final List<Widget> children;
  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;
  const _InfoRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _RoundBtn(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 64, height: 64,
            decoration: const BoxDecoration(
                color: _blue, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}