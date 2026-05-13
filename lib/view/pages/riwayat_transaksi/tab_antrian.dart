import 'package:flutter/material.dart';
import 'transaksi_widgets.dart';

class TabAntrian extends StatelessWidget {
  const TabAntrian({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabRiwayat(
      status: 'antrian',
      statusColor: Color(0xFF0A4174),
      statusLabel: 'Antrian',
      nextStatuses: ['proses', 'batal'],
    );
  }
}
