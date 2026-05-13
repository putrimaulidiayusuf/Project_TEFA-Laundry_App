import 'package:flutter/material.dart';

// import page kamu
import 'package:app_laundry/view/pages/layanan.dart';
import 'package:app_laundry/view/pages/parfum.dart';
import 'package:app_laundry/view/pages/pelanggan.dart';
import 'package:app_laundry/view/pages/riwayat.dart';
import 'package:app_laundry/view/pages/pengeluaran.dart';
import 'package:app_laundry/view/pages/laporan.dart';
import 'package:app_laundry/view/pages/pengaturan.dart';
import 'package:app_laundry/view/pages/sekuriti.dart';
import 'package:app_laundry/view/pages/satuan.dart';

class NavbarPage extends StatelessWidget {
  const NavbarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.25), // 🔥 overlay gelap
      child: SafeArea(
        child: Row(
          children: [
            // ================= DRAWER =================
            Container(
              width: 280,
              decoration: const BoxDecoration(
                color: Color(0xFF507FB4),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  // ================= HEADER =================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      children: [
                        // 🔥 FIX: tombol back berfungsi
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Menu",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(color: Colors.white24),

                  // ================= MENU LIST =================
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      children: [
                        menuItem(
                          context,
                          title: 'Layanan',
                          iconPath: 'assets/layanan.png',
                          page: const LayananPage(),
                        ),
                        menuItem(
                          context,
                          title: 'Parfum',
                          iconPath: 'assets/parfume.png',
                          page: const ParfumPage(),
                        ),
                        menuItem(
                          context,
                          title: 'Pelanggan',
                          iconPath: 'assets/member.png',
                          page: const PelangganPage(),
                        ),
                        menuItem(
                          context,
                          title: 'Riwayat',
                          iconPath: 'assets/search.png',
                          page: const RiwayatPage(),
                        ),
                        menuItem(
                          context,
                          title: 'Pengeluaran',
                          iconPath: 'assets/pengeluaran.png',
                          page: const PengeluaranPage(),
                        ),
                        menuItem(
                          context,
                          title: 'Laporan',
                          iconPath: 'assets/keuangan.png',
                          page: const LaporanPage(),
                        ),
                        menuItem(
                          context,
                          title: 'Pengaturan',
                          iconPath: 'assets/pengaturan.png',
                          page: const OutletPage(),
                        ),
                        menuItem(
                          context,
                          title: 'Satuan',
                          iconPath: 'assets/satuan.png',
                          page: const SatuanPage(),
                        ),
                        menuItem(
                          context,
                          title: 'Sekuriti',
                          iconPath: 'assets/security.png',
                          page: const SekuritiPage(),
                        ),

                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Divider(color: Colors.white30),
                        ),

                        logoutItem(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ================= AREA TAP TUTUP =================
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(color: Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= MENU ITEM =================
  Widget menuItem(
    BuildContext context, {
    required String title,
    required String iconPath,
    required Widget page,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context); // 🔥 tutup drawer dulu
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Image.asset(
                iconPath,
                width: 18,
                height: 18,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) {
                  return const Icon(Icons.image_not_supported, size: 16);
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LOGOUT =================
  Widget logoutItem(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 19,
              backgroundColor: Colors.white24,
              child: Icon(Icons.logout, color: Colors.white, size: 18),
            ),
            SizedBox(width: 14),
            Text(
              'Log Out',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
