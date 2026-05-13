import '../../core/database/app_database.dart';
import 'package:drift/drift.dart';

class ServiceTypeLocalDS {
  final AppDatabase db;

  ServiceTypeLocalDS(this.db);

  Future<List<ServiceType>> getByService(int serviceId) {
    return db.getServiceTypes(serviceId);
  }

  Future<void> insert({
    required int serviceId,
    required String name,
    required int unitId,
    required double price,
    required int estimateDay,
    required bool isHour,
    String? image,
    String? keterangan,
  }) async {
    await db.insertServiceType(
      ServiceTypesCompanion.insert(
        serviceId: serviceId,
        name: name,
        unitId: unitId,
        price: price,
        estimateDay: estimateDay,
        isHour: Value(isHour),
        image: Value(image),
        keterangan: Value(keterangan),
      ),
    );
  }

  Future<void> delete(int id) {
    return db.deleteServiceType(id);
  }
}