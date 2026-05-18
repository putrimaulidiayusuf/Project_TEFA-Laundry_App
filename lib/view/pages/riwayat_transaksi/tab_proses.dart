import 'package:flutter/material.dart';
import 'transaksi_widgets.dart';

class TabProses extends StatelessWidget {
  final String query;
  const TabProses({super.key, this.query = ''});

  @override
  Widget build(BuildContext context) {
    return TabRiwayat(
      query: query,
      status: 'proses',
      statusColor: const Color(0xFF0D47A1),
      statusLabel: 'Proses',
      nextStatuses: const ['siap_ambil', 'batal'],
    );
  }
}