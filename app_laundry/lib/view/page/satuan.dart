import 'package:flutter/material.dart';
import 'package:app_laundry/view/widget/header.dart';

class SatuanPage extends StatelessWidget {
  const SatuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(232, 233, 225, 225),
      body: Column(
        children: [
          // Header biru di atas
          const HeaderWidget(title: "Kelola Satuan"),
          const SizedBox(height: 20),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: 'Cari',
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // List satuan
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['Kg', 'Mesin', 'Meter', 'Pasang', 'Pcs', 'Set']
                  .map(
                    (satuan) => Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          satuan,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          // Tombol Tambah Satuan
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003366),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // nanti bisa diarahkan ke halaman tambah satuan
              },
              child: const Text(
                "Tambah Satuan",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}