import 'package:flutter/material.dart';
import 'package:app_laundry/view/widget/header.dart';

class SekuritiPage extends StatelessWidget {
  const SekuritiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          HeaderWidget(title: "Kelola Parfum"),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
