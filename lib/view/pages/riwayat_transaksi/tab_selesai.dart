import 'package:flutter/material.dart';
import 'transaksi_widgets.dart';

class TabSelesai extends StatelessWidget {
  const TabSelesai({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabRiwayat(
      status: 'selesai',
      statusColor: Color(0xFF063059),
      statusLabel: 'Selesai',
      nextStatuses: [],
    );
  }
}
