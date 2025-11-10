import 'package:flutter/material.dart';
import 'package:app_laundry/view/widget/header.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          HeaderWidget(title: "Kelola Laporan"),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
