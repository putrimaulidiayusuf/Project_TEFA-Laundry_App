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

class TambahJenisLayananPage extends StatefulWidget {
  final int serviceId;
  final ServiceType? existingType; // null = tambah baru, non-null = edit

  const TambahJenisLayananPage({
    super.key,
    required this.serviceId,
    this.existingType,
  });

  @override
  State<TambahJenisLayananPage> createState() =>
      _TambahJenisLayananPageState();
}

class _TambahJenisLayananPageState extends State<TambahJenisLayananPage> {
  final _namaCtrl = TextEditingController();
  final _hargaCtrl = TextEditingController();
  final _lamaCtrl = TextEditingController();
  final _keteranganCtrl = TextEditingController();

  String? _imagePath;
  int? _selectedUnitId;
  bool _isHour = true; // true = Jam, false = Hari

  bool get _isEdit => widget.existingType != null;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UnitVM>().load();
    });

    // Isi form jika mode edit
    if (widget.existingType != null) {
      final t = widget.existingType!;
      _namaCtrl.text = t.name;
      _hargaCtrl.text = t.price.toInt().toString();
      _lamaCtrl.text = t.estimateDay.toString();
      _keteranganCtrl.text = t.keterangan ?? '';
      _selectedUnitId = t.unitId;
      _isHour = t.isHour;
      _imagePath = t.image;
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

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil dari Kamera'),
              onTap: () async {
                Navigator.pop(context);
                final picked = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 75,
                );
                if (picked != null) setState(() => _imagePath = picked.path);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () async {
                Navigator.pop(context);
                final picked = await _picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 75,
                );
                if (picked != null) setState(() => _imagePath = picked.path);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _simpan() async {
    // Validasi
    if (_namaCtrl.text.trim().isEmpty) {
      _snack('Nama jenis layanan tidak boleh kosong');
      return;
    }
    if (_selectedUnitId == null) {
      _snack('Pilih satuan terlebih dahulu');
      return;
    }
    if (_hargaCtrl.text.trim().isEmpty) {
      _snack('Harga tidak boleh kosong');
      return;
    }
    if (_lamaCtrl.text.trim().isEmpty) {
      _snack('Lama pengerjaan tidak boleh kosong');
      return;
    }

    final price = double.tryParse(
        _hargaCtrl.text.replaceAll(',', '').replaceAll('.', ''));
    final durasi = int.tryParse(_lamaCtrl.text);

    if (price == null) {
      _snack('Harga tidak valid');
      return;
    }
    if (durasi == null || durasi <= 0) {
      _snack('Lama pengerjaan tidak valid');
      return;
    }

    final keterangan = _keteranganCtrl.text.trim().isEmpty
        ? null
        : _keteranganCtrl.text.trim();

    if (_isEdit) {
      // ===== MODE EDIT: update data yang sudah ada =====
      final db = context.read<AppDatabase>();
      await db.updateServiceType(
        ServiceTypesCompanion(
          id: Value(widget.existingType!.id),
          serviceId: Value(widget.serviceId),
          name: Value(_namaCtrl.text.trim()),
          unitId: Value(_selectedUnitId!),
          price: Value(price),
          estimateDay: Value(durasi),
          isHour: Value(_isHour),
          image: Value(_imagePath),
          keterangan: Value(keterangan),
        ),
      );
    } else {
      // ===== MODE TAMBAH: insert baru =====
      await context.read<ServiceTypeVM>().add(
            serviceId: widget.serviceId,
            name: _namaCtrl.text.trim(),
            unitId: _selectedUnitId!,
            price: price,
            estimateDay: durasi,
            isHour: _isHour,
            image: _imagePath,
            keterangan: keterangan,
          );
    }

    if (mounted) Navigator.pop(context);
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final units = context.watch<UnitVM>().units;

    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(
            title: _isEdit ? 'Ubah Jenis Layanan' : 'Tambah Jenis Layanan',
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== Gambar =====
                  const _Label('Gambar'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Preview gambar
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEEEEE),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: _imagePath != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(_imagePath!),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A4174),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Pilih Gambar'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ===== Nama Jenis =====
                  const _Label('Nama Jenis'),
                  const SizedBox(height: 6),
                  _InputField(
                    controller: _namaCtrl,
                    hint: 'Contoh: Reguler, Ekspress, Kilat...',
                  ),

                  const SizedBox(height: 18),

                  // ===== Satuan =====
                  const _Label('Satuan'),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: units.isEmpty
                            ? const Text(
                                'Belum ada satuan. Tambahkan di menu Satuan.',
                                style: TextStyle(
                                    color: Colors.orange, fontSize: 12),
                              )
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                ),
                                child: DropdownButton<int>(
                                  value: _selectedUnitId,
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  hint: const Text('Pilih Satuan'),
                                  items: units
                                      .map((u) => DropdownMenuItem(
                                            value: u.id,
                                            child: Text(u.name),
                                          ))
                                      .toList(),
                                  onChanged: (v) =>
                                      setState(() => _selectedUnitId = v),
                                ),
                              ),
                      ),
                      const SizedBox(width: 10),
                      // Tombol tambah satuan cepat
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A4174),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          tooltip: 'Tambah Satuan',
                          onPressed: () => _showTambahSatuan(context),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ===== Harga =====
                  const _Label('Harga'),
                  const SizedBox(height: 6),
                  _InputField(
                    controller: _hargaCtrl,
                    hint: '0',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    prefix: const Text(
                      'Rp  ',
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.w500),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ===== Lama Pengerjaan =====
                  const _Label('Lama Pengerjaan'),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: _InputField(
                          controller: _lamaCtrl,
                          hint: '0',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Toggle Jam / Hari
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButton<bool>(
                          value: _isHour,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(
                                value: true, child: Text('Jam')),
                            DropdownMenuItem(
                                value: false, child: Text('Hari')),
                          ],
                          onChanged: (v) =>
                              setState(() => _isHour = v ?? true),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // ===== Keterangan =====
                  const _Label('Keterangan'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _keteranganCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Opsional...',
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
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

  Future<void> _showTambahSatuan(BuildContext context) async {
    final ctrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Satuan'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
              hintText: 'Nama satuan (Kg, Pcs, Meter...)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A4174)),
            onPressed: () async {
              if (ctrl.text.trim().isNotEmpty) {
                final unitVM = context.read<UnitVM>();
                await unitVM.add(ctrl.text.trim());
                final units = unitVM.units;
                if (units.isNotEmpty && mounted) {
                  setState(() => _selectedUnitId = units.last.id);
                }
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child:
                const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ===== Reusable label =====
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    );
  }
}

// ===== Reusable input field =====
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;

  const _InputField({
    required this.controller,
    this.hint,
    this.keyboardType,
    this.inputFormatters,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hint,
        prefix: prefix,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}