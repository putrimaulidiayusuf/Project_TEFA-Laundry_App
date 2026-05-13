import 'package:flutter/material.dart';
import 'package:app_laundry/view/widgets/header.dart';
import 'package:app_laundry/view/pages/riwayat_transaksi/tab_antrian.dart';
import 'package:app_laundry/view/pages/riwayat_transaksi/tab_batal.dart';
import 'package:app_laundry/view/pages/riwayat_transaksi/tab_proses.dart';
import 'package:app_laundry/view/pages/riwayat_transaksi/tab_selesai.dart';
import 'package:app_laundry/view/pages/riwayat_transaksi/tab_siap_ambil.dart';

const _gold = Color(0xFF0A4174);

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _tabs = [
    Tab(text: 'Antrian'),
    Tab(text: 'Proses'),
    Tab(text: 'Siap Ambil'),
    Tab(text: 'Selesai'),
    Tab(text: 'Batal'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeaderWidget(title: 'Riwayat Transaksi'),

          const SizedBox(height: 12),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari invoice / nama pelanggan...',
                prefixIcon:
                    const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 16),
              ),
              // search fungsional dilakukan per-tab via refresh
              onSubmitted: (_) {},
            ),
          ),

          const SizedBox(height: 12),

          // Tab Bar
          Container(
            color: _gold,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              isScrollable: true,
              tabs: _tabs,
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                TabAntrian(),
                TabProses(),
                TabSiapAmbil(),
                TabSelesai(),
                TabBatal(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
