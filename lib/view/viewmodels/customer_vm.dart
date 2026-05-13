import 'package:flutter/material.dart';
import '../../data/repositories/customer_repository.dart';
import '../../core/database/app_database.dart';

class CustomerVM extends ChangeNotifier {
  final CustomerRepository repo;

  CustomerVM(this.repo);

  List<Customer> customers = [];
  List<Customer> filtered = [];

  Future<void> load() async {
    customers = await repo.getCustomers();
    filtered = customers;
    notifyListeners();
  }

  Future<void> addCustomer({
    required String name,
    required String phone,
    String? email,
    String? gender,
    String? address,
    String? photo,
  }) async {
    await repo.createCustomer(
      name: name,
      phone: phone,
      email: email,
      gender: gender,
      address: address,
      photo: photo,
    );

    await load();
  }

  Future<void> deleteCustomer(int id) async {
    await repo.deleteCustomer(id);
    await load();
  }

  void search(String query) {
    if (query.isEmpty) {
      filtered = customers;
    } else {
      filtered = customers
          .where((c) =>
              c.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    notifyListeners();
  }
}