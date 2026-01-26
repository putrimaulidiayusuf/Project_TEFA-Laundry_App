import 'package:flutter/material.dart';
import 'package:app_laundry/model/card_model.dart';
import 'package:app_laundry/view/widget/card.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// import semua halaman
import 'package:app_laundry/view/page/layanan.dart';
import 'package:app_laundry/view/page/laporan.dart';
import 'package:app_laundry/view/page/riwayat.dart';
import 'package:app_laundry/view/page/pengeluaran.dart';
import 'package:app_laundry/view/page/pelanggan.dart';
import 'package:app_laundry/view/page/kasir.dart';
import 'package:app_laundry/view/page/parfum.dart';
import 'package:app_laundry/view/page/satuan.dart';
import 'package:app_laundry/view/page/sekuriti.dart';
import 'package:app_laundry/view/page/outlet.dart';
import 'package:app_laundry/view/page/transaksi.dart';
import 'package:app_laundry/view/page/pengaturan.dart';
import 'package:app_laundry/view/page/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  // daftar halaman utama (footer)
  final List<Widget> mainPages = const [
    _HomeContent(),
    RiwayatTransaksi(),
    PengaturanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: mainPages,
      ),
      bottomNavigationBar: footerBar(),
    );
  }

  // Footer Bar (tetap muncul di semua halaman)
  Widget footerBar() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xFF0A4174),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          footerItem('assets/home.png', 'Home', 0),
          footerItem('assets/layanan.png', 'Transaksi', 1),
          footerItem('assets/pengaturan.png', 'Pengaturan', 2),
        ],
      ),
    );
  }

  Widget footerItem(String iconPath, String label, int index) {
    final bool active = selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ICON tidak diwarnai putih lagi
            Image.asset(
              iconPath,
              height: 25,
              width: 25,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: active ? Colors.white : Colors.white70,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================= //
// ==== ISI HALAMAN HOME ====== //
// ============================= //

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Header double-layer
  Widget headerAtas(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 120,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF5A86AE),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: const Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 20, bottom: 10),
              child: Text(
                "Omzet Hari ini : Rp. 0",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        Container(
          height: 85,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          decoration: const BoxDecoration(
            color: Color(0xFF0A4174),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.menu, color: Colors.white, size: 28),
                const Text(
                  "Laundryque",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Serif',
                  ),
                ),
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProfilePage(),
      ),
    );
  },
  child: Container(
    height: 35,
    width: 35,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Color(0xFF9AC6E8),
    ),
    child: const Icon(
      Icons.person,
      color: Colors.white,
      size: 22,
    ),
  ),
),

              ],
            ),
          ),
        ),
      ],
    );
  }

  // Card Outlet
  Widget cardOutlet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OutletPage()),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF5A86AE),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Nama Outlet",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Alamat Outlet",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // buka halaman card
  void openCardPage(BuildContext context, String nama) {
    Widget target;
    switch (nama) {
      case 'Layanan':
        target = const LayananPage();
        break;
      case 'Laporan':
        target = const LaporanPage();
        break;
      case 'Riwayat':
        target = const RiwayatPage();
        break;
      case 'Pengeluaran':
        target = const PengeluaranPage();
        break;
      case 'Pelanggan':
        target = const PelangganPage();
        break;
      case 'Kasir':
        target = const KasirPage();
        break;
      case 'Parfum':
        target = const ParfumPage();
        break;
      case 'Satuan':
        target = const SatuanPage();
        break;
      case 'Sekuriti':
        target = const SekuritiPage();
        break;
      default:
        target = const SizedBox();
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => target));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        headerAtas(context),
        cardOutlet(context),
        Gap(10.h),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: itemFood.length,
                      itemBuilder: (context, index) {
                        final card = itemFood[index];
                        return GestureDetector(
                          onTap: () => openCardPage(context, card.nama),
                          child: CardHome(
                            img: card.img,
                            nama: card.nama,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}