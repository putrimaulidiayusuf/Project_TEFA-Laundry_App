import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const _blue = Color(0xFF0A4174);
const _blueDark = Color(0xFF063059);

class TransaksiBerhasilPage extends StatelessWidget {
  final double totalHarga;
  final double jumlahBayar;
  final VoidCallback onBuatBaru;

  const TransaksiBerhasilPage({
    super.key,
    required this.totalHarga,
    required this.jumlahBayar,
    required this.onBuatBaru,
  });

  String _fmt(double v) =>
      'Rp. ${NumberFormat('#,###', 'id_ID').format(v.toInt())}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===== Konten Tengah =====
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon centang
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: _blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 56,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Transaksi Berhasil Di simpan !!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Total Harga : ${_fmt(totalHarga)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Jumlah Bayar : ${_fmt(jumlahBayar)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),

            // ===== 3 Tombol Bulat =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _RoundBtn(
                    icon: Icons.check,
                    label: 'Selesai',
                    onTap: () => onBuatBaru(),
                  ),
                  _RoundBtn(
                    icon: Icons.print,
                    label: 'Cetak',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Fitur cetak belum tersedia')),
                      );
                    },
                  ),
                  _RoundBtn(
                    icon: Icons.share,
                    label: 'Bagikan',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Fitur bagikan belum tersedia')),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ===== Tombol Buat Transaksi Baru =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blueDark,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: onBuatBaru,
                child: const Text(
                  'Buat Transaksi Baru',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _RoundBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: _blue,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
