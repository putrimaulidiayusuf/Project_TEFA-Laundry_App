import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/header.dart';
import '../viewmodels/customer_vm.dart';
import 'tambah_pelanggan.dart';

class PelangganPage extends StatelessWidget {
  const PelangganPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CustomerVM>();

    return Scaffold(
      body: Column(
        children: [
          const HeaderWidget(title: "Kelola Pelanggan"),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: vm.search,
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

          Expanded(
            child: vm.filtered.isEmpty
                ? const Center(child: Text("Data Tidak Ditemukan"))
                : ListView.builder(
                    itemCount: vm.filtered.length,
                    itemBuilder: (_, i) {
                      final pelanggan = vm.filtered[i];

                      return ListTile(
                        leading: pelanggan.photo != null
                            ? CircleAvatar(
                                backgroundImage:
                                    FileImage(File(pelanggan.photo!)),
                              )
                            : const CircleAvatar(
                                child: Icon(Icons.person),
                              ),
                        title: Text(pelanggan.name),
                        subtitle: Text(pelanggan.phone),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            vm.deleteCustomer(pelanggan.id);
                          },
                        ),
                      );
                    },
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () async {
                final hasil = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TambahPelangganPage(),
                  ),
                );

                if (hasil != null) {
                  context.read<CustomerVM>().addCustomer(
                        name: hasil['nama'],
                        phone: hasil['noHp'],
                        email: hasil['email'],
                        gender: hasil['jenisKelamin'],
                        address: hasil['alamat'],
                        photo: hasil['fotoProfil'],
                      );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003B73),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                "Tambah Pelanggan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}