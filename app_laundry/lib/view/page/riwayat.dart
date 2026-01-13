import 'package:flutter/material.dart';
import 'package:app_laundry/view/widget/header.dart';
import 'package:app_laundry/view/page/riwayat_transaksi/tab_antrian.dart';
import 'package:app_laundry/view/page/riwayat_transaksi/tab_batal.dart';
import 'package:app_laundry/view/page/riwayat_transaksi/tab_proses.dart';
import 'package:app_laundry/view/page/riwayat_transaksi/tab_selesai.dart';
import 'package:app_laundry/view/page/riwayat_transaksi/tab_siap_ambil.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: Column(
          children: [
            const HeaderWidget(title: "Riwayat Transaksi"),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari transaksi...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 📋 Tab pilihan status transaksi
            Container(
              color: const Color(0xFF0a4174), 
              child: const TabBar(
                labelColor: Color(0xFFFFFFFF),
                unselectedLabelColor: Colors.white,
                indicatorColor: Color(0xFFFFFFFF),
                tabs: [
                  Tab(text: "Antrian"),
                  Tab(text: "Siap Ambil"),
                  Tab(text: "Proses"),
                  Tab(text: "Selesai"),
                  Tab(text: "Batal"),
                ],
              ),
            ),

            const Expanded(
              child: TabBarView(
                children: [
                  TabAntrian(),
                  TabSiapAmbil(),
                  TabProses(),
                  TabSelesai(),
                  TabBatal(), 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
