import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:app_laundry/core/database/app_database.dart';

class KasirVM extends ChangeNotifier {
  final AppDatabase db;

  KasirVM(this.db);

  List<Kasir> _list = [];
  bool isLoading = false;
  String? errorMsg;

  List<Kasir> get list => _list;

  Future<void> load() async {
    isLoading = true;
    errorMsg = null;
    notifyListeners();
    try {
      _list = await db.getKasirs();
    } catch (e) {
      errorMsg = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> tambah({
    required String nama,
    String? noHp,
    String? fotoPath,
    String? pin,
  }) async {
    try {
      await db.insertKasir(KasirsCompanion(
        nama: Value(nama),
        noHp: Value(noHp),
        fotoPath: Value(fotoPath),
        pin: Value(pin),
        isAktif: const Value(true),
      ));
      await load();
      return true;
    } catch (e) {
      errorMsg = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> update({
    required int id,
    required String nama,
    String? noHp,
    String? fotoPath,
    String? pin,
    bool isAktif = true,
  }) async {
    try {
      await db.updateKasir(KasirsCompanion(
        id: Value(id),
        nama: Value(nama),
        noHp: Value(noHp),
        fotoPath: Value(fotoPath),
        pin: Value(pin),
        isAktif: Value(isAktif),
      ));
      await load();
      return true;
    } catch (e) {
      errorMsg = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> hapus(int id) async {
    try {
      await db.deleteKasir(id);
      await load();
      return true;
    } catch (e) {
      errorMsg = e.toString();
      notifyListeners();
      return false;
    }
  }
}