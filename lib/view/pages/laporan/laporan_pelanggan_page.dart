import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app_laundry/core/database/app_database.dart';
import 'package:app_laundry/view/widgets/header.dart';

const _blue = Color(0xFF003B73);
const _green = Color(0xFF2E7D32);
const _bg = Color(0xFFF0F4F8);

final _rp = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

class LaporanPelangganPage extends StatefulWidget {
  const LaporanPelangganPage({super.key});

  @override
  State<LaporanPelangganPage> createState() => _LaporanPelangganPageState();
}

class _LaporanPelangganPageState extends State<LaporanPelangganPage> {
  List<Map<String, dynamic>> _data = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final db = context.read<AppDatabase>();
    final result = await db.getLaporanPelanggan();
    setState(() { _data = result; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final totalSemua = _data.fold<double>(0, (s, d) => s + (d['total'] as double));
    final totalTrx = _data.fold<int>(0, (s, d) => s + (d['jumlah'] as int));

    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          const HeaderWidget(title: 'Laporan Pelanggan'),
          // ── Summary ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [_green, _green.withValues(alpha: 0.7)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: _green.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Expanded(child: _summStat('Total Pelanggan', '${_data.length}', Icons.people_alt_rounded)),
                  Container(width: 1, height: 40, color: Colors.white24),
                  Expanded(child: _summStat('Total Transaksi', '$totalTrx', Icons.receipt_long_rounded)),
                  Container(width: 1, height: 40, color: Colors.white24),
                  Expanded(child: _summStat('Total Omzet', _rp.format(totalSemua), Icons.attach_money_rounded)),
                ],
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _blue))
                : _data.isEmpty
                    ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.people, size: 64, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Belum ada pelanggan', style: TextStyle(color: Colors.grey)),
                      ]))
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                        itemCount: _data.length,
                        itemBuilder: (_, i) {
                          final d = _data[i];
                          final customer = d['customer'] as Customer;
                          final jumlah = d['jumlah'] as int;
                          final total = d['total'] as double;
                          return _PelangganCard(
                            customer: customer,
                            rank: i + 1,
                            jumlahTrx: jumlah,
                            totalSpent: total,
                          );
                        },
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
    Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10), textAlign: TextAlign.center),
  ]);
}

class _PelangganCard extends StatelessWidget {
  final Customer customer;
  final int rank;
  final int jumlahTrx;
  final double totalSpent;
  const _PelangganCard({required this.customer, required this.rank, required this.jumlahTrx, required this.totalSpent});

  static const _rankColors = [Color(0xFFFFD700), Color(0xFFC0C0C0), Color(0xFFCD7F32)];

  @override
  Widget build(BuildContext context) {
    final rp = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final rankColor = rank <= 3 ? _rankColors[rank - 1] : Colors.grey.shade300;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: (customer.photo != null && File(customer.photo!).existsSync())
                  ? FileImage(File(customer.photo!)) : null,
              child: customer.photo == null ? const Icon(Icons.person, size: 22) : null,
            ),
            Positioned(
              bottom: 0, right: 0,
              child: Container(
                width: 18, height: 18,
                decoration: BoxDecoration(color: rankColor, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
                child: Center(child: Text('$rank', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold))),
              ),
            ),
          ],
        ),
        title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        subtitle: Text(customer.phone, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(rp.format(totalSpent), style: const TextStyle(color: _blue, fontWeight: FontWeight.bold, fontSize: 13)),
            Text('$jumlahTrx transaksi', style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
