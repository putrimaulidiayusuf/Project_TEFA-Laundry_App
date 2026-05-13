import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CardHome extends StatelessWidget {
  final String img;
  final String nama;

  const CardHome({
    super.key,
    required this.img,
    required this.nama,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white,
        elevation: 3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 🔹 Tengah vertikal
          crossAxisAlignment: CrossAxisAlignment.center, // 🔹 Tengah horizontal
          children: [
            // Gambar di tengah
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.asset(
                img,
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
            const Gap(8),
            // Nama di tengah juga
            Text(
              nama,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}