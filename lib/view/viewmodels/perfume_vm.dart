import 'package:flutter/material.dart';
import '../../data/repositories/perfume_repository.dart';
import '../../core/database/app_database.dart';

class PerfumeVM extends ChangeNotifier {
  final PerfumeRepository repo;

  PerfumeVM(this.repo);

  List<Perfume> perfumes = [];
  List<Perfume> filtered = [];

  Future<void> load() async {
    perfumes = await repo.getPerfumes();
    filtered = perfumes;
    notifyListeners();
  }

  Future<void> add(String name) async {
    await repo.addPerfume(name);

    await load(); // ini penting supaya UI refresh
  }

  Future<void> delete(int id) async {
    await repo.deletePerfume(id);

    await load();
  }

  void search(String query) {
    if (query.isEmpty) {
      filtered = perfumes;
    } else {
      filtered = perfumes
          .where((p) =>
              p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }
}