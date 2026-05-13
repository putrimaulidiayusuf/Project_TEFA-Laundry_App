import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/database/app_database.dart';
import '../viewmodels/transaksi_vm.dart';
import '../viewmodels/perfume_vm.dart';
import '../viewmodels/unit_vm.dart';

const _gold = Color(0xFF0A4174);

class PilihLayananPage extends StatefulWidget {
  const PilihLayananPage({super.key});

  @override
  State<PilihLayananPage> createState() => _PilihLayananPageState();
}

class _PilihLayananPageState extends State<PilihLayananPage> {
  List<ServiceWithTypes> _all = [];
  List<ServiceWithTypes> _filtered = [];
  final _search = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = context.read<AppDatabase>();
    final unitVM = context.read<UnitVM>();
    final data = await db.getServicesWithTypes();
    if (!unitVM.units.isNotEmpty) await unitVM.load();
    setState(() {
      _all = data.where((s) => s.types.isNotEmpty).toList();
      _filtered = _all;
      _loading = false;
    });
  }

  void _doSearch(String q) {
    final lq = q.toLowerCase();
    setState(() {
      _filtered = _all.where((s) {
        return s.service.name.toLowerCase().contains(lq) ||
            s.types.any((t) => t.name.toLowerCase().contains(lq));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ===== Header =====
          Container(
            color: _gold,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Pilih Layanan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ===== Search Bar =====
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _search,
                    onChanged: _doSearch,
                    decoration: InputDecoration(
                      hintText: 'Cari',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.sort, color: Colors.grey),
                ),
              ],
            ),
          ),

          // ===== List Layanan =====
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _gold))
                : _filtered.isEmpty
                    ? const Center(
                        child: Text('Belum ada layanan',
                            style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: _filtered.length,
                        itemBuilder: (_, i) {
                          final s = _filtered[i];
                          return _ServiceGroup(
                            data: s,
                            onTypeTap: (type) =>
                                _showQtyDialog(context, s.service, type),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _showQtyDialog(
      BuildContext context, Service service, ServiceType type) {
    final units = context.read<UnitVM>().units;
    final perfumes = context.read<PerfumeVM>().perfumes;
    final unitName =
        units.firstWhere((u) => u.id == type.unitId,
            orElse: () => Unit(id: 0, name: '')).name;

    final qtyCtrl = TextEditingController();
    Perfume? selectedPerfume;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
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
                  // Title
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Text(
                      '${type.name} (${service.name} )',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Body (white card)
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
                        // Qty
                        const Text(
                          'Masukan jumlah Kuantitas',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: qtyCtrl,
                          keyboardType:
                              const TextInputType.numberWithOptions(
                                  decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.]')),
                          ],
                          decoration: InputDecoration(
                            hintText: 'Qty',
                            prefixIcon: const Icon(Icons.hourglass_bottom,
                                color: _gold),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.grey.shade300),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '(Gunakan tanda titik (.) untuk angka desimal)',
                          style:
                              TextStyle(fontSize: 11, color: Colors.grey),
                        ),

                        const SizedBox(height: 14),

                        // Pilih Parfum
                        const Text(
                          'Pilih Parfum',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.grey.shade300),
                          ),
                          child: DropdownButton<Perfume?>(
                            value: selectedPerfume,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: Row(
                              children: const [
                                Text('🍎 '),
                                Text('Pilih Parfum'),
                              ],
                            ),
                            items: [
                              const DropdownMenuItem<Perfume?>(
                                value: null,
                                child: Text('— Tanpa Parfum —'),
                              ),
                              ...perfumes.map((p) => DropdownMenuItem(
                                    value: p,
                                    child: Row(
                                      children: [
                                        const Text('🍎 '),
                                        Text(p.name),
                                      ],
                                    ),
                                  )),
                            ],
                            onChanged: (v) =>
                                setS(() => selectedPerfume = v),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Tombol Simpan
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              side: BorderSide(
                                  color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                            ),
                            onPressed: () {
                              final qtyVal = double.tryParse(
                                  qtyCtrl.text.trim());
                              if (qtyVal == null || qtyVal <= 0) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Masukkan kuantitas yang valid'),
                                ));
                                return;
                              }

                              final unit = units.firstWhere(
                                (u) => u.id == type.unitId,
                                orElse: () =>
                                    Unit(id: 0, name: unitName),
                              );

                              context.read<TransaksiVM>().addItem(
                                    CartItem(
                                      serviceType: type,
                                      service: service,
                                      unit: unit,
                                      qty: qtyVal,
                                      perfume: selectedPerfume,
                                    ),
                                  );

                              Navigator.pop(ctx);
                              Navigator.pop(context); // kembali ke checkout
                            },
                            child: const Text(
                              'Simpan',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ===== Group satu service beserta list types-nya =====
class _ServiceGroup extends StatelessWidget {
  final ServiceWithTypes data;
  final void Function(ServiceType) onTypeTap;

  const _ServiceGroup({required this.data, required this.onTypeTap});

  @override
  Widget build(BuildContext context) {
    final s = data.service;
    final units = context.watch<UnitVM>().units;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                s.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 4),
              _ProsesRow(service: s),
            ],
          ),
        ),

        // Type items
        ...data.types.map((t) {
          final unitName = units
              .firstWhere((u) => u.id == t.unitId,
                  orElse: () => Unit(id: 0, name: ''))
              .name;
          final durasi = t.isHour
              ? '${t.estimateDay} Jam'
              : '${t.estimateDay} Hari';

          return InkWell(
            onTap: () => onTypeTap(t),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  // Gambar
                  _TypeImage(imagePath: t.image),
                  const SizedBox(width: 12),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(t.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14)),
                        Text(
                          'Rp.${t.price.toInt()}/ $unitName',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black87),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 12, color: _gold),
                            const SizedBox(width: 3),
                            Text(durasi,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),

        Divider(color: Colors.grey.shade200, height: 8),
      ],
    );
  }
}

class _ProsesRow extends StatelessWidget {
  final Service service;
  const _ProsesRow({required this.service});

  @override
  Widget build(BuildContext context) {
    final proses = <String>[];
    if (service.cuci) proses.add('cuci');
    if (service.kering) proses.add('kering');
    if (service.setrika) proses.add('setrika');

    final icons = {
      'cuci': '🧺',
      'kering': '🌀',
      'setrika': '🫳',
    };

    final widgets = <Widget>[];
    for (var i = 0; i < proses.length; i++) {
      widgets.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(color: _gold),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${icons[proses[i]] ?? ''} ${proses[i][0].toUpperCase()}${proses[i].substring(1)}',
          style:
              const TextStyle(fontSize: 11, color: Colors.black87),
        ),
      ));
      if (i < proses.length - 1) {
        widgets.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text('>>',
              style: TextStyle(fontSize: 11, color: Colors.grey)),
        ));
      }
    }

    return Row(children: widgets);
  }
}

class _TypeImage extends StatelessWidget {
  final String? imagePath;
  const _TypeImage({this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFE3EEF7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: imagePath != null && File(imagePath!).existsSync()
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(File(imagePath!), fit: BoxFit.cover),
            )
          : const Icon(Icons.inventory_2,
              color: Color(0xFF0A4174), size: 28),
    );
  }
}
