import 'package:flutter/material.dart';
import 'transaksi_widgets.dart';

class TabSiapAmbil extends StatelessWidget {
  const TabSiapAmbil({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabRiwayat(
      status: 'siap_ambil',
      statusColor: Color(0xFF1565C0),
      statusLabel: 'Siap Ambil',
      nextStatuses: ['selesai', 'batal'],
    );
  }
}
