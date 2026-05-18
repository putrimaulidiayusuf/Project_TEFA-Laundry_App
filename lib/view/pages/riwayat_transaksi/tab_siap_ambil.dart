import 'package:flutter/material.dart';
import 'transaksi_widgets.dart';

class TabSiapAmbil extends StatelessWidget {
  final String query;
  const TabSiapAmbil({super.key, this.query = ''});

  @override
  Widget build(BuildContext context) {
    return TabRiwayat(
      query: query,
      status: 'siap_ambil',
      statusColor: const Color(0xFF1565C0),
      statusLabel: 'Siap Ambil',
      nextStatuses: const ['selesai', 'batal'],
    );
  }
}