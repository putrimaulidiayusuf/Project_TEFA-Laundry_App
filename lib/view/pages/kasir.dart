import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:app_laundry/core/database/app_database.dart';
import 'package:app_laundry/view/viewmodels/kasir_vm.dart';
import 'package:app_laundry/view/widgets/header.dart';

// ─── Warna utama ──────────────────────────────────────────────────────────────
const _blue1 = Color(0xFF0A4174);
const _blueSoft = Color(0xFF5A86AE);
const _bgColor = Color(0xFFF4F6F8);

// =============================================================================
// PAGE: DAFTAR KASIR
// =============================================================================
class KasirPage extends StatefulWidget {
  const KasirPage({super.key});

  @override
  State<KasirPage> createState() => _KasirPageState();
}

class _KasirPageState extends State<KasirPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KasirVM>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(
        children: [
          HeaderWidget(
            title: 'Kelola Kasir',
            action: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => _openForm(context, null),
            ),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<KasirVM>(
      builder: (context, vm, _) {
        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator(color: _blue1));
        }
        if (vm.list.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.badge_outlined, size: 72, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text(
                  'Belum ada kasir',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _blue1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Tambah Kasir',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () => _openForm(context, null),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          itemCount: vm.list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) => _KasirCard(
            kasir: vm.list[i],
            onEdit: () => _openForm(context, vm.list[i]),
            onDelete: () => _confirmDelete(context, vm.list[i]),
          ),
        );
      },
    );
  }

  void _openForm(BuildContext ctx, Kasir? kasir) {
    Navigator.push(
      ctx,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: ctx.read<KasirVM>(),
          child: KasirFormPage(kasir: kasir),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext ctx, Kasir kasir) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Kasir'),
        content: Text('Yakin hapus kasir "${kasir.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              await ctx.read<KasirVM>().hapus(kasir.id);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// CARD KASIR
// =============================================================================
class _KasirCard extends StatelessWidget {
  final Kasir kasir;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _KasirCard({
    required this.kasir,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _avatar(kasir),
        title: Text(
          kasir.nama,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (kasir.noHp != null && kasir.noHp!.isNotEmpty)
              Text(kasir.noHp!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: kasir.isAktif
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                kasir.isAktif ? 'Aktif' : 'Nonaktif',
                style: TextStyle(
                  fontSize: 11,
                  color: kasir.isAktif ? Colors.green.shade700 : Colors.red.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: _blueSoft),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar(Kasir k) {
    if (k.fotoPath != null && k.fotoPath!.isNotEmpty) {
      final f = File(k.fotoPath!);
      if (f.existsSync()) {
        return CircleAvatar(
          radius: 26,
          backgroundImage: FileImage(f),
        );
      }
    }
    return CircleAvatar(
      radius: 26,
      backgroundColor: _blue1,
      child: Text(
        k.nama.isNotEmpty ? k.nama[0].toUpperCase() : '?',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}

// =============================================================================
// PAGE: FORM TAMBAH / EDIT KASIR
// =============================================================================
class KasirFormPage extends StatefulWidget {
  final Kasir? kasir;

  const KasirFormPage({super.key, this.kasir});

  @override
  State<KasirFormPage> createState() => _KasirFormPageState();
}

class _KasirFormPageState extends State<KasirFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaCtrl;
  late final TextEditingController _hpCtrl;
  bool _isAktif = true;
  File? _foto;
  String? _existingFotoPath;
  bool _loading = false;

  bool get isEdit => widget.kasir != null;

  @override
  void initState() {
    super.initState();
    final k = widget.kasir;
    _namaCtrl = TextEditingController(text: k?.nama ?? '');
    _hpCtrl = TextEditingController(text: k?.noHp ?? '');
    _isAktif = k?.isAktif ?? true;
    _existingFotoPath = k?.fotoPath;
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _hpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(
        children: [
          // ── HEADER ──────────────────────────────────────────────────────────
          HeaderWidget(title: isEdit ? 'Edit Kasir' : 'Tambah Kasir'),

          // ── AVATAR ──────────────────────────────────────────────────────────
          const SizedBox(height: 24),
          _buildAvatar(),
          const SizedBox(height: 24),

          // ── FORM ────────────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Nama Kasir *'),
                    _field(
                      controller: _namaCtrl,
                      hint: 'Masukkan nama kasir',
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),

                    _label('No Handphone'),
                    _field(
                      controller: _hpCtrl,
                      hint: '08xxxxxxxxxx',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    // Status aktif
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Status Aktif',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          Switch(
                            value: _isAktif,
                            activeColor: _blue1,
                            onChanged: (v) => setState(() => _isAktif = v),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ── BUTTON SIMPAN ──────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _blue1,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: _loading ? null : _simpan,
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                isEdit ? 'Simpan Perubahan' : 'Tambah Kasir',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── AVATAR PICKER ──────────────────────────────────────────────────────────
  Widget _buildAvatar() {
    Widget avatarChild;
    if (_foto != null) {
      avatarChild = ClipOval(
        child: Image.file(_foto!, fit: BoxFit.cover, width: 110, height: 110),
      );
    } else if (_existingFotoPath != null &&
        File(_existingFotoPath!).existsSync()) {
      avatarChild = ClipOval(
        child: Image.file(File(_existingFotoPath!),
            fit: BoxFit.cover, width: 110, height: 110),
      );
    } else {
      final initial = _namaCtrl.text.isNotEmpty
          ? _namaCtrl.text[0].toUpperCase()
          : '?';
      avatarChild = Container(
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
        avatarChild,
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _blueSoft,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
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
              title: const Text('Kamera'),
              onTap: () async {
                Navigator.pop(context);
                final f = await picker.pickImage(source: ImageSource.camera);
                if (f != null) setState(() => _foto = File(f.path));
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () async {
                Navigator.pop(context);
                final f = await picker.pickImage(source: ImageSource.gallery);
                if (f != null) setState(() => _foto = File(f.path));
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── FORM HELPERS ──────────────────────────────────────────────────────────
  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      );

  Widget _field({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
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

  // ── SIMPAN ────────────────────────────────────────────────────────────────
  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final vm = context.read<KasirVM>();
    final fotoPath = _foto?.path ?? _existingFotoPath;

    bool ok;
    if (isEdit) {
      ok = await vm.update(
        id: widget.kasir!.id,
        nama: _namaCtrl.text.trim(),
        noHp: _hpCtrl.text.trim().isEmpty ? null : _hpCtrl.text.trim(),
        fotoPath: fotoPath,
        isAktif: _isAktif,
      );
    } else {
      ok = await vm.tambah(
        nama: _namaCtrl.text.trim(),
        noHp: _hpCtrl.text.trim().isEmpty ? null : _hpCtrl.text.trim(),
        fotoPath: fotoPath,
      );
    }

    setState(() => _loading = false);
    if (ok && mounted) Navigator.pop(context);
  }
}
