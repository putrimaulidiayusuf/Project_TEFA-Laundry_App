import 'package:flutter/material.dart';
import 'package:app_laundry/view/widget/header.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          HeaderWidget(title: "Riwayat transaksi"),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
