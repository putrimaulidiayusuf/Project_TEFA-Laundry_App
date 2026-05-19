import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/database/app_database.dart';
import '../viewmodels/pengeluaran_vm.dart';
import '../widgets/header.dart';
import '../widgets/no_data.dart';

const _kBlue = Color(0xFF003B73);
const _kBlueLight = Color(0xFF0A4174);
const _kBlueAccent = Color(0xFF1565C0);

final _currencyFmt = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

String _formatDate(DateTime d) => DateFormat('dd MMM yyyy', 'id_ID').format(d);

// ─────────────────────────────────────────────────────────────────────────────

class PengeluaranPage extends StatefulWidget {
  const PengeluaranPage({super.key});

  @override
  State<PengeluaranPage> createState() => _PengeluaranPageState();
}

class _PengeluaranPageState extends State<PengeluaranPage> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PengeluaranVM>().load();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openForm({Pengeluaran? item}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PengeluaranForm(item: item),
    ).then((_) {
      // refresh setelah form ditutup
      if (mounted) context.read<PengeluaranVM>().load();
    });
  }

  Future<void> _confirmDelete(BuildContext ctx, int id, String nama) async {
    final vm = ctx.read<PengeluaranVM>();
    final confirm = await showDialog<bool>(
      context: ctx,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Pengeluaran'),
        content: Text('Yakin hapus "$nama"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await vm.delete(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          HeaderWidget(
            title: 'Kelola Pengeluaran',
            action: IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              tooltip: 'Tambah Pengeluaran',
              onPressed: () => _openForm(),
            ),
          ),

          // ── Summary card ──
          Consumer<PengeluaranVM>(
            builder: (_, vm, __) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: _SummaryCard(
                hariIni: vm.totalHariIni,
                semua: vm.totalSemua,
              ),
            ),
          ),

          // ── Search bar ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (q) => context.read<PengeluaranVM>().search(q),
              decoration: InputDecoration(
                hintText: 'Cari nama / keterangan...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchCtrl.clear();
                          context.read<PengeluaranVM>().search('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
            ),
          ),

          // ── List ──
          Expanded(
            child: Consumer<PengeluaranVM>(
              builder: (ctx, vm, _) {
                if (vm.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: _kBlue),
                  );
                }
                if (vm.filtered.isEmpty) {
                  return const WidgetNoData();
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                  itemCount: vm.filtered.length,
                  itemBuilder: (_, i) {
                    final p = vm.filtered[i];
                    return _PengeluaranCard(
                      item: p,
                      onEdit: () => _openForm(item: p),
                      onDelete: () => _confirmDelete(ctx, p.id, p.nama),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // FAB
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        backgroundColor: _kBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
        elevation: 4,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Summary Card
// ─────────────────────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final double hariIni;
  final double semua;

  const _SummaryCard({required this.hariIni, required this.semua});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_kBlue, _kBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _kBlue.withValues(alpha:0.35),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              label: 'Total Hari Ini',
              amount: hariIni,
              icon: Icons.today_rounded,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.white30,
          ),
          Expanded(
            child: _SummaryItem(
              label: 'Total Semua',
              amount: semua,
              icon: Icons.account_balance_wallet_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;

  const _SummaryItem({
    required this.label,
    required this.amount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                color: Colors.white70, fontSize: 11, letterSpacing: 0.3)),
        const SizedBox(height: 4),
        Text(
          _currencyFmt.format(amount),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pengeluaran Card
// ─────────────────────────────────────────────────────────────────────────────

class _PengeluaranCard extends StatelessWidget {
  final Pengeluaran item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PengeluaranCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _kBlue.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.receipt_long_rounded,
              color: _kBlue, size: 22),
        ),
        title: Text(
          item.nama,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1A1A2E),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.keterangan != null && item.keterangan!.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                item.keterangan!,
                style: const TextStyle(
                    fontSize: 12, color: Colors.grey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today_rounded,
                    size: 11, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  _formatDate(item.tanggal),
                  style: const TextStyle(
                      fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _currencyFmt.format(item.jumlah),
                  style: const TextStyle(
                    color: Color(0xFFD32F2F),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onSelected: (v) {
                if (v == 'edit') onEdit();
                if (v == 'delete') onDelete();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit_outlined,
                          size: 18, color: _kBlueLight),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline,
                          size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Hapus',
                          style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Form Bottom Sheet (Tambah / Edit)
// ─────────────────────────────────────────────────────────────────────────────

class _PengeluaranForm extends StatefulWidget {
  final Pengeluaran? item;

  const _PengeluaranForm({this.item});

  @override
  State<_PengeluaranForm> createState() => _PengeluaranFormState();
}

class _PengeluaranFormState extends State<_PengeluaranForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _jumlahCtrl = TextEditingController();
  final _keteranganCtrl = TextEditingController();
  DateTime _tanggal = DateTime.now();
  bool _isSaving = false;

  bool get isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final p = widget.item!;
      _namaCtrl.text = p.nama;
      _jumlahCtrl.text = p.jumlah.toStringAsFixed(0);
      _keteranganCtrl.text = p.keterangan ?? '';
      _tanggal = p.tanggal;
    }
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _jumlahCtrl.dispose();
    _keteranganCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggal,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(primary: _kBlue),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _tanggal = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      final vm = context.read<PengeluaranVM>();
      final nama = _namaCtrl.text.trim();
      final jumlah = double.parse(
          _jumlahCtrl.text.replaceAll('.', '').replaceAll(',', '.'));
      final ket =
          _keteranganCtrl.text.trim().isEmpty ? null : _keteranganCtrl.text.trim();

      if (isEdit) {
        await vm.edit(
          id: widget.item!.id,
          nama: nama,
          jumlah: jumlah,
          keterangan: ket,
          tanggal: _tanggal,
        );
      } else {
        await vm.add(
          nama: nama,
          jumlah: jumlah,
          keterangan: ket,
          tanggal: _tanggal,
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _kBlue.withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.receipt_long_rounded,
                          color: _kBlue, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isEdit ? 'Edit Pengeluaran' : 'Tambah Pengeluaran',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _kBlue,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 16),

              // Form
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Nama
                      _buildField(
                        controller: _namaCtrl,
                        label: 'Nama Pengeluaran',
                        hint: 'Contoh: Beli deterjen',
                        icon: Icons.label_outline,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Nama tidak boleh kosong'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // Jumlah
                      _buildField(
                        controller: _jumlahCtrl,
                        label: 'Jumlah (Rp)',
                        hint: '50000',
                        icon: Icons.payments_outlined,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Jumlah tidak boleh kosong';
                          }
                          final n = double.tryParse(v);
                          if (n == null || n <= 0) {
                            return 'Masukkan jumlah yang valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Keterangan
                      _buildField(
                        controller: _keteranganCtrl,
                        label: 'Keterangan (opsional)',
                        hint: 'Catatan tambahan...',
                        icon: Icons.notes_outlined,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),

                      // Tanggal picker
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F7FA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded,
                                  color: _kBlue, size: 20),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Tanggal',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.grey)),
                                  Text(
                                    _formatDate(_tanggal),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: _kBlue,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const Icon(Icons.chevron_right,
                                  color: Colors.grey, size: 20),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Simpan Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kBlue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : Text(
                                  isEdit ? 'Simpan Perubahan' : 'Tambah',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: _kBlue, size: 20),
        filled: true,
        fillColor: const Color(0xFFF5F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      ),
    );
  }
}
