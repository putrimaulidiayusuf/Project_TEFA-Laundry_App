import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import '../../core/database/app_database.dart';

class PengeluaranVM extends ChangeNotifier {
  final AppDatabase db;

  PengeluaranVM(this.db);

  List<Pengeluaran> _all = [];
  List<Pengeluaran> filtered = [];
  bool isLoading = false;

  double get totalHariIni {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _all
        .where((p) =>
            p.tanggal.isAfter(today.subtract(const Duration(seconds: 1))) &&
            p.tanggal.isBefore(today.add(const Duration(days: 1))))
        .fold(0.0, (sum, p) => sum + p.jumlah);
  }

  double get totalSemua => _all.fold(0.0, (sum, p) => sum + p.jumlah);

  Future<void> load() async {
    isLoading = true;
    notifyListeners();
    try {
      _all = await db.getPengeluarans();
      filtered = List.from(_all);
    } catch (_) {
      _all = [];
      filtered = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    if (query.trim().isEmpty) {
      filtered = List.from(_all);
    } else {
      final q = query.toLowerCase();
      filtered = _all
          .where((p) =>
              p.nama.toLowerCase().contains(q) ||
              (p.keterangan?.toLowerCase().contains(q) ?? false))
          .toList();
    }
    notifyListeners();
  }

  Future<void> add({
    required String nama,
    required double jumlah,
    String? keterangan,
    DateTime? tanggal,
  }) async {
    await db.insertPengeluaran(PengeluaransCompanion(
      nama: Value(nama),
      jumlah: Value(jumlah),
      keterangan: Value(keterangan),
      tanggal: tanggal != null ? Value(tanggal) : const Value.absent(),
    ));
    await load();
  }

  Future<void> edit({
    required int id,
    required String nama,
    required double jumlah,
    String? keterangan,
    required DateTime tanggal,
  }) async {
    await db.updatePengeluaran(PengeluaransCompanion(
      id: Value(id),
      nama: Value(nama),
      jumlah: Value(jumlah),
      keterangan: Value(keterangan),
      tanggal: Value(tanggal),
    ));
    await load();
  }

  Future<void> delete(int id) async {
    await db.deletePengeluaran(id);
    await load();
  }
}
