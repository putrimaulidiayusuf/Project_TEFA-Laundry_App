import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app_laundry/core/database/app_database.dart';
import 'package:app_laundry/view/viewmodels/outlet_vm.dart';
import 'laporan/laporan_transaksi_page.dart';
import 'laporan/laporan_pengeluaran_page.dart';
import 'laporan/laporan_pelanggan_page.dart';
import 'laporan/export_excel_page.dart';
import 'laporan/laporan_kasir_page.dart';
import 'laporan/laporan_metode_bayar_page.dart';
import 'laporan/laporan_satuan_page.dart';
import 'package:app_laundry/core/routes/slide_route.dart';

const _blue = Color(0xFF003B73);
const _bg = Color(0xFFF0F4F8);

final _rp = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
final _fmtDate = DateFormat('dd MMM yyyy', 'id_ID');

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  double _omzetHariIni = 0;
  double _pengeluaranHariIni = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final db = context.read<AppDatabase>();
    final omzet = await db.getOmzetHariIni();
    final pengeluaran = await db.getTotalPengeluaranHariIni();
    if (mounted) {
      setState(() {
        _omzetHariIni = omzet;
        _pengeluaranHariIni = pengeluaran;
        _loading = false;
      });
    }
  }

  void _showSettingOmzet() {
    final vm = context.read<OutletVM>();
    String temp = vm.settingOmzet;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Setting Omzet',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _omzetOption(ctx, setS, temp, 'selesai',
                    'Berdasarkan Transaksi Selesai', (v) => temp = v),
                const SizedBox(height: 10),
                _omzetOption(ctx, setS, temp, 'lunas',
                    'Berdasarkan Transaksi Lunas', (v) => temp = v),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      vm.saveSettingOmzet(temp);
                      Navigator.pop(ctx);
                    },
                    child: const Text('Simpan',
                        style:
                            TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _omzetOption(BuildContext ctx, StateSetter setS, String current,
      String value, String label, Function(String) onChange) {
    final selected = current == value;
    return GestureDetector(
      onTap: () => setS(() => onChange(value)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? _blue : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: selected ? _blue : Colors.grey.shade300),
        ),
        child: Row(
          children: [
            if (selected) ...[
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
            ],
            Text(label,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menus = [
      _LaporanMenu(
        label: 'Laporan\nTransaksi',
        icon: Icons.receipt_long_rounded,
        color: const Color(0xFF1565C0),
        page: const LaporanTransaksiPage(),
      ),
      _LaporanMenu(
        label: 'Laporan\nPengeluaran',
        icon: Icons.money_off_rounded,
        color: const Color(0xFFC62828),
        page: const LaporanPengeluaranPage(),
      ),
      _LaporanMenu(
        label: 'Laporan\nPelanggan',
        icon: Icons.people_alt_rounded,
        color: const Color(0xFF2E7D32),
        page: const LaporanPelangganPage(),
      ),
      _LaporanMenu(
        label: 'Export Data\nTransaksi Ke Excel',
        icon: Icons.file_download_rounded,
        color: const Color(0xFF388E3C),
        page: const ExportExcelPage(),
      ),
      _LaporanMenu(
        label: 'Laporan Kasir',
        icon: Icons.badge_rounded,
        color: const Color(0xFF6A1B9A),
        page: const LaporanKasirPage(),
      ),
      _LaporanMenu(
        label: 'Laporan Metode\nBayar',
        icon: Icons.payment_rounded,
        color: const Color(0xFF00838F),
        page: const LaporanMetodeBayarPage(),
      ),
      _LaporanMenu(
        label: 'Laporan Satuan',
        icon: Icons.straighten_rounded,
        color: const Color(0xFFE65100),
        page: const LaporanSatuanPage(),
      ),
    ];

    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: const BoxDecoration(
              color: _blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Laporan',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      GestureDetector(
                        onTap: _showSettingOmzet,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.settings,
                                  color: Colors.white, size: 20),
                            ),
                            const Text('Setting Omzet',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // ── Summary Cards ─────────────────────────────────────────
                  _loading
                      ? const SizedBox(
                          height: 60,
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2)))
                      : Row(
                          children: [
                            Expanded(
                              child: _MiniStatCard(
                                label: 'Omzet Hari Ini',
                                value: _rp.format(_omzetHariIni),
                                icon: Icons.trending_up_rounded,
                                color: Colors.green.shade300,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _MiniStatCard(
                                label: 'Pengeluaran Hari Ini',
                                value: _rp.format(_pengeluaranHariIni),
                                icon: Icons.trending_down_rounded,
                                color: Colors.red.shade300,
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ),

          // ── Grid Menu ──────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: menus.length,
                itemBuilder: (_, i) => _MenuCard(menu: menus[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat Card di Header ──────────────────────────────────────────────────────
class _MiniStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 10)),
                Text(value,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Menu Card ─────────────────────────────────────────────────────────────────
class _MenuCard extends StatelessWidget {
  final _LaporanMenu menu;
  const _MenuCard({required this.menu});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, SlideRoute(page: menu.page)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: menu.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(menu.icon, color: menu.color, size: 26),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                menu.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LaporanMenu {
  final String label;
  final IconData icon;
  final Color color;
  final Widget page;
  const _LaporanMenu(
      {required this.label,
      required this.icon,
      required this.color,
      required this.page});
}
