import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app_laundry/core/database/app_database.dart';
import 'package:app_laundry/view/widgets/header.dart';

const _blue = Color(0xFF003B73);
const _purple = Color(0xFF6A1B9A);
const _bg = Color(0xFFF0F4F8);

final _rp = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
final _fmtDate = DateFormat('dd MMM yyyy', 'id_ID');

class LaporanKasirPage extends StatefulWidget {
  const LaporanKasirPage({super.key});

  @override
  State<LaporanKasirPage> createState() => _LaporanKasirPageState();
}

class _LaporanKasirPageState extends State<LaporanKasirPage> {
  List<Kasir> _kasirs = [];
  Map<int, Map<String, dynamic>> _stats = {};
  bool _loading = false;
  DateTime _from = DateTime.now().subtract(const Duration(days: 29));
  DateTime _to = DateTime.now();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final db = context.read<AppDatabase>();
    final kasirs = await db.getKasirs();
    // Untuk saat ini, karena transaksi belum punya kolom kasirId,
    // kita tampilkan data kasir dengan info dasar
    setState(() {
      _kasirs = kasirs;
      _loading = false;
    });
  }

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(start: _from, end: _to),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: _blue)),
        child: child!,
      ),
    );
    if (range != null) {
      setState(() { _from = range.start; _to = range.end; });
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          const HeaderWidget(title: 'Laporan Kasir'),
          Expanded(
            child: Column(
              children: [
                // ── Filter Tanggal ──────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: GestureDetector(
                    onTap: _pickDateRange,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: _blue, size: 18),
                          const SizedBox(width: 8),
                          Text('${_fmtDate.format(_from)} – ${_fmtDate.format(_to)}',
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                          const Spacer(),
                          const Icon(Icons.edit_calendar, color: Colors.grey, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Summary ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [_purple, _purple.withValues(alpha: 0.7)],
                          begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: _purple.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.badge_rounded, color: Colors.white70, size: 28),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Kasir Terdaftar', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            Text('${_kasirs.length} Kasir', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                          child: Text('${_kasirs.where((k) => k.isAktif).length} Aktif',
                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator(color: _blue))
                      : _kasirs.isEmpty
                          ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.badge_outlined, size: 64, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Belum ada kasir', style: TextStyle(color: Colors.grey)),
                            ]))
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                              itemCount: _kasirs.length,
                              itemBuilder: (_, i) => _KasirCard(kasir: _kasirs[i], rank: i + 1),
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KasirCard extends StatelessWidget {
  final Kasir kasir;
  final int rank;
  const _KasirCard({required this.kasir, required this.rank});

  @override
  Widget build(BuildContext context) {
    Widget avatar;
    if (kasir.fotoPath != null && kasir.fotoPath!.isNotEmpty && File(kasir.fotoPath!).existsSync()) {
      avatar = CircleAvatar(radius: 26, backgroundImage: FileImage(File(kasir.fotoPath!)));
    } else {
      avatar = CircleAvatar(radius: 26, backgroundColor: _purple,
          child: Text(kasir.nama.isNotEmpty ? kasir.nama[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)));
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: avatar,
        title: Text(kasir.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (kasir.noHp != null && kasir.noHp!.isNotEmpty)
              Text(kasir.noHp!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: kasir.isAktif ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(kasir.isAktif ? 'Aktif' : 'Nonaktif',
                  style: TextStyle(fontSize: 11, color: kasir.isAktif ? Colors.green.shade700 : Colors.red.shade700, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _purple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.badge_rounded, color: _purple, size: 22),
        ),
      ),
    );
  }
}
