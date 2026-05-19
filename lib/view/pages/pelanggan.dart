import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/header.dart';
import '../viewmodels/customer_vm.dart';
import 'tambah_pelanggan.dart';
import 'package:app_laundry/core/routes/slide_route.dart';

// ─── Warna utama (sama dengan KasirPage) ─────────────────────────────────────
const _blue1    = Color(0xFF0A4174);
const _blueSoft = Color(0xFF5A86AE);
const _bgColor  = Color(0xFFF4F6F8);

class PelangganPage extends StatelessWidget {
  const PelangganPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CustomerVM>();

    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(
        children: [
          const HeaderWidget(title: "Kelola Pelanggan"),
          const SizedBox(height: 20),

          // ── Search Field ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: vm.search,
              decoration: InputDecoration(
                hintText: 'Cari pelanggan...',
                prefixIcon: const Icon(Icons.search, color: _blue1),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── List / Empty State ───────────────────────────────────────────
          Expanded(
            child: vm.filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person_search_outlined,
                            size: 72, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          'Data Tidak Ditemukan',
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    itemCount: vm.filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final pelanggan = vm.filtered[i];

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.07),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),

                          // ── Avatar ──────────────────────────────────────
                          leading: pelanggan.photo != null &&
                                  File(pelanggan.photo!).existsSync()
                              ? CircleAvatar(
                                  radius: 26,
                                  backgroundImage:
                                      FileImage(File(pelanggan.photo!)),
                                )
                              : CircleAvatar(
                                  radius: 26,
                                  backgroundColor: _blue1,
                                  child: Text(
                                    pelanggan.name.isNotEmpty
                                        ? pelanggan.name[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),

                          title: Text(
                            pelanggan.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          subtitle: Text(
                            pelanggan.phone,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),

                          // ── onTap (tidak diubah) ─────────────────────────
                          onTap: () {
                            context
                                .read<CustomerVM>()
                                .pilihPelanggan(pelanggan);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${pelanggan.name} dipilih untuk transaksi'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                            Navigator.pop(context);
                          },

                          // ── Trailing: Edit + Delete ──────────────────────
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Tombol Edit
                              IconButton(
                                icon: const Icon(Icons.edit_outlined,
                                    color: _blueSoft),
                                onPressed: () async {
                                  final hasil = await Navigator.push(
                                    context,
                                    SlideRoute(
                                      page: TambahPelangganPage(
                                        pelanggan: {
                                          'nama'        : pelanggan.name,
                                          'email'       : pelanggan.email ?? '',
                                          'noHp'        : pelanggan.phone,
                                          'jenisKelamin': pelanggan.gender,
                                          'alamat'      : pelanggan.address ?? '',
                                          'fotoProfil'  : pelanggan.photo,
                                        },
                                      ),
                                    ),
                                  );

                                  if (hasil != null) {
                                    context.read<CustomerVM>().updateCustomer(
                                          id     : pelanggan.id,
                                          name   : hasil['nama'],
                                          phone  : hasil['noHp'],
                                          email  : hasil['email'],
                                          gender : hasil['jenisKelamin'],
                                          address: hasil['alamat'],
                                          photo  : hasil['fotoProfil'],
                                        );
                                  }
                                },
                              ),
                              // Tombol Delete (tidak diubah)
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.red),
                                onPressed: () {
                                  vm.deleteCustomer(pelanggan.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // ── Tombol Tambah Pelanggan (tidak diubah sama sekali) ───────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () async {
                final hasil = await Navigator.push(
                  context,
                  SlideRoute(page: const TambahPelangganPage()),
                );

                if (hasil != null) {
                  context.read<CustomerVM>().addCustomer(
                        name  : hasil['nama'],
                        phone : hasil['noHp'],
                        email : hasil['email'],
                        gender: hasil['jenisKelamin'],
                        address: hasil['alamat'],
                        photo : hasil['fotoProfil'],
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