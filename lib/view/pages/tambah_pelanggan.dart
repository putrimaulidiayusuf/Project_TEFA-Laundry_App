import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_laundry/view/widgets/header.dart';

// ─── Warna utama ──────────────────────────────────────────────────────────────
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
  final _formKey = GlobalKey<FormState>();

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

  // ── PILIH FOTO ───────────────────────────────────────────────────────────────
  void _pilihFoto() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Text(
              'Pilih Foto Profil',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _blue1),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _photoOption(
                    icon: Icons.camera_alt_outlined,
                    label: 'Kamera',
                    onTap: () async {
                      Navigator.pop(context);
                      final f = await _picker.pickImage(
                          source: ImageSource.camera);
                      if (f != null) {
                        setState(() => _fotoProfil = File(f.path));
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _photoOption(
                    icon: Icons.photo_library_outlined,
                    label: 'Galeri',
                    onTap: () async {
                      Navigator.pop(context);
                      final f = await _picker.pickImage(
                          source: ImageSource.gallery);
                      if (f != null) {
                        setState(() => _fotoProfil = File(f.path));
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _photoOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _blue1.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: _blue1, size: 32),
            const SizedBox(height: 8),
            Text(label,
                style: const TextStyle(
                    color: _blue1, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  // ── SIMPAN ───────────────────────────────────────────────────────────────────
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
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text('Semua data harus diisi'),
            ],
          ),
          backgroundColor: Colors.orange.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
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

  // ── AVATAR ───────────────────────────────────────────────────────────────────
  Widget _buildAvatar() {
    Widget inner;

    if (_fotoProfil != null) {
      inner = ClipOval(
        child: Image.file(_fotoProfil!,
            fit: BoxFit.cover, width: 100, height: 100),
      );
    } else if (_existingFotoPath != null &&
        File(_existingFotoPath!).existsSync()) {
      inner = ClipOval(
        child: Image.file(File(_existingFotoPath!),
            fit: BoxFit.cover, width: 100, height: 100),
      );
    } else {
      final initial = _namaController.text.isNotEmpty
          ? _namaController.text[0].toUpperCase()
          : '?';
      inner = Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF0A4174)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: _blue1.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          initial,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        inner,
        GestureDetector(
          onTap: _pilihFoto,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _blueSoft,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: _blueSoft.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // ── FORM FIELD ───────────────────────────────────────────────────────────────
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(icon, color: _blueSoft, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _blue1, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // ── HEADER ──────────────────────────────────────────────────────
            HeaderWidget(
                title: isEdit ? 'Edit Pelanggan' : 'Tambah Pelanggan'),

            // ── AVATAR SECTION ───────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  _buildAvatar(),
                  const SizedBox(height: 10),
                  Text(
                    'Tap foto untuk mengubah',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),

            // ── FORM ────────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Card: Informasi Dasar ────────────────────────────────
                    _sectionCard(
                      title: 'Informasi Dasar',
                      icon: Icons.person_outline,
                      children: [
                        _buildField(
                          controller: _namaController,
                          label: 'Nama Pelanggan *',
                          hint: 'Masukkan nama pelanggan',
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        _buildField(
                          controller: _emailController,
                          label: 'Email *',
                          hint: 'contoh@email.com',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        _buildField(
                          controller: _noHpController,
                          label: 'No. Handphone *',
                          hint: '08xxxxxxxxxx',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── Card: Jenis Kelamin ──────────────────────────────────
                    _sectionCard(
                      title: 'Jenis Kelamin *',
                      icon: Icons.wc_outlined,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(
                                    () => _jenisKelamin = 'Laki-laki'),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  decoration: BoxDecoration(
                                    color: _jenisKelamin == 'Laki-laki'
                                        ? _blue1
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _jenisKelamin == 'Laki-laki'
                                          ? _blue1
                                          : Colors.grey.shade300,
                                    ),
                                    boxShadow: _jenisKelamin == 'Laki-laki'
                                        ? [
                                            BoxShadow(
                                              color: _blue1
                                                  .withValues(alpha: 0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            )
                                          ]
                                        : [],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.male,
                                        size: 20,
                                        color: _jenisKelamin == 'Laki-laki'
                                            ? Colors.white
                                            : Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Pria',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: _jenisKelamin == 'Laki-laki'
                                              ? Colors.white
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(
                                    () => _jenisKelamin = 'Perempuan'),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  decoration: BoxDecoration(
                                    color: _jenisKelamin == 'Perempuan'
                                        ? _blue1
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _jenisKelamin == 'Perempuan'
                                          ? _blue1
                                          : Colors.grey.shade300,
                                    ),
                                    boxShadow: _jenisKelamin == 'Perempuan'
                                        ? [
                                            BoxShadow(
                                              color: _blue1
                                                  .withValues(alpha: 0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            )
                                          ]
                                        : [],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.female,
                                        size: 20,
                                        color: _jenisKelamin == 'Perempuan'
                                            ? Colors.white
                                            : Colors.grey.shade600,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Wanita',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: _jenisKelamin == 'Perempuan'
                                              ? Colors.white
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── Card: Alamat ─────────────────────────────────────────
                    _sectionCard(
                      title: 'Alamat',
                      icon: Icons.location_on_outlined,
                      children: [
                        _buildField(
                          controller: _alamatController,
                          label: 'Alamat Lengkap *',
                          hint: 'Masukkan alamat lengkap...',
                          icon: Icons.home_outlined,
                          maxLines: 3,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ── TOMBOL SIMPAN ────────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _simpan,
                        icon: Icon(
                          isEdit ? Icons.save_outlined : Icons.check_circle_outline,
                          color: Colors.white,
                        ),
                        label: Text(
                          isEdit ? 'Simpan Perubahan' : 'Simpan Pelanggan',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _blue1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
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
      ),
    );
  }

  // ── SECTION CARD HELPER ──────────────────────────────────────────────────────
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: [
              Icon(icon, color: _blue1, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _blue1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Divider(color: Colors.grey.shade100),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}