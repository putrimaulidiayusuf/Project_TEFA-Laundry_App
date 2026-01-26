import 'package:flutter/material.dart';
import 'package:app_laundry/view/widget/header.dart';

class LayananPage extends StatelessWidget {
  const LayananPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          HeaderWidget(title: "Kelola Layanan"),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
