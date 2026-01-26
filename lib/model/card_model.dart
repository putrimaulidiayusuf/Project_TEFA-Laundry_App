import 'package:flutter/material.dart';
import 'package:app_laundry/config/app_asset.dart';

class CardModel {
  final String img;
  final String nama;

  CardModel({required this.img, required this.nama});
}

final List<CardModel> itemFood = [
  CardModel(
    img: AppAssets.layanan,
    nama: 'Layanan',
    ),
    CardModel(
    img: AppAssets.laporan,
    nama: 'Laporan',
    ),
    CardModel(
    img: AppAssets.riwayat,
    nama: 'Riwayat',
    ),
    CardModel(
    img: AppAssets.pengeluaran,
    nama: 'Pengeluaran',
    ),
    CardModel(
    img: AppAssets.pelanggan,
    nama: 'Pelanggan',
    ),
    CardModel(
    img: AppAssets.kasir,
    nama: 'Kasir',
    ),
    CardModel(
    img: AppAssets.parfum,
    nama: 'Parfum',
    ),
    CardModel(
    img: AppAssets.satuan,
    nama: 'Satuan',
    ),
    CardModel(
    img: AppAssets.sekuriti,
    nama: 'Sekuriti',
    ),
];