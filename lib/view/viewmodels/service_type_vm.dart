import 'package:flutter/material.dart';
import '../../data/repositories/service_type_repository.dart';
import '../../core/database/app_database.dart';

class ServiceTypeVM extends ChangeNotifier {
  final ServiceTypeRepository repo;

  ServiceTypeVM(this.repo);

  List<ServiceType> types = [];

  Future<void> load(int serviceId) async {
    types = await repo.getByService(serviceId);
    notifyListeners();
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
  }) async {
    await repo.add(
      serviceId: serviceId,
      name: name,
      unitId: unitId,
      price: price,
      estimateDay: estimateDay,
      isHour: isHour,
      image: image,
      keterangan: keterangan,
    );

    await load(serviceId);
  }

  Future<void> delete(int id, int serviceId) async {
    await repo.delete(id);
    await load(serviceId);
  }
}