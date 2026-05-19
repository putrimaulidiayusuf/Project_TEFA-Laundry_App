import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_laundry/view/widgets/header.dart';
import '../viewmodels/unit_vm.dart';
import '../../core/database/app_database.dart';

// ─── Warna utama (sama dengan KasirPage & PelangganPage) ──────────────────────
const _blue1    = Color(0xFF0A4174);
const _blueSoft = Color(0xFF5A86AE);
const _bgColor  = Color(0xFFF4F6F8);

class SatuanPage extends StatefulWidget {
  const SatuanPage({super.key});

  @override
  State<SatuanPage> createState() => _SatuanPageState();
}

class _SatuanPageState extends State<SatuanPage> {
  final TextEditingController _searchController = TextEditingController();

  // ── Bottom Sheet Form Tambah / Edit ─────────────────────────────────────────
  void _showForm({Unit? satuan}) {
    final isEdit = satuan != null;
    final ctrl = TextEditingController(text: satuan?.name ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Drag handle ────────────────────────────────────────────────
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // ── Judul ──────────────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _blue1.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                        'assets/kiloan.png',
                        width: 22,
                        height: 22,
                        fit: BoxFit.contain,
                      ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEdit ? 'Edit Satuan' : 'Tambah Satuan',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _blue1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Label ──────────────────────────────────────────────────────
              const Text(
                'Nama Satuan *',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF374151),
                ),
              ),
              const SizedBox(height: 8),

              // ── Input Field ────────────────────────────────────────────────
              TextField(
                controller: ctrl,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Contoh: Kg, Pcs, Lusin...',
                  prefixIcon: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/kiloan.png',
                        width: 22,
                        height: 22,
                        fit: BoxFit.contain,
                      ),
                    ),
                  filled: true,
                  fillColor: const Color(0xFFF4F6F8),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _blue1, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // ── Tombol ─────────────────────────────────────────────────────
              Row(
                children: [
                  // Batal
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _blue1,
                        side: const BorderSide(color: _blue1),
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Batal',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Simpan
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final nama = ctrl.text.trim();
                        if (nama.isEmpty) return;
                        final vm = context.read<UnitVM>();
                        if (isEdit) {
                          vm.update(satuan.id, nama);
                        } else {
                          vm.add(nama);
                        }
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        isEdit ? Icons.save_outlined : Icons.add,
                        color: Colors.white,
                        size: 18,
                      ),
                      label: Text(
                        isEdit ? 'Simpan Perubahan' : 'Tambah Satuan',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _blue1,
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Konfirmasi Hapus ─────────────────────────────────────────────────────────
  void _confirmDelete(BuildContext ctx, Unit satuan) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
            SizedBox(width: 8),
            Text('Hapus Satuan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black87, fontSize: 14),
            children: [
              const TextSpan(text: 'Yakin ingin menghapus satuan '),
              TextSpan(
                text: '"${satuan.name}"',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: _blue1),
              ),
              const TextSpan(text: '?'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal',
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              ctx.read<UnitVM>().delete(satuan.id);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Hapus',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UnitVM>();

    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────────
          const HeaderWidget(title: 'Kelola Satuan'),
          const SizedBox(height: 20),

          // ── Search Field ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: vm.search,
              decoration: InputDecoration(
                hintText: 'Cari satuan...',
                prefixIcon:
                    const Icon(Icons.search, color: _blue1),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── List / Empty State ────────────────────────────────────────────
          Expanded(
            child: vm.filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                            'assets/kiloan.png',
                            width: 72,
                            height: 72,
                            color: Colors.grey.shade400,
                          ),
                        const SizedBox(height: 12),
                        Text(
                          'Belum ada satuan',
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    itemCount: vm.filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                    itemBuilder: (ctx, i) {
                      final satuan = vm.filtered[i];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withValues(alpha: 0.07),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),

                          // ── Icon Avatar ─────────────────────────────────
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _blue1.withValues(alpha: 0.15),
                                  _blueSoft.withValues(alpha: 0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              'assets/kiloan.png',
                              fit: BoxFit.contain,
                            ),
                          ),

                          title: Text(
                            satuan.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                          subtitle: Text(
                            'Satuan #${satuan.id}',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500),
                          ),

                          // ── Trailing: Edit + Delete ──────────────────────
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit
                              Container(
                                decoration: BoxDecoration(
                                  color: _blue1.withValues(alpha: 0.08),
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                      Icons.edit_outlined,
                                      color: _blue1,
                                      size: 20),
                                  onPressed: () =>
                                      _showForm(satuan: satuan),
                                  tooltip: 'Edit',
                                  constraints: const BoxConstraints(
                                      minWidth: 36, minHeight: 36),
                                  padding: const EdgeInsets.all(8),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Hapus
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.red
                                      .withValues(alpha: 0.08),
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 20),
                                  onPressed: () =>
                                      _confirmDelete(ctx, satuan),
                                  tooltip: 'Hapus',
                                  constraints: const BoxConstraints(
                                      minWidth: 36, minHeight: 36),
                                  padding: const EdgeInsets.all(8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // ── Tombol Tambah ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => _showForm(),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Tambah Satuan',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _blue1,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}