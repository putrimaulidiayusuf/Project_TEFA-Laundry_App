import 'package:flutter/material.dart';
import 'package:app_laundry/view/widget/header.dart';

class OutletPage extends StatelessWidget {
  const OutletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          HeaderWidget(title: "Kelola Outlet"),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
