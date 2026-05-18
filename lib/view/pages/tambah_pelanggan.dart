import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_laundry/view/widgets/header.dart';

// ─── Warna utama (sama dengan KasirPage) ─────────────────────────────────────
const _blue1    = Color(0xFF0A4174);
const _blueSoft = Color(0xFF5A86AE);
const _bgColor  = Color(0xFFF4F6F8);

class TambahPelangganPage extends StatefulWidget {
  /// Jika [pelanggan] diisi → mode Edit, jika null → mode Tambah
  final Map<String, dynamic>? pelanggan;

  const TambahPelangganPage({super.key, this.pelanggan});

  @override
  State<TambahPelangganPage> createState() => _TambahPelangganPageState();
}

class _TambahPelangganPageState extends State<TambahPelangganPage> {
  late final TextEditingController _namaController;
  late final TextEditingController _emailController;
  late final TextEditingController _noHpController;
  late final TextEditingController _alamatController;

  File?   _fotoProfil;
  String? _jenisKelamin;
  String? _existingFotoPath;

  final ImagePicker _picker = ImagePicker();

  bool get isEdit => widget.pelanggan != null;

  @override
  void initState() {
    super.initState();
    final p = widget.pelanggan;
    _namaController   = TextEditingController(text: p?['nama']          ?? '');
    _emailController  = TextEditingController(text: p?['email']         ?? '');
    _noHpController   = TextEditingController(text: p?['noHp']          ?? '');
    _alamatController = TextEditingController(text: p?['alamat']        ?? '');
    _jenisKelamin     = p?['jenisKelamin'];
    _existingFotoPath = p?['fotoProfil'];
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  // ── PILIH FOTO (logic tidak diubah) ─────────────────────────────────────────
  void _pilihFoto() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil dari Kamera'),
              onTap: () async {
                Navigator.pop(context);
                final f = await _picker.pickImage(source: ImageSource.camera);
                if (f != null) setState(() => _fotoProfil = File(f.path));
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Upload dari Galeri'),
              onTap: () async {
                Navigator.pop(context);
                final f = await _picker.pickImage(source: ImageSource.gallery);
                if (f != null) setState(() => _fotoProfil = File(f.path));
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── SIMPAN (logic tidak diubah) ──────────────────────────────────────────────
  void _simpan() {
    final nama   = _namaController.text.trim();
    final email  = _emailController.text.trim();
    final noHp   = _noHpController.text.trim();
    final alamat = _alamatController.text.trim();

    if (nama.isEmpty ||
        email.isEmpty ||
        noHp.isEmpty ||
        alamat.isEmpty ||
        _jenisKelamin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua data harus diisi')),
      );
      return;
    }

    final data = {
      'nama'        : nama,
      'email'       : email,
      'noHp'        : noHp,
      'jenisKelamin': _jenisKelamin,
      'alamat'      : alamat,
      'fotoProfil'  : _fotoProfil?.path ?? _existingFotoPath,
    };

    Navigator.pop(context, data);
  }

  // ── AVATAR (style KasirFormPage) ─────────────────────────────────────────────
  Widget _buildAvatar() {
    Widget avatarContent;

    if (_fotoProfil != null) {
      avatarContent = ClipOval(
        child: Image.file(_fotoProfil!,
            fit: BoxFit.cover, width: 110, height: 110),
      );
    } else if (_existingFotoPath != null &&
        File(_existingFotoPath!).existsSync()) {
      avatarContent = ClipOval(
        child: Image.file(File(_existingFotoPath!),
            fit: BoxFit.cover, width: 110, height: 110),
      );
    } else {
      final initial = _namaController.text.isNotEmpty
          ? _namaController.text[0].toUpperCase()
          : '?';
      avatarContent = Container(
        width: 110,
        height: 110,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: _blue1,
        ),
        alignment: Alignment.center,
        child: Text(
          initial,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        avatarContent,
        GestureDetector(
          onTap: _pilihFoto,
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _blueSoft,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child:
                const Icon(Icons.camera_alt, size: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // ── FORM HELPERS (style KasirFormPage) ──────────────────────────────────────
  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 13)),
      );

  Widget _field({
    required TextEditingController controller,
    required String hint,
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: _blueSoft)
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(
        children: [
          // ── HEADER ────────────────────────────────────────────────────────
          HeaderWidget(
              title: isEdit ? 'Edit Pelanggan' : 'Tambah Pelanggan'),

          // ── AVATAR ────────────────────────────────────────────────────────
          const SizedBox(height: 24),
          _buildAvatar(),
          const SizedBox(height: 24),

          // ── FORM ──────────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Nama Pelanggan *'),
                  _field(
                    controller: _namaController,
                    hint: 'Masukkan nama pelanggan',
                    prefixIcon: Icons.person,
                  ),
                  const SizedBox(height: 16),

                  _label('Email *'),
                  _field(
                    controller: _emailController,
                    hint: 'Masukkan email',
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  _label('No Handphone *'),
                  _field(
                    controller: _noHpController,
                    hint: '08xxxxxxxxxx',
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  // ── Jenis Kelamin ──────────────────────────────────────────
                  _label('Jenis Kelamin *'),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Pria'),
                          value: 'Laki-laki',
                          groupValue: _jenisKelamin,
                          onChanged: (v) =>
                              setState(() => _jenisKelamin = v),
                          activeColor: _blue1,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        const Divider(height: 1, indent: 16, endIndent: 16),
                        RadioListTile<String>(
                          title: const Text('Wanita'),
                          value: 'Perempuan',
                          groupValue: _jenisKelamin,
                          onChanged: (v) =>
                              setState(() => _jenisKelamin = v),
                          activeColor: _blue1,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  _label('Alamat *'),
                  _field(
                    controller: _alamatController,
                    hint: 'Masukkan alamat',
                    prefixIcon: Icons.home,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 30),

                  // ── TOMBOL SIMPAN ──────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _simpan,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: Text(
                        isEdit ? 'Simpan Perubahan' : 'Simpan',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _blue1,
                        padding:
                            const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}