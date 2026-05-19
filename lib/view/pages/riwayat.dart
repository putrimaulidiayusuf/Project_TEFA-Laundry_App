import 'package:flutter/material.dart';
import 'package:app_laundry/view/widgets/header.dart';
import 'package:app_laundry/view/pages/riwayat_transaksi/tab_antrian.dart';
import 'package:app_laundry/view/pages/riwayat_transaksi/tab_batal.dart';
import 'package:app_laundry/view/pages/riwayat_transaksi/tab_proses.dart';
import 'package:app_laundry/view/pages/riwayat_transaksi/tab_selesai.dart';
import 'package:app_laundry/view/pages/riwayat_transaksi/tab_siap_ambil.dart';

const _blue1 = Color(0xFF0A4174);

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

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
    _searchController.addListener(() {
      setState(() => _query = _searchController.text);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _blue1,
      body: Column(
        children: [
          // Header tetap biru
          const HeaderWidget(title: 'Riwayat Transaksi'),

          // Search bar — putih normal
          Container(
            color: _blue1,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari invoice / nama pelanggan...',
                hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade600, size: 20),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.close, color: Colors.grey.shade600, size: 18),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
              style: TextStyle(color: Colors.grey.shade800, fontSize: 13),
              cursorColor: _blue1,
            ),
          ),

          // Tab Bar — tetap biru
          Container(
            color: _blue1,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              isScrollable: true,
              tabs: _tabs,
            ),
          ),

          // Tab Content — background putih
          Expanded(
            child: ColoredBox(
              color: Colors.white,
              child: TabBarView(
                controller: _tabController,
                children: [
                  TabAntrian(query: _query),
                  TabProses(query: _query),
                  TabSiapAmbil(query: _query),
                  TabSelesai(query: _query),
                  TabBatal(query: _query),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}