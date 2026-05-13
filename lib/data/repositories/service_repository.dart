import '../datasources/service_local_ds.dart';
import '../../core/database/app_database.dart';

class ServiceRepository {
  final ServiceLocalDS ds;

  ServiceRepository(this.ds);

  Future<List<Service>> getAll() {
    return ds.getAll();
  }

  Future<void> add({
    required String name,
    required bool cuci,
    required bool kering,
    required bool setrika,
  }) async {
    await ds.insert(
      name: name,
      cuci: cuci,
      kering: kering,
      setrika: setrika,
    );
  }

  Future<int> addAndGetId({
    required String name,
    required bool cuci,
    required bool kering,
    required bool setrika,
  }) {
    return ds.insert(
      name: name,
      cuci: cuci,
      kering: kering,
      setrika: setrika,
    );
  }

  Future<void> update({
    required int id,
    required String name,
    required bool cuci,
    required bool kering,
    required bool setrika,
  }) {
    return ds.update(
      id: id,
      name: name,
      cuci: cuci,
      kering: kering,
      setrika: setrika,
    );
  }

  Future<void> delete(int id) {
    return ds.delete(id);
  }
}