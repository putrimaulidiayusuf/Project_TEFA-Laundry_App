import '../datasources/service_type_local_ds.dart';
import '../../core/database/app_database.dart';

class ServiceTypeRepository {
  final ServiceTypeLocalDS ds;

  ServiceTypeRepository(this.ds);

  Future<List<ServiceType>> getByService(int id) {
    return ds.getByService(id);
  }

  Future<void> add({
    required int serviceId,
    required String name,
    required int unitId,
    required double price,
    required int estimateDay,
    required bool isHour,
    String? image,
    String? keterangan,
  }) {
    return ds.insert(
      serviceId: serviceId,
      name: name,
      unitId: unitId,
      price: price,
      estimateDay: estimateDay,
      isHour: isHour,
      image: image,
      keterangan: keterangan,
    );
  }

  Future<void> delete(int id) {
    return ds.delete(id);
  }
}