import 'package:flutter/material.dart';
import '../../core/database/app_database.dart';

class HomeVM extends ChangeNotifier {
  final AppDatabase db;

  HomeVM(this.db);

  double omzetHariIni = 0;
  int jumlahMasuk = 0;
  int jumlahHarusSelesai = 0;
  int jumlahTerlambat = 0;
  bool isLoading = false;

  Future<void> loadStats() async {
    isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        db.getOmzetHariIni(),
        db.getJumlahMasukHariIni(),
        db.getJumlahHarusSelesaiHariIni(),
        db.getJumlahTerlambat(),
      ]);

      omzetHariIni = results[0] as double;
      jumlahMasuk = results[1] as int;
      jumlahHarusSelesai = results[2] as int;
      jumlahTerlambat = results[3] as int;
    } catch (_) {
      // fail silently, tampilkan 0
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
