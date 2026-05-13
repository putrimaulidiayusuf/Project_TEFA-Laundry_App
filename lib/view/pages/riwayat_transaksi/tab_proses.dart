import 'package:flutter/material.dart';
import 'transaksi_widgets.dart';

class TabProses extends StatelessWidget {
  const TabProses({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabRiwayat(
      status: 'proses',
      statusColor: Color(0xFF0D47A1),
      statusLabel: 'Proses',
      nextStatuses: ['siap_ambil', 'batal'],
    );
  }
}
