import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app_laundry/data/model/card_model.dart';
import 'package:app_laundry/view/widgets/card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

// import semua halaman
import 'package:app_laundry/view/pages/layanan.dart';
import 'package:app_laundry/view/pages/laporan.dart';
import 'package:app_laundry/view/pages/riwayat.dart';
import 'package:app_laundry/view/pages/pengeluaran.dart';
import 'package:app_laundry/view/pages/pelanggan.dart';
import 'package:app_laundry/view/pages/kasir.dart';
import 'package:app_laundry/view/pages/parfum.dart';
import 'package:app_laundry/view/pages/satuan.dart';
import 'package:app_laundry/view/pages/sekuriti.dart';
import 'package:app_laundry/view/pages/outlet.dart' hide OutletPage;
import 'package:app_laundry/view/pages/transaksi.dart';
import 'package:app_laundry/view/pages/pengaturan.dart';
import 'package:app_laundry/view/pages/profile.dart';
import 'package:app_laundry/view/pages/navbar.dart';
import 'package:app_laundry/view/viewmodels/home_vm.dart';
import 'package:app_laundry/view/viewmodels/profile_vm.dart';
import 'package:app_laundry/view/viewmodels/outlet_vm.dart';

// Warna biru utama
const _blue1 = Color(0xFF0A4174);
const _blue2 = Color(0xFF1565C0);
const _blueSoft = Color(0xFF5A86AE);

String _fmtRupiah(double v) =>
    'Rp. ${NumberFormat('#,###', 'id_ID').format(v.toInt())}';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  // footer pages
  final List<Widget> mainPages = const [
    _HomeContent(),
    RiwayatTransaksi(),
    OutletPage(),
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

  // ================= FOOTER =================
  Widget footerBar() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: _blue1,
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
      ),
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
        Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Load stats dan kasir aktif setelah frame pertama
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<HomeVM>().loadStats();
        context.read<ProfileVM>().load();
        context.read<OutletVM>().load();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ================= HEADER =================
  Widget headerAtas(BuildContext context) {
    final vm = context.watch<HomeVM>();
    final profileVM = context.watch<ProfileVM>();
    final omzet = _fmtRupiah(vm.omzetHariIni);
    final selectedKasir = profileVM.selectedKasir;

    return Stack(
      children: [
        // Sub-header omzet (warna biru muda)
        Container(
          height: 185,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: _blueSoft,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              child: GestureDetector(
                onTap: () => context.read<HomeVM>().loadStats(),
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Omzet Hari ini",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(height: 2),
                        vm.isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                omzet,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.refresh, color: Colors.white70, size: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Header utama (warna biru tua)
        Container(
          height: 125,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: _blue1,
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
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        barrierColor: Colors.black.withValues(alpha: 0.3),
                        pageBuilder: (_, __, ___) => const NavbarPage(),
                      ),
                    );
                  },
                  child: const Icon(Icons.menu, color: Colors.white),
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
                  child: _buildProfileAvatar(selectedKasir),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── PROFILE AVATAR ──────────────────────────────────────────────────────────
  Widget _buildProfileAvatar(kasir) {
    if (kasir == null) {
      return const CircleAvatar(
        backgroundColor: Color(0xFF9AC6E8),
        child: Icon(Icons.person, color: Colors.white),
      );
    }

    // Coba tampilkan foto
    if (kasir.fotoPath != null && kasir.fotoPath!.isNotEmpty) {
      final f = File(kasir.fotoPath!);
      if (f.existsSync()) {
        return CircleAvatar(
          backgroundColor: const Color(0xFF9AC6E8),
          backgroundImage: FileImage(f),
        );
      }
    }

    // Fallback: inisial nama
    return CircleAvatar(
      backgroundColor: const Color(0xFF9AC6E8),
      child: Text(
        kasir.nama.isNotEmpty ? kasir.nama[0].toUpperCase() : '?',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  // ================= CARD STATS (Masuk / Harus Selesai / Terlambat) =================
  Widget cardStats(BuildContext context) {
    final vm = context.watch<HomeVM>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _StatCard(
            icon: Icons.login_rounded,
            label: 'Masuk',
            value: vm.isLoading ? '-' : '${vm.jumlahMasuk}',
            color: _blue2,
            onTap: () => _goToRiwayat(context),
          ),
          const SizedBox(width: 8),
          _StatCard(
            icon: Icons.check_circle_outline,
            label: 'Harus Selesai',
            value: vm.isLoading ? '-' : '${vm.jumlahHarusSelesai}',
            color: const Color(0xFF1565C0),
            onTap: () => _goToRiwayat(context),
          ),
          const SizedBox(width: 8),
          _StatCard(
            icon: Icons.timer_off_outlined,
            label: 'Terlambat',
            value: vm.isLoading ? '-' : '${vm.jumlahTerlambat}',
            color: const Color(0xFFB71C1C), // merah untuk terlambat
            onTap: () => _goToRiwayat(context),
          ),
        ],
      ),
    );
  }

  void _goToRiwayat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RiwayatPage()),
    );
  }

  // ================= CARD OUTLET =================
  Widget cardOutlet(BuildContext context) {
  final outlet = context.watch<OutletVM>();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OutletPage()),
        );
        // Reload setelah balik dari OutletPage
        if (mounted) context.read<OutletVM>().load();
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _blueSoft,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // ── FOTO OUTLET ──
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: (outlet.fotoPath != null &&
                        File(outlet.fotoPath!).existsSync())
                    ? Image.file(
                        File(outlet.fotoPath!),
                        fit: BoxFit.cover,
                        // key untuk bust cache tiap fotoPath berubah
                        key: ValueKey(outlet.fotoPath),
                        cacheWidth: 100,
                      )
                    : const Icon(Icons.store, color: _blueSoft, size: 28),
              ),
            ),
            const SizedBox(width: 12),

            // ── NAMA & ALAMAT ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    outlet.nama.isNotEmpty
                        ? outlet.nama
                        : "Nama Outlet Belum Diatur",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    outlet.alamat.isNotEmpty
                        ? outlet.alamat
                        : "Alamat belum diatur",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.edit, color: Colors.white70, size: 18),
          ],
        ),
      ),
    ),
  );
}

  // ================= GRID NAV =================
  void openCardPage(BuildContext context, String nama) {
    late Widget target;

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
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => target),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        headerAtas(context),
        cardOutlet(context),
        cardStats(context),
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

// ================= STAT CARD WIDGET =================
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback onTap;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
