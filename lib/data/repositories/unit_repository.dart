import '../datasources/unit_local_ds.dart';
import '../../core/database/app_database.dart';

class UnitRepository {
  final UnitLocalDS ds;

  UnitRepository(this.ds);

  Future<List<Unit>> getUnits() {
    return ds.getAll();
  }

  Future<void> addUnit(String name) {
    return ds.addUnit(name);
  }

  Future<void> updateUnit(int id, String name) {
    return ds.updateUnit(id, name);
  }

  Future<void> deleteUnit(int id) {
    return ds.deleteUnit(id);
  }
}