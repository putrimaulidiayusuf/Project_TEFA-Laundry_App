import 'package:flutter/material.dart';
import 'transaksi_widgets.dart';

class TabSelesai extends StatelessWidget {
  final String query;
  const TabSelesai({super.key, this.query = ''});

  @override
  Widget build(BuildContext context) {
    return TabRiwayat(
      query: query,
      status: 'selesai',
      statusColor: const Color(0xFF063059),
      statusLabel: 'Selesai',
      nextStatuses: const [],
    );
  }
}