import 'package:flutter/material.dart';
import 'transaksi_widgets.dart';

class TabBatal extends StatelessWidget {
  final String query;
  const TabBatal({super.key, this.query = ''});

  @override
  Widget build(BuildContext context) {
    return TabRiwayat(
      query: query,
      status: 'batal',
      statusColor: Colors.red,
      statusLabel: 'Batal',
      nextStatuses: const ['antrian'],
    );
  }
}