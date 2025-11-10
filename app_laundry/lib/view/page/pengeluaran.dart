import 'package:flutter/material.dart';
import 'package:app_laundry/view/widget/header.dart';

class PengeluaranPage extends StatelessWidget {
  const PengeluaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          HeaderWidget(title: "Kelola Pengeluaran"),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
