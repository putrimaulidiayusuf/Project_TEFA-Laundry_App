import 'package:flutter/material.dart';
import '../../data/repositories/unit_repository.dart';
import '../../core/database/app_database.dart';

class UnitVM extends ChangeNotifier {
  final UnitRepository repo;

  UnitVM(this.repo);

  List<Unit> units = [];
  List<Unit> filtered = [];

  Future<void> load() async {
    units = await repo.getUnits();
    filtered = units;
    notifyListeners();
  }

  Future<void> add(String name) async {
    await repo.addUnit(name);
    await load();
  }

  Future<void> delete(int id) async {
    await repo.deleteUnit(id);
    await load();
  }

  void search(String query) {
    if (query.isEmpty) {
      filtered = units;
    } else {
      filtered = units
          .where((u) =>
              u.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }
}