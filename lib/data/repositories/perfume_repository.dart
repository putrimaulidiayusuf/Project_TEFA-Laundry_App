import '../datasources/perfume_local_ds.dart';
import '../../core/database/app_database.dart';

class PerfumeRepository {
  final PerfumeLocalDS ds;

  PerfumeRepository(this.ds);

  Future<List<Perfume>> getPerfumes() {
    return ds.getAll();
  }

  Future<void> addPerfume(String name) {
    return ds.addPerfume(name);
  }

  Future<void> updatePerfume(int id, String name) {
    return ds.updatePerfume(id, name);
  }

  Future<void> deletePerfume(int id) {
    return ds.deletePerfume(id);
  }
}