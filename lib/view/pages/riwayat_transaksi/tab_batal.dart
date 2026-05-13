import 'package:flutter/material.dart';
import 'transaksi_widgets.dart';

class TabBatal extends StatelessWidget {
  const TabBatal({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabRiwayat(
      status: 'batal',
      statusColor: Colors.red,
      statusLabel: 'Batal',
      nextStatuses: ['antrian'], // bisa dikembalikan ke antrian
    );
  }
}
