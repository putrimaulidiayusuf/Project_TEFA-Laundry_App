import 'package:drift/drift.dart';
import '../../core/database/app_database.dart';

class ServiceLocalDS {
  final AppDatabase db;

  ServiceLocalDS(this.db);

  Future<List<Service>> getAll() {
    return db.getServices();
  }

  Future<int> insert({
    required String name,
    required bool cuci,
    required bool kering,
    required bool setrika,
  }) async {
    return db.insertService(
      ServicesCompanion.insert(
        name: name,
        cuci: cuci,
        kering: kering,
        setrika: setrika,
      ),
    );
  }

  Future<void> update({
    required int id,
    required String name,
    required bool cuci,
    required bool kering,
    required bool setrika,
  }) async {
    await db.updateService(
      ServicesCompanion(
        id: Value(id),
        name: Value(name),
        cuci: Value(cuci),
        kering: Value(kering),
        setrika: Value(setrika),
      ),
    );
  }

  Future<void> delete(int id) {
    return db.deleteService(id);
  }
}