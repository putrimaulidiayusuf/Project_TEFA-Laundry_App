import '../../core/database/app_database.dart';
import 'package:drift/drift.dart';

class PerfumeLocalDS {
  final AppDatabase db;

  PerfumeLocalDS(this.db);

  Future<List<Perfume>> getAll() {
    return db.getPerfumes();
  }

  Future<void> addPerfume(String name) {
    return db.insertPerfume(
      PerfumesCompanion.insert(name: name),
    );
  }

  Future<void> updatePerfume(int id, String name) {
    return db.updatePerfume(
      PerfumesCompanion(id: Value(id), name: Value(name)),
    );
  }

  Future<void> deletePerfume(int id) {
    return db.deletePerfume(id);
  }
}