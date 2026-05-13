import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/database/app_database.dart';
import '../viewmodels/service_vm.dart';
import '../widgets/header.dart';
import 'tambah_jenis_layanan.dart';

class TambahLayananPage extends StatefulWidget {
  final Service? service;

  const TambahLayananPage({super.key, this.service});

  @override
  State<TambahLayananPage> createState() => _TambahLayananPageState();
}

class _TambahLayananPageState extends State<TambahLayananPage> {
  final name = TextEditingController();

  bool cuci = false;
  bool kering = false;
  bool setrika = false;

  List<ServiceType> jenisLayanan = [];

  /// Service yang sedang aktif — bisa dari widget.service (mode edit dari luar)
  /// atau dari hasil insert baru (mode tambah → setelah simpan berubah ke edit)
  Service? _activeService;

  bool get _isEdit => _activeService != null;

  @override
  void initState() {
    super.initState();

    if (widget.service != null) {
      _activeService = widget.service;
      name.text = widget.service!.name;
      cuci = widget.service!.cuci;
      kering = widget.service!.kering;
      setrika = widget.service!.setrika;
      _loadJenis();
    }
  }

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  Future<void> _loadJenis() async {
    if (_activeService == null) return;
    final db = context.read<AppDatabase>();
    final list = await db.getServiceTypes(_activeService!.id);
    setState(() => jenisLayanan = list);
  }

  Future<void> _simpan() async {
    if (name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama layanan tidak boleh kosong')),
      );
      return;
    }

    final vm = context.read<ServiceVM>();
    final db = context.read<AppDatabase>();

    if (_isEdit) {
      // ===== MODE EDIT: update data yang sudah ada =====
      await vm.edit(
        _activeService!.id,
        name.text.trim(),
        cuci,
        kering,
        setrika,
      );
      if (mounted) Navigator.pop(context);
    } else {
      // ===== MODE TAMBAH: insert baru, lalu aktifkan mode edit di halaman ini =====
      final newId = await vm.addAndGetId(
        name.text.trim(),
        cuci,
        kering,
        setrika,
      );

      if (!mounted) return;

      // Ambil service baru dari DB
      final services = await db.getServices();
      final newService = services.firstWhere((s) => s.id == newId);

      if (!mounted) return;

      // Langsung beralih ke mode edit di halaman yang SAMA — tidak perlu navigasi baru
      setState(() {
        _activeService = newService;
        jenisLayanan = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Layanan berhasil disimpan. Tambahkan jenis layanan!'),
          backgroundColor: const Color(0xFF0A4174),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(
            title: _isEdit ? 'Ubah Layanan' : 'Tambah Layanan',
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Nama Layanan =====
                  const Text(
                    'Nama Layanan',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: name,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Boneka, Gorden, Jaket...',
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ===== Proses =====
                  const Text(
                    'Proses',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _ProsesChip(
                        label: 'Cuci',
                        value: cuci,
                        onChanged: (v) => setState(() => cuci = v),
                      ),
                      const SizedBox(width: 10),
                      _ProsesChip(
                        label: 'Kering',
                        value: kering,
                        onChanged: (v) => setState(() => kering = v),
                      ),
                      const SizedBox(width: 10),
                      _ProsesChip(
                        label: 'Setrika',
                        value: setrika,
                        onChanged: (v) => setState(() => setrika = v),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ===== Jenis Layanan =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Jenis Layanan',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      if (_isEdit)
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TambahJenisLayananPage(
                                  serviceId: _activeService!.id,
                                ),
                              ),
                            ).then((_) => _loadJenis());
                          },
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text(
                            'Tambah Jenis Layanan',
                            style: TextStyle(fontSize: 12),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A4174),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Konten jenis layanan
                  if (!_isEdit)
                    _InfoSimpanDuluWidget()
                  else if (jenisLayanan.isEmpty)
                    _NoJenisWidget()
                  else
                    ...jenisLayanan.map((jenis) => _JenisCard(
                          jenis: jenis,
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TambahJenisLayananPage(
                                  serviceId: _activeService!.id,
                                  existingType: jenis,
                                ),
                              ),
                            ).then((_) => _loadJenis());
                          },
                          onDelete: () async {
                            await context
                                .read<AppDatabase>()
                                .deleteServiceType(jenis.id);
                            _loadJenis();
                          },
                        )),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // ===== Tombol Simpan =====
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A4174),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: _simpan,
              child: Text(
                _isEdit ? 'Simpan Perubahan' : 'Simpan',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Info simpan dulu (mode tambah baru) =====
class _InfoSimpanDuluWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline, color: Color(0xFFFF8F00), size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Simpan layanan terlebih dahulu untuk dapat menambahkan jenis layanan.',
              style: TextStyle(fontSize: 13, color: Color(0xFF7B5800)),
            ),
          ),
        ],
      ),
    );
  }
}

// ===== Chip checkbox proses =====
class _ProsesChip extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ProsesChip({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: value ? const Color(0xFF0A4174) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF0A4174),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value ? Icons.check_box : Icons.check_box_outline_blank,
              size: 18,
              color: value ? Colors.white : const Color(0xFF0A4174),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: value ? Colors.white : const Color(0xFF0A4174),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== Widget no data jenis =====
class _NoJenisWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Icon(
          Icons.search_off_rounded,
          size: 70,
          color: const Color(0xFFFF8F00).withValues(alpha: 0.7),
        ),
        const SizedBox(height: 8),
        const Text(
          'Data Jenis Tidak Di temukan',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// ===== Card jenis layanan mini =====
class _JenisCard extends StatelessWidget {
  final ServiceType jenis;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _JenisCard({
    required this.jenis,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final durasi =
        jenis.isHour ? '${jenis.estimateDay} Jam' : '${jenis.estimateDay} Hari';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Gambar/icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFE3EEF7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.inventory_2,
                color: Color(0xFF0A4174), size: 24),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jenis.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
                Text(
                  'Rp.${jenis.price.toInt()} • $durasi',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined,
                color: Color(0xFF0A4174), size: 20),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}