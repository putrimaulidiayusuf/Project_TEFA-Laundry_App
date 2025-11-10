import 'package:flutter/material.dart';
import 'package:app_laundry/view/widget/header.dart';
import 'package:app_laundry/view/page/tambah_pelanggan.dart';

class PelangganPage extends StatefulWidget {
  const PelangganPage({super.key});

  @override
  State<PelangganPage> createState() => _KelolaPelangganState();
}

class _KelolaPelangganState extends State<PelangganPage> {
  List<String> daftarPelanggan = [];

  void _tambahPelanggan(String nama) {
    setState(() {
      daftarPelanggan.add(nama);
    });
  }

  void _hapusPelanggan(int index) {
    setState(() {
      daftarPelanggan.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeaderWidget(title: "Kelola Pelanggan"),
          const SizedBox(height: 20),

          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari pelanggan...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 📋 Daftar pelanggan atau pesan kosong
          Expanded(
            child: daftarPelanggan.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Data Tidak Ditemukan',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: daftarPelanggan.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(daftarPelanggan[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _hapusPelanggan(index);
                          },
                        ),
                      );
                    },
                  ),
          ),

          // ➕ Tombol tambah pelanggan
          Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () async {
              final hasil = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (context) => const TambahPelangganPage(),
                ),
              );
              if (hasil != null && hasil.isNotEmpty) {
                _tambahPelanggan(hasil);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003B73),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              'Tambah Pelanggan',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        ],
      ),
    );
  }
}