import 'package:flutter/material.dart';

class WidgetNoData extends StatelessWidget {
  const WidgetNoData({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.search_off, size: 70, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "Tidak ada Data",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
