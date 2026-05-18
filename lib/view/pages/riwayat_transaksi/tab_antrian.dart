import 'package:flutter/material.dart';
import 'transaksi_widgets.dart';

class TabAntrian extends StatelessWidget {
  final String query;
  const TabAntrian({super.key, this.query = ''});

  @override
  Widget build(BuildContext context) {
    return TabRiwayat(
      query: query,
      status: 'antrian',
      statusColor: const Color(0xFF0A4174),
      statusLabel: 'Antrian',
      nextStatuses: const ['proses', 'batal'],
    );
  }
}