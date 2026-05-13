import 'package:flutter/material.dart';
import '../../data/repositories/service_repository.dart';
import '../../core/database/app_database.dart';

class ServiceVM extends ChangeNotifier {
  final ServiceRepository repo;

  ServiceVM(this.repo);

  List<Service> services = [];

  Future<void> load() async {
    services = await repo.getAll();
    notifyListeners();
  }

  Future<void> add(String name, bool cuci, bool kering, bool setrika) async {
    await repo.add(
      name: name,
      cuci: cuci,
      kering: kering,
      setrika: setrika,
    );

    await load();
  }

  Future<int> addAndGetId(
      String name, bool cuci, bool kering, bool setrika) async {
    final id = await repo.addAndGetId(
      name: name,
      cuci: cuci,
      kering: kering,
      setrika: setrika,
    );
    await load();
    return id;
  }

  Future<void> edit(
      int id, String name, bool cuci, bool kering, bool setrika) async {
    await repo.update(
      id: id,
      name: name,
      cuci: cuci,
      kering: kering,
      setrika: setrika,
    );
    await load();
  }

  Future<void> delete(int id) async {
    await repo.delete(id);
    await load();
  }
}