import '../datasources/customer_local_ds.dart';
import '../../core/database/app_database.dart';

class CustomerRepository {
  final CustomerLocalDS ds;

  CustomerRepository(this.ds);

  Future<List<Customer>> getCustomers() {
    return ds.getAll();
  }

  Future<void> createCustomer({
    required String name,
    required String phone,
    String? email,
    String? gender,
    String? address,
    String? photo,
  }) {
    return ds.addCustomer(
      name: name,
      phone: phone,
      email: email,
      gender: gender,
      address: address,
      photo: photo,
    );
  }

  Future<void> deleteCustomer(int id) {
    return ds.deleteCustomer(id);
  }
}