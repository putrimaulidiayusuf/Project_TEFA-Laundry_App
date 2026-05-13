import 'package:flutter/material.dart';
import 'package:app_laundry/core/database/app_database.dart';

class ProfileVM extends ChangeNotifier {
  final AppDatabase db;

  ProfileVM(this.db);

  // ── State ─────────────────────────────────────────────────
  Kasir? _selectedKasir;
  List<Kasir> _kasirList = [];
  bool isLoading = false;

  // ── Getters ───────────────────────────────────────────────
  Kasir? get selectedKasir => _selectedKasir;
  List<Kasir> get kasirList => List.unmodifiable(_kasirList);

  /// Muat daftar kasir dan auto-select kasir aktif jika belum ada yang dipilih
  Future<void> load() async {
    isLoading = true;
    notifyListeners();

    try {
      _kasirList = await db.getKasirs();

      if (_kasirList.isEmpty) {
        _selectedKasir = null;
      } else if (_selectedKasir == null) {
        // Pilih kasir aktif pertama secara otomatis
        _selectedKasir = _kasirList.firstWhere(
          (k) => k.isAktif,
          orElse: () => _kasirList.first,
        );
      } else {
        // Refresh data kasir yang dipilih (bisa berubah setelah edit)
        final refreshed = _kasirList.cast<Kasir?>().firstWhere(
          (k) => k?.id == _selectedKasir!.id,
          orElse: () => null,
        );
        _selectedKasir = refreshed ?? _kasirList.first;
      }
    } catch (_) {
      // ignore errors
    }

    isLoading = false;
    notifyListeners();
  }

  /// Pilih kasir sebagai kasir aktif saat ini
  void selectKasir(Kasir kasir) {
    _selectedKasir = kasir;
    notifyListeners();
  }
}
