import '../../core/database/app_database.dart';
import 'package:drift/drift.dart';

class CustomerLocalDS {
  final AppDatabase db;

  CustomerLocalDS(this.db);

  Future<List<Customer>> getAll() {
    return db.getCustomers();
  }

  Future<void> addCustomer({
    required String name,
    required String phone,
    String? email,
    String? gender,
    String? address,
    String? photo,
  }) {
    return db.insertCustomer(
      CustomersCompanion.insert(
        name: name,
        phone: phone,
        email: Value(email),
        gender: Value(gender),
        address: Value(address),
        photo: Value(photo),
      ),
    );
  }

  Future<void> deleteCustomer(int id) {
    return db.deleteCustomer(id);
  }
}