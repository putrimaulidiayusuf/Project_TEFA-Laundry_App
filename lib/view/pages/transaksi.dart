import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../viewmodels/transaksi_vm.dart';
import '../viewmodels/customer_vm.dart';
import '../viewmodels/outlet_vm.dart';
import '../widgets/header.dart';
import 'pilih_layanan_page.dart';
import 'transaksi_berhasil_page.dart';

const _gold  = Color(0xFF0A4174);
const _green = Color(0xFF063059);

String _fmt(double v) =>
    'Rp. ${NumberFormat('#,###', 'id_ID').format(v.toInt())}';

class RiwayatTransaksi extends StatefulWidget {
  const RiwayatTransaksi({super.key});
  @override
  State<RiwayatTransaksi> createState() => _RiwayatTransaksiState();
}

class _RiwayatTransaksiState extends State<RiwayatTransaksi> {
  final _ketCtrl = TextEditingController();

  @override
  void dispose() {
    _ketCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, bool isMasuk) async {
    final vm      = context.read<TransaksiVM>();
    final initial = isMasuk ? vm.tanggalMasuk : vm.estimasiSelesai;
    final picked  = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null || !mounted) return;
    final dt = DateTime(
        picked.year, picked.month, picked.day, time.hour, time.minute);
    if (isMasuk) {
      vm.setTanggalMasuk(dt);
    } else {
      vm.setEstimasiSelesai(dt);
    }
  }

  Future<void> _showKonfirmasi(BuildContext context) async {
    final vm = context.read<TransaksiVM>();
    if (vm.pelanggan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih pelanggan terlebih dahulu')));
      return;
    }
    if (vm.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tambahkan layanan terlebih dahulu')));
      return;
    }

    final bayarCtrl =
        TextEditingController(text: vm.total.toInt().toString());

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          child: Container(
            decoration: BoxDecoration(
              color: _gold,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 8, 8),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text('Konfirmasi Pembelian !',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                // Body
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow('Nama Pelanggan',
                          vm.pelanggan?.name ?? '-'),
                      const SizedBox(height: 4),
                      _InfoRow('Total Harga', _fmt(vm.total)),
                      const SizedBox(height: 16),
                      // Jumlah Bayar
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.account_balance_wallet,
                                color: _gold, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: bayarCtrl,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                decoration: const InputDecoration(
                                  labelText: 'Jumlah Bayar',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel_outlined,
                                  color: Colors.red),
                              onPressed: () => bayarCtrl.clear(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '(Jika ingin DP nya dulu maka masuk jumlah DP)',
                        style:
                            TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                          ),
                          onPressed: () async {
                            Navigator.pop(ctx);
                            await _doCheckout(
                              context,
                              double.tryParse(bayarCtrl.text) ?? vm.total,
                            );
                          },
                          child: const Text('Simpan',
                              style: TextStyle(fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _doCheckout(BuildContext ctx, double jumlahBayar) async {
    final vm        = ctx.read<TransaksiVM>();
    final outletVM  = ctx.read<OutletVM>();
    final totalHarga = vm.total;
    final nav        = Navigator.of(context);
    final messenger  = ScaffoldMessenger.of(context);

    // ── FIX: Simpan semua data SEBELUM checkout() memanggil reset() ──
    final namaPelanggan    = vm.pelanggan?.name ?? '-';
    final tanggal          = DateFormat('dd/MM/yyyy HH:mm').format(vm.tanggalMasuk);
    final estimasiSelesai  = DateFormat('dd/MM/yyyy HH:mm').format(vm.estimasiSelesai);
    final namaKasir        = ''; // isi dari ProfileVM kalau ada
    final metodeBayar      = vm.metodeBayar;
    final keterangan       = vm.keterangan;
    final diskon           = vm.diskon.toInt();
    final kembalian        = (jumlahBayar - totalHarga).toInt();
    final statusTransaksi  = jumlahBayar >= totalHarga ? 'Lunas' : 'DP';

    // Snapshot items sebelum reset
    final strukItems = vm.items.map((item) => {
      'nama':     '${item.serviceType.name} (${item.service.name})',
      'qty':      item.qty % 1 == 0 ? item.qty.toInt() : item.qty,
      'harga':    item.serviceType.price.toInt(),
      'subtotal': item.subtotal.toInt(),
    }).toList();

    try {
      // checkout() sekarang return noOrder dan baru reset di dalamnya
      final noOrder = await vm.checkout(jumlahBayar: jumlahBayar);

      if (!mounted) return;

      nav.push(MaterialPageRoute(
        builder: (_) => TransaksiBerhasilPage(
          totalHarga:      totalHarga,
          jumlahBayar:     jumlahBayar,
          onBuatBaru:      () => nav.pop(),
          pelanggan:       namaPelanggan,    // ✓ sudah di-snapshot
          noOrder:         noOrder,          // ✓ dari DB
          tanggal:         tanggal,          // ✓ sudah di-snapshot
          estimasiSelesai: estimasiSelesai,  // ✓ sudah di-snapshot
          namaKasir:       namaKasir,
          metodeBayar:     metodeBayar,      // ✓ sudah di-snapshot
          statusTransaksi: statusTransaksi,
          keterangan:      keterangan,       // ✓ sudah di-snapshot
          diskon:          diskon,           // ✓ sudah di-snapshot
          items:           strukItems,       // ✓ sudah di-snapshot
        ),
      ));
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm  = context.watch<TransaksiVM>();
    final fmt = DateFormat('dd/MM/yyyy – HH:mm');
    final outletVM = context.watch<OutletVM>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const HeaderWidget(title: 'Checkout'),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Card Pelanggan =====
                  GestureDetector(
                    onTap: () => _showPilihPelanggan(context),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: (vm.pelanggan?.photo != null &&
                                    File(vm.pelanggan!.photo!).existsSync())
                                ? FileImage(File(vm.pelanggan!.photo!))
                                : null,
                            child: vm.pelanggan?.photo == null
                                ? const Icon(Icons.camera_alt,
                                    color: Colors.grey)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: vm.pelanggan == null
                                ? const Text('Pilih Pelanggan',
                                    style: TextStyle(color: Colors.grey))
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(vm.pelanggan!.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                      Row(
                                        children: [
                                          const Icon(Icons.phone,
                                              size: 13, color: _gold),
                                          const SizedBox(width: 4),
                                          Text(vm.pelanggan!.phone,
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54)),
                                        ],
                                      ),
                                    ],
                                  ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 14, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  const Divider(height: 20),

                  // ===== Detail Order Header =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.receipt_long, color: _gold, size: 20),
                            SizedBox(width: 8),
                            Text('Detail Order',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                          ],
                        ),
                        TextButton.icon(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const PilihLayananPage()),
                          ),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Tambah Layanan'),
                          style: TextButton.styleFrom(
                              foregroundColor: _gold),
                        ),
                      ],
                    ),
                  ),

                  // ===== List Items =====
                  if (vm.items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.search_off,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('Data Tidak di temukan',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    )
                  else
                    ...vm.items.asMap().entries.map((e) {
                      final idx  = e.key;
                      final item = e.value;
                      return _CartItemCard(
                        item: item,
                        onDelete: () => vm.removeItem(idx),
                      );
                    }),

                  const Divider(height: 20),

                  // ===== Form Info =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Keterangan
                        Row(
                          children: [
                            const Icon(Icons.note_alt_outlined,
                                size: 18, color: _gold),
                            const SizedBox(width: 8),
                            const Text('Keterangan :',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _ketCtrl,
                                onChanged: vm.setKeterangan,
                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  hintText: 'Contoh: ada noda kecap',
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),

                        const Divider(height: 8),

                        // Tanggal Masuk
                        InkWell(
                          onTap: () => _pickDate(context, true),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_month,
                                    size: 18, color: _gold),
                                const SizedBox(width: 8),
                                const Text('Tanggal Masuk :',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500)),
                                const Spacer(),
                                Text(fmt.format(vm.tanggalMasuk),
                                    style:
                                        const TextStyle(fontSize: 13)),
                                const Icon(Icons.arrow_drop_down,
                                    color: Colors.grey),
                              ],
                            ),
                          ),
                        ),

                        const Divider(height: 8),

                        // Estimasi Selesai
                        InkWell(
                          onTap: () => _pickDate(context, false),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline,
                                    size: 18, color: _gold),
                                const SizedBox(width: 8),
                                const Text('Estimasi Selesai :',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500)),
                                const Spacer(),
                                Text(fmt.format(vm.estimasiSelesai),
                                    style:
                                        const TextStyle(fontSize: 13)),
                                const Icon(Icons.arrow_drop_down,
                                    color: Colors.grey),
                              ],
                            ),
                          ),
                        ),

                        const Divider(height: 8),

                        // Langsung Bayar toggle
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  vm.setLangsungBayar(!vm.langsungBayar),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: vm.langsungBayar
                                      ? _gold
                                      : Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.check,
                                        size: 14,
                                        color: vm.langsungBayar
                                            ? Colors.white
                                            : Colors.grey),
                                    const SizedBox(width: 4),
                                    Text('Langsung bayar',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: vm.langsungBayar
                                                ? Colors.white
                                                : Colors.grey)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Metode Bayar — dinamis dari OutletVM
                        Row(
                          children: [
                            const Text('Metode Bayar',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButton<String>(
                                  value: outletVM.metodeBayar
                                          .contains(vm.metodeBayar)
                                      ? vm.metodeBayar
                                      : outletVM.metodeBayar.first,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  // FIX: pakai metode dari OutletVM, bukan hardcoded
                                  items: outletVM.metodeBayar
                                      .map((m) => DropdownMenuItem(
                                            value: m,
                                            child: Text(m),
                                          ))
                                      .toList(),
                                  onChanged: (v) =>
                                      vm.setMetodeBayar(v ?? 'Cash'),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Diskon
                        _DiskonRow(vm: vm),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===== Footer Total + Bayar =====
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -2))
              ],
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Total Harga',
                        style: TextStyle(
                            fontSize: 12, color: Colors.black54)),
                    Text(
                      _fmt(vm.total),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () => _showKonfirmasi(context),
                  child: const Text('Bayar',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPilihPelanggan(BuildContext context) {
    final vm         = context.read<CustomerVM>();
    final searchCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.92,
          minChildSize: 0.4,
          expand: false,
          builder: (_, sc) => Column(
            children: [
              const SizedBox(height: 8),
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 12),
              const Text('Pilih Pelanggan',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: searchCtrl,
                  onChanged: (q) {
                    vm.search(q);
                    setS(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari nama / no HP...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: sc,
                  itemCount: vm.filtered.length,
                  itemBuilder: (_, i) {
                    final c = vm.filtered[i];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: (c.photo != null &&
                                File(c.photo!).existsSync())
                            ? FileImage(File(c.photo!))
                            : null,
                        child: c.photo == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(c.name),
                      subtitle: Text(c.phone),
                      onTap: () {
                        context.read<TransaksiVM>().setPelanggan(c);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== Cart Item Card =====
class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final VoidCallback onDelete;

  const _CartItemCard({required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE3EEF7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: (item.serviceType.image != null &&
                    File(item.serviceType.image!).existsSync())
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(File(item.serviceType.image!),
                        fit: BoxFit.cover))
                : const Icon(Icons.inventory_2,
                    color: Color(0xFF0A4174), size: 26),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.serviceType.name} (${item.service.name})',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
                Text(
                  'Rp.${item.serviceType.price.toInt()} /${item.unit.name}',
                  style: const TextStyle(
                      fontSize: 12, color: Colors.black54),
                ),
                if (item.perfume != null)
                  Row(
                    children: [
                      const Text('🍎 ',
                          style: TextStyle(fontSize: 12)),
                      Text(item.perfume!.name,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                Text(
                  'SubTotal : ${_fmt(item.subtotal)}',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                  icon: const Icon(Icons.close,
                      size: 16, color: Colors.red),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints()),
              const SizedBox(height: 4),
              Text(
                'Qty\n${item.qty % 1 == 0 ? item.qty.toInt() : item.qty} ${item.unit.name}',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===== Diskon Row =====
class _DiskonRow extends StatefulWidget {
  final TransaksiVM vm;
  const _DiskonRow({required this.vm});

  @override
  State<_DiskonRow> createState() => _DiskonRowState();
}

class _DiskonRowState extends State<_DiskonRow> {
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isPersen = widget.vm.diskonPersen;
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _ctrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (v) {
              final val = double.tryParse(v) ?? 0;
              widget.vm.setDiskon(val, isPersen);
            },
            decoration: InputDecoration(
              labelText: 'Diskon /Rupiah',
              labelStyle:
                  const TextStyle(color: _gold, fontSize: 12),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                final val = double.tryParse(_ctrl.text) ?? 0;
                widget.vm.setDiskon(val, false);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: !isPersen ? _gold : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    if (!isPersen)
                      const Icon(Icons.check,
                          size: 12, color: Colors.white),
                    const SizedBox(width: 2),
                    Text('Rupiah Rp',
                        style: TextStyle(
                            fontSize: 11,
                            color: !isPersen
                                ? Colors.white
                                : Colors.black54)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () {
                final val = double.tryParse(_ctrl.text) ?? 0;
                widget.vm.setDiskon(val, true);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isPersen ? _gold : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    if (isPersen)
                      const Icon(Icons.check,
                          size: 12, color: Colors.white),
                    const SizedBox(width: 2),
                    Text('Persen %',
                        style: TextStyle(
                            fontSize: 11,
                            color: isPersen
                                ? Colors.white
                                : Colors.black54)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$label  ',
            style: const TextStyle(fontWeight: FontWeight.w500)),
        Text(': $value',
            style: const TextStyle(color: Colors.black87)),
      ],
    );
  }
}