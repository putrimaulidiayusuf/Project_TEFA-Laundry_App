import 'package:drift/drift.dart';
import '../../core/database/app_database.dart';
import '../../view/viewmodels/transaksi_vm.dart';

class TransactionRepository {
  final AppDatabase db;

  TransactionRepository(this.db);

  // FIX: return invoice string agar bisa ditampilkan di struk
  Future<String> createFull({
    required int customerId,
    required List<CartItem> items,
    required String keterangan,
    required DateTime tanggalMasuk,
    required DateTime estimasiSelesai,
    required String metodeBayar,
    required double diskon,
    required bool diskonPersen,
    required double jumlahBayar,
  }) async {
    final double totalBruto =
        items.fold(0, (sum, i) => sum + i.subtotal);
    final double totalAfterDiskon = totalBruto - diskon;

    final invoice = 'INV-${DateTime.now().millisecondsSinceEpoch}';

    await db.createTransaction(
      TransactionsCompanion.insert(
        invoice: invoice,
        customerId: customerId,
        total: totalAfterDiskon,
        status: 'antrian',
        createdAt: DateTime.now(),
        metodeBayar: Value(metodeBayar),
        diskon: Value(diskon),
        diskonPersen: Value(diskonPersen),
        jumlahBayar: Value(jumlahBayar),
      ),
      items
          .map((e) => TransactionItemsCompanion(
                serviceTypeId: Value(e.serviceType.id),
                qty: Value(e.qty),
                price: Value(e.serviceType.price),
                perfumeId: Value(e.perfume?.id),
                keterangan:
                    Value(keterangan.isEmpty ? null : keterangan),
                tanggalMasuk: Value(tanggalMasuk),
                estimasiSelesai: Value(estimasiSelesai),
              ))
          .toList(),
    );

    return invoice; // ← kembalikan invoice sebagai noOrder
  }

  /// Legacy method — retained for backward compat
  Future<void> create({
    required int customerId,
    required List<Map<String, dynamic>> items,
  }) async {
    double total = 0;
    for (var i in items) {
      total += (i['qty'] as num) * (i['price'] as num);
    }

    final invoice = 'INV-${DateTime.now().millisecondsSinceEpoch}';

    await db.createTransaction(
      TransactionsCompanion.insert(
        invoice: invoice,
        customerId: customerId,
        total: total,
        status: 'proses',
        createdAt: DateTime.now(),
      ),
      items
          .map((e) => TransactionItemsCompanion(
                serviceTypeId: Value(e['serviceId'] as int? ?? 0),
                qty: Value((e['qty'] as num).toDouble()),
                price: Value((e['price'] as num).toDouble()),
              ))
          .toList(),
    );
  }
}