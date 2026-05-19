import '../../core/database/app_database.dart';
import 'package:drift/drift.dart';

class UnitLocalDS {
  final AppDatabase db;

  UnitLocalDS(this.db);

  Future<List<Unit>> getAll() {
    return db.getUnits();
  }

  Future<void> addUnit(String name) {
    return db.insertUnit(
      UnitsCompanion.insert(name: name),
    );
  }

  Future<void> updateUnit(int id, String name) {
    return db.updateUnit(
      UnitsCompanion(id: Value(id), name: Value(name)),
    );
  }

  Future<void> deleteUnit(int id) {
    return db.deleteUnit(id);
  }
}