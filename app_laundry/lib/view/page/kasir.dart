import 'package:flutter/material.dart';
import 'package:app_laundry/view/widget/header.dart';

class KasirPage extends StatelessWidget {
  const KasirPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          HeaderWidget(title: "Kelola Kasir"),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
