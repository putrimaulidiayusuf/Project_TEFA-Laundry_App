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
  bool isMenuOpen = false;

  final List<Widget> mainPages = const [
    _HomeContent(),
    RiwayatTransaksi(),
    PengaturanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: selectedIndex,
            children: mainPages,
          ),
          if (isMenuOpen) sideMenu(context),
        ],
      ),
      bottomNavigationBar: footerBar(),
    );
  }

  // ================= FOOTER =================
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, height: 25, width: 25),
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
    );
  }

  // ================= SIDE MENU =================
  Widget sideMenu(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => setState(() => isMenuOpen = false),
          child: Container(color: Colors.black45),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  ListTile(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () =>
                          setState(() => isMenuOpen = false),
                    ),
                    title: const Text(
                      'Menu',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      children: [
                        menuItem('Layanan'),
                        menuItem('Parfum'),
                        menuItem('Pelanggan'),
                        menuItem('Riwayat'),
                        menuItem('Pengeluaran'),
                        menuItem('Laporan'),
                        menuItem('Pengaturan'),
                        menuItem('Sekuriti'),
                        menuItem('Ganti Password'),
                        menuItem('Logout'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget menuItem(String title) {
    return ListTile(
      leading: CircleAvatar(backgroundColor: Colors.grey.shade300),
      title: Text(title),
      onTap: () {
        setState(() => isMenuOpen = false);
        openMenuPage(title);
      },
    );
  }

  void openMenuPage(String title) {
    Widget page;
    switch (title) {
      case 'Layanan':
        page = const LayananPage();
        break;
      case 'Parfum':
        page = const ParfumPage();
        break;
      case 'Pelanggan':
        page = const PelangganPage();
        break;
      case 'Riwayat':
        page = const RiwayatPage();
        break;
      case 'Pengeluaran':
        page = const PengeluaranPage();
        break;
      case 'Laporan':
        page = const LaporanPage();
        break;
      case 'Pengaturan':
        page = const PengaturanPage();
        break;
      case 'Sekuriti':
      case 'Ganti Password':
        page = const SekuritiPage();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}

// ================= HOME CONTENT =================
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
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 700));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // HEADER
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
        ),
        Container(
          height: 85,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Color(0xFF0A4174),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    final home =
                        context.findAncestorStateOfType<_HomePageState>();
                    home?.setState(() => home.isMenuOpen = true);
                  },
                  child:
                      const Icon(Icons.more_vert, color: Colors.white),
                ),
                const Text(
                  "Laundryque",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ProfilePage()),
                    );
                  },
                  child: const CircleAvatar(
                    backgroundColor: Color(0xFF9AC6E8),
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        headerAtas(context),
        Gap(10.h),
        Expanded(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: itemFood.length,
                    itemBuilder: (context, index) {
                      final card = itemFood[index];
                      return CardHome(
                        img: card.img,
                        nama: card.nama,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
