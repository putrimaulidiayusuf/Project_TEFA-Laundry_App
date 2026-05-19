import 'dart:io';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/database/app_database.dart';
import '../viewmodels/service_type_vm.dart';
import '../viewmodels/unit_vm.dart';
import '../widgets/header.dart';

// ─── Warna ─────────────────────────────────────────────────────────────────
const _blue1   = Color(0xFF0A4174);
const _blueSoft = Color(0xFF5A86AE);
const _bgColor  = Color(0xFFF4F6F8);

// ─── Preset gambar dari asset ───────────────────────────────────────────────
const List<Map<String, String>> _kPresetImages = [
  {'label': 'Baju',          'path': 'assets/baju.png'},
  {'label': 'Boneka',        'path': 'assets/boneka.png'},
  {'label': 'Karpet',        'path': 'assets/karpet.png'},
  {'label': 'Sepatu',        'path': 'assets/sepatu.png'},
  {'label': 'Kiloan',        'path': 'assets/kiloan.png'},
  {'label': 'Mesin Cuci',    'path': 'assets/mesin cuci.png'},
  {'label': 'Setrika',       'path': 'assets/strika.png'},
  {'label': 'Keranjang',     'path': 'assets/keranjang baju.png'},
  {'label': 'Bubble',        'path': 'assets/bubble.png'},
  {'label': 'Layanan',       'path': 'assets/layanan.png'},
];

/// Helper: tampilkan gambar dari path (asset atau file)
Widget buildImageFromPath(String path, {double size = 52, double radius = 8}) {
  if (path.startsWith('assets/')) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(path, width: size, height: size, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultImageWidget(size, radius)),
    );
  }
  final f = File(path);
  if (f.existsSync()) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.file(f, width: size, height: size, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultImageWidget(size, radius)),
    );
  }
  return _defaultImageWidget(size, radius);
}

Widget _defaultImageWidget(double size, double radius) {
  return Container(
    width: size, height: size,
    decoration: BoxDecoration(
      color: const Color(0xFFE3EEF7),
      borderRadius: BorderRadius.circular(radius),
    ),
    child: const Icon(Icons.inventory_2, color: _blue1, size: 26),
  );
}

// =============================================================================
class TambahJenisLayananPage extends StatefulWidget {
  final int serviceId;
  final ServiceType? existingType;

  const TambahJenisLayananPage({
    super.key,
    required this.serviceId,
    this.existingType,
  });

  @override
  State<TambahJenisLayananPage> createState() => _TambahJenisLayananPageState();
}

class _TambahJenisLayananPageState extends State<TambahJenisLayananPage> {
  final _namaCtrl      = TextEditingController();
  final _hargaCtrl     = TextEditingController();
  final _lamaCtrl      = TextEditingController();
  final _keteranganCtrl = TextEditingController();

  String? _imagePath;
  int?    _selectedUnitId;
  bool    _isHour = true;
  bool    _loading = false;

  bool get _isEdit => widget.existingType != null;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UnitVM>().load();
    });
    if (widget.existingType != null) {
      final t = widget.existingType!;
      _namaCtrl.text       = t.name;
      _hargaCtrl.text      = t.price.toInt().toString();
      _lamaCtrl.text       = t.estimateDay.toString();
      _keteranganCtrl.text = t.keterangan ?? '';
      _selectedUnitId      = t.unitId;
      _isHour              = t.isHour;
      _imagePath           = t.image;
    }
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _hargaCtrl.dispose();
    _lamaCtrl.dispose();
    _keteranganCtrl.dispose();
    super.dispose();
  }

  // ── Image Picker Bottom Sheet ─────────────────────────────────────────────
  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _ImagePickerSheet(
        currentPath: _imagePath,
        onSelected: (path) {
          setState(() => _imagePath = path);
        },
        onGallery: () async {
          Navigator.pop(context);
          final picked = await _picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 80,
          );
          if (picked != null && mounted) {
            setState(() => _imagePath = picked.path);
          }
        },
      ),
    );
  }

  // ── Simpan ────────────────────────────────────────────────────────────────
  Future<void> _simpan() async {
    if (_namaCtrl.text.trim().isEmpty) { _snack('Nama jenis layanan wajib diisi'); return; }
    if (_selectedUnitId == null)        { _snack('Pilih satuan terlebih dahulu');   return; }
    if (_hargaCtrl.text.trim().isEmpty) { _snack('Harga tidak boleh kosong');       return; }
    if (_lamaCtrl.text.trim().isEmpty)  { _snack('Lama pengerjaan wajib diisi');    return; }

    final price  = double.tryParse(_hargaCtrl.text.replaceAll(',', '').replaceAll('.', ''));
    final durasi = int.tryParse(_lamaCtrl.text);

    if (price == null)              { _snack('Harga tidak valid');           return; }
    if (durasi == null || durasi <= 0) { _snack('Lama pengerjaan tidak valid'); return; }

    final ket = _keteranganCtrl.text.trim().isEmpty ? null : _keteranganCtrl.text.trim();

    setState(() => _loading = true);

    if (_isEdit) {
      await context.read<AppDatabase>().updateServiceType(
        ServiceTypesCompanion(
          id:          Value(widget.existingType!.id),
          serviceId:   Value(widget.serviceId),
          name:        Value(_namaCtrl.text.trim()),
          unitId:      Value(_selectedUnitId!),
          price:       Value(price),
          estimateDay: Value(durasi),
          isHour:      Value(_isHour),
          image:       Value(_imagePath),
          keterangan:  Value(ket),
        ),
      );
    } else {
      await context.read<ServiceTypeVM>().add(
        serviceId:   widget.serviceId,
        name:        _namaCtrl.text.trim(),
        unitId:      _selectedUnitId!,
        price:       price,
        estimateDay: durasi,
        isHour:      _isHour,
        image:       _imagePath,
        keterangan:  ket,
      );
    }

    setState(() => _loading = false);
    if (mounted) Navigator.pop(context);
  }

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final units = context.watch<UnitVM>().units;

    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(
        children: [
          HeaderWidget(
            title: _isEdit ? 'Ubah Jenis Layanan' : 'Tambah Jenis Layanan',
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── GAMBAR ─────────────────────────────────────────────────
                  _buildImageSection(),
                  const SizedBox(height: 20),

                  // ── NAMA JENIS ─────────────────────────────────────────────
                  _buildCard(children: [
                    _sectionLabel('Nama Jenis Layanan'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _namaCtrl,
                      hint: 'Contoh: Reguler, Express, Kilat...',
                      icon: Icons.label_outline,
                    ),
                  ]),
                  const SizedBox(height: 12),

                  // ── SATUAN ─────────────────────────────────────────────────
                  _buildCard(children: [
                    _sectionLabel('Satuan'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildSatuanDropdown(units)),
                        const SizedBox(width: 10),
                        _buildAddSatuanBtn(),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 12),

                  // ── HARGA ──────────────────────────────────────────────────
                  _buildCard(children: [
                    _sectionLabel('Harga'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _hargaCtrl,
                      hint: '0',
                      icon: Icons.attach_money,
                      prefix: const Text('Rp  ',
                          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                      keyboardType: TextInputType.number,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ]),
                  const SizedBox(height: 12),

                  // ── LAMA PENGERJAAN ────────────────────────────────────────
                  _buildCard(children: [
                    _sectionLabel('Lama Pengerjaan'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _lamaCtrl,
                            hint: '0',
                            icon: Icons.access_time_outlined,
                            keyboardType: TextInputType.number,
                            formatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                        ),
                        const SizedBox(width: 10),
                        _buildJamHariToggle(),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 12),

                  // ── KETERANGAN ─────────────────────────────────────────────
                  _buildCard(children: [
                    _sectionLabel('Keterangan (Opsional)'),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _keteranganCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Catatan tambahan...',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                        filled: true,
                        fillColor: _bgColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: _blue1, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // ── SIMPAN BUTTON ──────────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blue1,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: _loading ? null : _simpan,
                child: _loading
                    ? const SizedBox(
                        width: 22, height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        _isEdit ? 'Simpan Perubahan' : 'Tambah Jenis Layanan',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section: Gambar ────────────────────────────────────────────────────────
  Widget _buildImageSection() {
    return GestureDetector(
      onTap: _showImagePicker,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            // Preview
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _bgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _imagePath != null ? _blue1 : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: _imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: _imagePath!.startsWith('assets/')
                          ? Image.asset(_imagePath!, fit: BoxFit.cover)
                          : Image.file(File(_imagePath!), fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: Colors.grey)),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined, color: Colors.grey.shade400, size: 30),
                        const SizedBox(height: 4),
                        Text('Pilih', style: TextStyle(fontSize: 11, color: Colors.grey.shade400)),
                      ],
                    ),
            ),

            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gambar Jenis Layanan',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _blue1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _imagePath != null ? 'Gambar terpilih ✓' : 'Tap untuk pilih gambar',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: _blue1,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.image_search, color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text('Ganti Gambar', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Widget _buildCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _blue1),
      );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    Widget? prefix,
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatters,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: formatters,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        prefix: prefix,
        prefixIcon: Icon(icon, color: _blueSoft, size: 20),
        filled: true,
        fillColor: _bgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _blue1, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }

  Widget _buildSatuanDropdown(List<Unit> units) {
    if (units.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE3EEF7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _blueSoft.withValues(alpha: 0.4)),
        ),
        child: const Text(
          'Belum ada satuan. Tap + untuk tambah.',
          style: TextStyle(color: _blue1, fontSize: 12),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButton<int>(
        value: _selectedUnitId,
        isExpanded: true,
        underline: const SizedBox(),
        hint: Text('Pilih Satuan', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
        items: units.map((u) => DropdownMenuItem(value: u.id, child: Text(u.name))).toList(),
        onChanged: (v) => setState(() => _selectedUnitId = v),
      ),
    );
  }

  Widget _buildAddSatuanBtn() {
    return GestureDetector(
      onTap: () => _showTambahSatuan(context),
      child: Container(
        width: 46, height: 46,
        decoration: BoxDecoration(color: _blue1, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildJamHariToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButton<bool>(
        value: _isHour,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: true, child: Text('Jam')),
          DropdownMenuItem(value: false, child: Text('Hari')),
        ],
        onChanged: (v) => setState(() => _isHour = v ?? true),
      ),
    );
  }

  Future<void> _showTambahSatuan(BuildContext context) async {
    final ctrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Tambah Satuan'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Kg, Pcs, Meter...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _blue1),
            onPressed: () async {
              if (ctrl.text.trim().isNotEmpty) {
                final vm = context.read<UnitVM>();
                await vm.add(ctrl.text.trim());
                final units = vm.units;
                if (units.isNotEmpty && mounted) setState(() => _selectedUnitId = units.last.id);
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// BOTTOM SHEET: Pilih Gambar (Preset + Galeri)
// =============================================================================
class _ImagePickerSheet extends StatelessWidget {
  final String? currentPath;
  final ValueChanged<String> onSelected;
  final VoidCallback onGallery;

  const _ImagePickerSheet({
    required this.currentPath,
    required this.onSelected,
    required this.onGallery,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Title
          const Text(
            'Pilih Gambar',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: _blue1),
          ),
          const SizedBox(height: 4),
          Text('Gambar yang tersedia untuk layanan',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          const SizedBox(height: 16),

          // Preset grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.78,
            ),
            itemCount: _kPresetImages.length,
            itemBuilder: (_, i) {
              final item = _kPresetImages[i];
              final path = item['path']!;
              final label = item['label']!;
              final isSelected = currentPath == path;

              return GestureDetector(
                onTap: () {
                  onSelected(path);
                  Navigator.pop(context);
                },
                child: Column(
                  children: [
                    Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(
                        color: isSelected ? _blue1.withValues(alpha: 0.1) : _bgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? _blue1 : Colors.grey.shade200,
                          width: 2,
                        ),
                      ),
                      padding: const EdgeInsets.all(9),
                      child: Image.asset(path, fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 24, color: Colors.grey)),
                    ),
                    const SizedBox(height: 4),
                    Text(label,
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected ? _blue1 : Colors.grey.shade600,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),

          // Pilih dari Galeri
          GestureDetector(
            onTap: onGallery,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _bgColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_library_outlined, color: _blueSoft, size: 20),
                  const SizedBox(width: 8),
                  const Text('Pilih dari Galeri',
                      style: TextStyle(fontWeight: FontWeight.w600, color: _blue1, fontSize: 14)),
                ],
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}