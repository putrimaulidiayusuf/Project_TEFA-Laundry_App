import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app_laundry/core/database/app_database.dart';
import 'package:app_laundry/view/widgets/header.dart';

const _blue = Color(0xFF003B73);
const _bg = Color(0xFFF0F4F8);

final _rp = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
final _fmtDate = DateFormat('dd MMM yyyy', 'id_ID');
final _fmtDateTime = DateFormat('dd/MM/yy HH:mm', 'id_ID');

class LaporanTransaksiPage extends StatefulWidget {
  const LaporanTransaksiPage({super.key});

  @override
  State<LaporanTransaksiPage> createState() => _LaporanTransaksiPageState();
}

class _LaporanTransaksiPageState extends State<LaporanTransaksiPage> {
  List<TransactionWithDetails> _data = [];
  bool _loading = false;
  DateTime _from = DateTime.now().subtract(const Duration(days: 29));
  DateTime _to = DateTime.now();
  String _statusFilter = 'semua';

  static const _statuses = [
    'semua', 'antrian', 'proses', 'siap_ambil', 'selesai', 'batal'
  ];
  static const _statusLabels = {
    'semua': 'Semua',
    'antrian': 'Antrian',
    'proses': 'Proses',
    'siap_ambil': 'Siap Ambil',
    'selesai': 'Selesai',
    'batal': 'Batal',
  };

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
    final result = await db.getLaporanTransaksi(
        from: fromStart, to: toEnd, status: _statusFilter);
    setState(() {
      _data = result;
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
        data: ThemeData.light()
            .copyWith(colorScheme: const ColorScheme.light(primary: _blue)),
        child: child!,
      ),
    );
    if (range != null) {
      setState(() {
        _from = range.start;
        _to = range.end;
      });
      _load();
    }
  }

  double get _totalOmzet => _data.fold(0, (s, d) => s + d.trx.total);
  double get _totalDiskon => _data.fold(0, (s, d) => s + d.trx.diskon);
  int get _jumlahTrx => _data.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          const HeaderWidget(title: 'Laporan Transaksi'),
          Expanded(
            child: Column(
              children: [
                // ── Filter bar ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _pickDateRange,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    color: _blue, size: 16),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '${_fmtDate.format(_from)} – ${_fmtDate.format(_to)}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Status dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _statusFilter,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                            items: _statuses
                                .map((s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(
                                        _statusLabels[s] ?? s)))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _statusFilter = v);
                                _load();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Summary ────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF003B73), Color(0xFF1565C0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        _statItem(
                            'Transaksi', '$_jumlahTrx', Icons.receipt),
                        _divider(),
                        _statItem('Total Omzet', _rp.format(_totalOmzet),
                            Icons.attach_money),
                        _divider(),
                        _statItem('Total Diskon',
                            _rp.format(_totalDiskon), Icons.discount),
                      ],
                    ),
                  ),
                ),

                // ── List ───────────────────────────────────────────────────
                Expanded(
                  child: _loading
                      ? const Center(
                          child: CircularProgressIndicator(color: _blue))
                      : _data.isEmpty
                          ? _emptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                  16, 0, 16, 20),
                              itemCount: _data.length,
                              itemBuilder: (_, i) =>
                                  _TrxCard(data: _data[i]),
                            ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon) => Expanded(
        child: Column(children: [
          Icon(icon, color: Colors.white60, size: 16),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
              overflow: TextOverflow.ellipsis),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ]),
      );

  Widget _divider() => Container(
      width: 1, height: 40, color: Colors.white24,
      margin: const EdgeInsets.symmetric(horizontal: 4));

  Widget _emptyState() => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            SizedBox(height: 8),
            Text('Tidak ada transaksi',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
}

// ── Transaction Card ─────────────────────────────────────────────────────────
class _TrxCard extends StatelessWidget {
  final TransactionWithDetails data;
  const _TrxCard({required this.data});

  static const _statusColors = {
    'antrian': Color(0xFFFF6F00),
    'proses': Color(0xFF1565C0),
    'siap_ambil': Color(0xFF2E7D32),
    'selesai': Color(0xFF003B73),
    'batal': Colors.red,
  };
  static const _statusLabels = {
    'antrian': 'Antrian',
    'proses': 'Proses',
    'siap_ambil': 'Siap Ambil',
    'selesai': 'Selesai',
    'batal': 'Batal',
  };

  @override
  Widget build(BuildContext context) {
    final trx = data.trx;
    final color = _statusColors[trx.status] ?? _blue;
    final label = _statusLabels[trx.status] ?? trx.status;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(trx.invoice,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(label,
                            style: TextStyle(
                                color: color,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    data.customer?.name ?? 'Pelanggan',
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black54),
                  ),
                  Text(
                    _fmtDateTime.format(trx.createdAt),
                    style: const TextStyle(
                        fontSize: 11, color: Colors.black38),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_rp.format(trx.total),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: _blue)),
                Text(trx.metodeBayar,
                    style: const TextStyle(
                        fontSize: 11, color: Colors.black45)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
