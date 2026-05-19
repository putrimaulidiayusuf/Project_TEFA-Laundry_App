import 'package:flutter/material.dart';

class WidgetNoData extends StatelessWidget {
  const WidgetNoData({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 70, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            'Data Tidak Ditemukan',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
