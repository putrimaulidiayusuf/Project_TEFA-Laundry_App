import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import '../../core/database/app_database.dart';

class CustomerVM extends ChangeNotifier {
  final AppDatabase db;

  CustomerVM(this.db);

  List<Customer> customers = [];
  List<Customer> filtered = [];

  // Variabel untuk menyimpan pelanggan yang sedang dipilih saat transaksi
  Customer? pelangganTerpilih;

  // Fungsi untuk menetapkan pelanggan yang dipilih
  void pilihPelanggan(Customer customer) {
    pelangganTerpilih = customer;
    notifyListeners();
  }

  Future<void> load() async {
    customers = await db.getCustomers();
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
    await db.insertCustomer(CustomersCompanion(
      name: Value(name),
      phone: Value(phone),
      email: Value(email),
      gender: Value(gender),
      address: Value(address),
      photo: Value(photo),
    ));

    await load();
  }

  // ── TAMBAHAN: Update pelanggan ────────────────────────────────────────────
  Future<void> updateCustomer({
    required int id,
    required String name,
    required String phone,
    String? email,
    String? gender,
    String? address,
    String? photo,
  }) async {
    await db.updateCustomer(CustomersCompanion(
      id: Value(id),
      name: Value(name),
      phone: Value(phone),
      email: Value(email),
      gender: Value(gender),
      address: Value(address),
      photo: Value(photo),
    ));

    await load();
  }
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> deleteCustomer(int id) async {
    await db.deleteCustomer(id);
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