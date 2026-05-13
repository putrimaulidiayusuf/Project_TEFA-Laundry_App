import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app_laundry/core/database/app_database.dart';
import 'package:app_laundry/view/widgets/header.dart';

const _blue = Color(0xFF003B73);
const _teal = Color(0xFF00838F);
const _bg = Color(0xFFF0F4F8);

final _rp = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
final _fmtDate = DateFormat('dd MMM yyyy', 'id_ID');

class LaporanMetodeBayarPage extends StatefulWidget {
  const LaporanMetodeBayarPage({super.key});

  @override
  State<LaporanMetodeBayarPage> createState() => _LaporanMetodeBayarPageState();
}

class _LaporanMetodeBayarPageState extends State<LaporanMetodeBayarPage> {
  List<Map<String, dynamic>> _data = [];
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
    final fromStart = DateTime(_from.year, _from.month, _from.day);
    final toEnd = DateTime(_to.year, _to.month, _to.day, 23, 59, 59);
    final result = await db.getLaporanMetodeBayar(from: fromStart, to: toEnd);
    setState(() { _data = result; _loading = false; });
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

  double get _grandTotal => _data.fold(0, (s, d) => s + (d['total'] as double));
  int get _grandJumlah => _data.fold(0, (s, d) => s + (d['jumlah'] as int));

  static const _methodColors = [
    Color(0xFF1565C0), Color(0xFF2E7D32), Color(0xFF6A1B9A),
    Color(0xFFE65100), Color(0xFF00838F), Color(0xFFC62828),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          const HeaderWidget(title: 'Laporan Metode Bayar'),
          Expanded(
            child: Column(
              children: [
                // ── Filter tanggal ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
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
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [_teal, _teal.withValues(alpha: 0.7)],
                          begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: _teal.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _summStat('Total Omzet', _rp.format(_grandTotal), Icons.attach_money_rounded)),
                        Container(width: 1, height: 40, color: Colors.white24),
                        Expanded(child: _summStat('Total Transaksi', '$_grandJumlah', Icons.receipt_long_rounded)),
                        Container(width: 1, height: 40, color: Colors.white24),
                        Expanded(child: _summStat('Metode', '${_data.length}', Icons.payment_rounded)),
                      ],
                    ),
                  ),
                ),

                // ── Bar Chart Visual ───────────────────────────────────
                if (!_loading && _data.isNotEmpty && _grandTotal > 0)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Distribusi Metode Bayar',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 12),
                          ..._data.asMap().entries.map((entry) {
                            final i = entry.key;
                            final d = entry.value;
                            final pct = (d['total'] as double) / _grandTotal;
                            final color = _methodColors[i % _methodColors.length];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(d['metode'] as String,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                                      Text('${(pct * 100).toStringAsFixed(1)}%',
                                          style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: pct,
                                      backgroundColor: Colors.grey.shade100,
                                      valueColor: AlwaysStoppedAnimation(color),
                                      minHeight: 10,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),

                // ── List ───────────────────────────────────────────────
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator(color: _blue))
                      : _data.isEmpty
                          ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.payment_outlined, size: 64, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Tidak ada data', style: TextStyle(color: Colors.grey)),
                            ]))
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                              itemCount: _data.length,
                              itemBuilder: (_, i) {
                                final d = _data[i];
                                final color = _methodColors[i % _methodColors.length];
                                final pct = _grandTotal > 0 ? (d['total'] as double) / _grandTotal * 100 : 0;
                                return _MetodeCard(
                                  metode: d['metode'] as String,
                                  jumlah: d['jumlah'] as int,
                                  total: d['total'] as double,
                                  pct: pct.toDouble(),
                                  color: color,
                                  rank: i + 1,
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summStat(String label, String value, IconData icon) => Column(children: [
    Icon(icon, color: Colors.white70, size: 18),
    const SizedBox(height: 4),
    Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
    Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
  ]);
}

class _MetodeCard extends StatelessWidget {
  final String metode;
  final int jumlah;
  final double total;
  final double pct;
  final Color color;
  final int rank;

  const _MetodeCard({required this.metode, required this.jumlah, required this.total, required this.pct, required this.color, required this.rank});

  @override
  Widget build(BuildContext context) {
    final rp = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.payment_rounded, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(metode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('$jumlah transaksi · ${pct.toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Text(rp.format(total), style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }
}
