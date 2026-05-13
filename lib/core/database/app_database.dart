import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

/// ================= CUSTOMERS =================
class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get email => text().nullable()();
  TextColumn get phone => text()();
  TextColumn get gender => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get photo => text().nullable()();
}

/// ================= UNITS =================
class Units extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

/// ================= PERFUMES =================
class Perfumes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

/// ================= PROSES LAYANAN =================
class ServiceProcesses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

/// ================= SERVICES =================
/// Boneka / Gorden / Jaket
class Services extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get cuci => boolean()();
  BoolColumn get kering => boolean()();
  BoolColumn get setrika => boolean()();
}

/// ================= SERVICE TYPES =================
/// Besar / Kecil / Express
class ServiceTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get serviceId => integer()();
  TextColumn get name => text()();
  TextColumn get image => text().nullable()();
  IntColumn get unitId => integer()();
  RealColumn get price => real()();
  IntColumn get estimateDay => integer()();

  /// true = Jam, false = Hari
  BoolColumn get isHour => boolean().withDefault(const Constant(true))();
  TextColumn get keterangan => text().nullable()();
}

class ServiceWithTypes {
  final Service service;
  final List<ServiceType> types;
  ServiceWithTypes({required this.service, required this.types});
}

/// Model untuk detail satu item transaksi (dengan join)
class TransactionItemDetail {
  final TransactionItem item;
  final ServiceType? serviceType;
  final Service? service;
  final Unit? unit;
  final Perfume? perfume;

  TransactionItemDetail({
    required this.item,
    this.serviceType,
    this.service,
    this.unit,
    this.perfume,
  });

  String get label =>
      '${serviceType?.name ?? '-'} (${service?.name ?? '-'})';
  double get subtotal => (item.price) * item.qty;
}

/// Model transaksi + pelanggan + items
class TransactionWithDetails {
  final Transaction trx;
  final Customer? customer;
  final List<TransactionItemDetail> items;

  TransactionWithDetails({
    required this.trx,
    this.customer,
    required this.items,
  });
}

/// ================= TRANSACTIONS =================
class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get invoice => text()();
  IntColumn get customerId => integer()();
  RealColumn get total => real()();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get metodeBayar => text().withDefault(const Constant('Cash'))();
  RealColumn get diskon => real().withDefault(const Constant(0))();
  BoolColumn get diskonPersen => boolean().withDefault(const Constant(false))();
  RealColumn get jumlahBayar => real().withDefault(const Constant(0))();
}

/// ================= TRANSACTION ITEMS =================
class TransactionItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get transactionId => integer()();
  IntColumn get serviceTypeId => integer()();
  RealColumn get qty => real()();
  RealColumn get price => real()();
  IntColumn get perfumeId => integer().nullable()();
  TextColumn get keterangan => text().nullable()();
  DateTimeColumn get tanggalMasuk => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get estimasiSelesai => dateTime().withDefault(currentDateAndTime)();
}

/// ================= PENGELUARAN =================
class Pengeluarans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nama => text()();
  RealColumn get jumlah => real()();
  TextColumn get keterangan => text().nullable()();
  DateTimeColumn get tanggal => dateTime().withDefault(currentDateAndTime)();
}

/// ================= KASIR =================
class Kasirs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nama => text()();
  TextColumn get noHp => text().nullable()();
  TextColumn get fotoPath => text().nullable()();
  TextColumn get pin => text().nullable()();
  BoolColumn get isAktif => boolean().withDefault(const Constant(true))();
}

@DriftDatabase(
  tables: [
    Customers,
    Units,
    Perfumes,
    ServiceProcesses,
    Services,
    ServiceTypes,
    Transactions,
    TransactionItems,
    Pengeluarans,
    Kasirs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 4) {
        await m.addColumn(serviceTypes, serviceTypes.isHour);
        await m.addColumn(serviceTypes, serviceTypes.keterangan);
      }
      if (from < 5) {
        // Transactions new columns
        await m.addColumn(transactions, transactions.metodeBayar);
        await m.addColumn(transactions, transactions.diskon);
        await m.addColumn(transactions, transactions.diskonPersen);
        await m.addColumn(transactions, transactions.jumlahBayar);
        // TransactionItems — recreate with new schema
        // Since SQLite doesn't support ADD COLUMN with complex defaults easily,
        // we add columns with nullable/default fallbacks
        await m.addColumn(transactionItems, transactionItems.perfumeId);
        await m.addColumn(transactionItems, transactionItems.keterangan);
        await m.addColumn(transactionItems, transactionItems.tanggalMasuk);
        await m.addColumn(transactionItems, transactionItems.estimasiSelesai);
        // Rename old serviceId column if exists — we'll handle via new column
        // serviceTypeId is new; old rows keep serviceId as 0
        await m.addColumn(transactionItems, transactionItems.serviceTypeId);
      }
      if (from < 6) {
        // Buat tabel pengeluarans baru
        await m.createTable(pengeluarans);
      }
      if (from < 7) {
        // Buat tabel kasirs baru
        await m.createTable(kasirs);
      }
    },
  );

  /// ================= CUSTOMER =================

  Future<List<Customer>> getCustomers() => select(customers).get();

  Future<int> insertCustomer(CustomersCompanion data) =>
      into(customers).insert(data);

  Future<int> deleteCustomer(int id) =>
      (delete(customers)..where((c) => c.id.equals(id))).go();

  /// ================= UNITS =================

  Future<List<Unit>> getUnits() => select(units).get();

  Future<int> insertUnit(UnitsCompanion data) => into(units).insert(data);

  Future<int> deleteUnit(int id) =>
      (delete(units)..where((u) => u.id.equals(id))).go();

  /// ================= PERFUMES =================

  Future<List<Perfume>> getPerfumes() => select(perfumes).get();

  Future<int> insertPerfume(PerfumesCompanion data) =>
      into(perfumes).insert(data);

  Future<int> deletePerfume(int id) =>
      (delete(perfumes)..where((p) => p.id.equals(id))).go();

  /// ================= SERVICES =================

  Future<List<Service>> getServices() => select(services).get();

  Future<int> insertService(ServicesCompanion data) =>
      into(services).insert(data);

  Future<bool> updateService(ServicesCompanion data) =>
      update(services).replace(data);

  Future<int> deleteService(int id) =>
      (delete(services)..where((s) => s.id.equals(id))).go();

  /// ================= SERVICE TYPES =================

  Future<List<ServiceType>> getServiceTypes(int serviceId) {
    return (select(serviceTypes)
          ..where((t) => t.serviceId.equals(serviceId)))
        .get();
  }

  Future<int> insertServiceType(ServiceTypesCompanion data) =>
      into(serviceTypes).insert(data);

  Future<bool> updateServiceType(ServiceTypesCompanion data) =>
      update(serviceTypes).replace(data);

  Future<int> deleteServiceType(int id) =>
      (delete(serviceTypes)..where((t) => t.id.equals(id))).go();

  Future<List<ServiceWithTypes>> getServicesWithTypes() async {
    final serviceList = await select(services).get();
    List<ServiceWithTypes> result = [];

    for (final s in serviceList) {
      final types = await (select(serviceTypes)
            ..where((t) => t.serviceId.equals(s.id)))
          .get();
      result.add(ServiceWithTypes(service: s, types: types));
    }

    return result;
  }

  /// ================= TRANSACTION =================

  Future<int> createTransaction(
    TransactionsCompanion trx,
    List<TransactionItemsCompanion> items,
  ) async {
    return transaction(() async {
      final trxId = await into(transactions).insert(trx);

      for (final item in items) {
        await into(transactionItems).insert(
          item.copyWith(transactionId: Value(trxId)),
        );
      }

      return trxId;
    });
  }

  Future<List<Transaction>> getTransactions() =>
      (select(transactions)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<List<Transaction>> getTransactionsByStatus(String status) =>
      (select(transactions)
            ..where((t) => t.status.equals(status))
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<int> updateTransactionStatus(int id, String status) =>
      (update(transactions)..where((t) => t.id.equals(id)))
          .write(TransactionsCompanion(status: Value(status)));

  Future<TransactionWithDetails> getTransactionDetail(int id) async {
    final trx = await (select(transactions)
          ..where((t) => t.id.equals(id)))
        .getSingle();

    final Customer? customer = await (select(customers)
          ..where((c) => c.id.equals(trx.customerId)))
        .getSingleOrNull();

    final rawItems = await (select(transactionItems)
          ..where((i) => i.transactionId.equals(id)))
        .get();

    final List<TransactionItemDetail> details = [];
    for (final item in rawItems) {
      final st = await (select(serviceTypes)
            ..where((s) => s.id.equals(item.serviceTypeId)))
          .getSingleOrNull();

      final svc = st == null
          ? null
          : await (select(services)
                ..where((s) => s.id.equals(st.serviceId)))
              .getSingleOrNull();

      final unit = st == null
          ? null
          : await (select(units)..where((u) => u.id.equals(st.unitId)))
              .getSingleOrNull();

      final perfume = item.perfumeId == null
          ? null
          : await (select(perfumes)
                ..where((p) => p.id.equals(item.perfumeId!)))
              .getSingleOrNull();

      details.add(TransactionItemDetail(
        item: item,
        serviceType: st,
        service: svc,
        unit: unit,
        perfume: perfume,
      ));
    }

    return TransactionWithDetails(trx: trx, customer: customer, items: details);
  }

  Future<List<TransactionWithDetails>> getTransactionsWithDetailsByStatus(
      String status) async {
    final trxList = await getTransactionsByStatus(status);
    final result = <TransactionWithDetails>[];
    for (final t in trxList) {
      result.add(await getTransactionDetail(t.id));
    }
    return result;
  }

  // ================= DASHBOARD STATS =================

  /// Omzet hari ini: sum total transaksi yang selesai/siap ambil hari ini
  Future<double> getOmzetHariIni() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final rows = await (select(transactions)
          ..where((t) =>
              t.createdAt.isBiggerOrEqualValue(todayStart) &
              t.createdAt.isSmallerThanValue(todayEnd) &
              t.status.isNotIn(['batal'])))
        .get();

    double total = 0.0;
    for (final row in rows) {
      total += row.total;
    }
    return total;
  }

  /// Jumlah transaksi masuk hari ini (semua status aktif)
  Future<int> getJumlahMasukHariIni() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final rows = await (select(transactions)
          ..where((t) =>
              t.createdAt.isBiggerOrEqualValue(todayStart) &
              t.createdAt.isSmallerThanValue(todayEnd)))
        .get();

    return rows.length;
  }

  /// Jumlah item transaksi yang estimasiSelesai = hari ini
  Future<int> getJumlahHarusSelesaiHariIni() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    // Join: items yang estimasiSelesai hari ini, transaksi belum selesai/batal
    final allTrx = await (select(transactions)
          ..where((t) => t.status.isNotIn(['selesai', 'batal'])))
        .get();

    int count = 0;
    for (final trx in allTrx) {
      final items = await (select(transactionItems)
            ..where((i) =>
                i.transactionId.equals(trx.id) &
                i.estimasiSelesai.isBiggerOrEqualValue(todayStart) &
                i.estimasiSelesai.isSmallerThanValue(todayEnd)))
          .get();
      if (items.isNotEmpty) count++;
    }
    return count;
  }

  /// Jumlah transaksi yang terlambat (estimasiSelesai sudah lewat, belum selesai)
  Future<int> getJumlahTerlambat() async {
    final now = DateTime.now();

    final allTrx = await (select(transactions)
          ..where((t) => t.status.isNotIn(['selesai', 'batal'])))
        .get();

    int count = 0;
    for (final trx in allTrx) {
      final items = await (select(transactionItems)
            ..where((i) =>
                i.transactionId.equals(trx.id) &
                i.estimasiSelesai.isSmallerThanValue(now)))
          .get();
      if (items.isNotEmpty) count++;
    }
    return count;
  }

  // ================= PENGELUARAN =================

  Future<List<Pengeluaran>> getPengeluarans() =>
      (select(pengeluarans)..orderBy([(p) => OrderingTerm.desc(p.tanggal)]))
          .get();

  Stream<List<Pengeluaran>> watchPengeluarans() =>
      (select(pengeluarans)..orderBy([(p) => OrderingTerm.desc(p.tanggal)]))
          .watch();

  Future<int> insertPengeluaran(PengeluaransCompanion data) =>
      into(pengeluarans).insert(data);

  Future<bool> updatePengeluaran(PengeluaransCompanion data) =>
      update(pengeluarans).replace(data);

  Future<int> deletePengeluaran(int id) =>
      (delete(pengeluarans)..where((p) => p.id.equals(id))).go();

  // ================= KASIR =================

  Future<List<Kasir>> getKasirs() =>
      (select(kasirs)..orderBy([(k) => OrderingTerm.asc(k.nama)])).get();

  Stream<List<Kasir>> watchKasirs() =>
      (select(kasirs)..orderBy([(k) => OrderingTerm.asc(k.nama)])).watch();

  Future<Kasir?> getKasirById(int id) =>
      (select(kasirs)..where((k) => k.id.equals(id))).getSingleOrNull();

  Future<int> insertKasir(KasirsCompanion data) =>
      into(kasirs).insert(data);

  Future<bool> updateKasir(KasirsCompanion data) =>
      update(kasirs).replace(data);

  Future<int> deleteKasir(int id) =>
      (delete(kasirs)..where((k) => k.id.equals(id))).go();

  // ================= LAPORAN =================

  /// Transaksi dalam rentang tanggal (null = semua)
  Future<List<TransactionWithDetails>> getLaporanTransaksi({
    DateTime? from,
    DateTime? to,
    String? status,
  }) async {
    final query = select(transactions);
    query.orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    final list = await query.get();
    final filtered = list.where((t) {
      if (from != null && t.createdAt.isBefore(from)) return false;
      if (to != null && t.createdAt.isAfter(to)) return false;
      if (status != null && status != 'semua' && t.status != status) return false;
      return true;
    }).toList();

    final result = <TransactionWithDetails>[];
    for (final t in filtered) {
      result.add(await getTransactionDetail(t.id));
    }
    return result;
  }

  /// Pengeluaran dalam rentang tanggal
  Future<List<Pengeluaran>> getLaporanPengeluaran({
    DateTime? from,
    DateTime? to,
  }) async {
    final list = await getPengeluarans();
    return list.where((p) {
      if (from != null && p.tanggal.isBefore(from)) return false;
      if (to != null && p.tanggal.isAfter(to)) return false;
      return true;
    }).toList();
  }

  /// Laporan pelanggan: jumlah transaksi & total spent
  Future<List<Map<String, dynamic>>> getLaporanPelanggan() async {
    final allTrx = await getTransactions();
    final allCustomers = await getCustomers();
    final Map<int, Map<String, dynamic>> map = {};

    for (final c in allCustomers) {
      map[c.id] = {
        'customer': c,
        'jumlah': 0,
        'total': 0.0,
      };
    }
    for (final t in allTrx) {
      if (map.containsKey(t.customerId)) {
        map[t.customerId]!['jumlah'] = (map[t.customerId]!['jumlah'] as int) + 1;
        map[t.customerId]!['total'] = (map[t.customerId]!['total'] as double) + t.total;
      }
    }
    final result = map.values.toList();
    result.sort((a, b) => (b['total'] as double).compareTo(a['total'] as double));
    return result;
  }

  /// Distribusi metode bayar
  Future<List<Map<String, dynamic>>> getLaporanMetodeBayar({
    DateTime? from,
    DateTime? to,
  }) async {
    final list = await getLaporanTransaksi(from: from, to: to);
    final Map<String, Map<String, dynamic>> map = {};
    for (final d in list) {
      final m = d.trx.metodeBayar;
      map[m] ??= {'metode': m, 'jumlah': 0, 'total': 0.0};
      map[m]!['jumlah'] = (map[m]!['jumlah'] as int) + 1;
      map[m]!['total'] = (map[m]!['total'] as double) + d.trx.total;
    }
    final result = map.values.toList();
    result.sort((a, b) => (b['total'] as double).compareTo(a['total'] as double));
    return result;
  }

  /// Laporan volume per satuan
  Future<List<Map<String, dynamic>>> getLaporanSatuan({
    DateTime? from,
    DateTime? to,
  }) async {
    final allTrx = await getLaporanTransaksi(from: from, to: to);
    final allUnits = await getUnits();
    final Map<int, Map<String, dynamic>> map = {};
    for (final u in allUnits) {
      map[u.id] = {'unit': u, 'qty': 0.0, 'total': 0.0, 'jumlah': 0};
    }
    for (final d in allTrx) {
      for (final item in d.items) {
        final uid = item.serviceType?.unitId;
        if (uid != null && map.containsKey(uid)) {
          map[uid]!['qty'] = (map[uid]!['qty'] as double) + item.item.qty;
          map[uid]!['total'] = (map[uid]!['total'] as double) + item.subtotal;
          map[uid]!['jumlah'] = (map[uid]!['jumlah'] as int) + 1;
        }
      }
    }
    final result = map.values.toList();
    result.sort((a, b) => (b['qty'] as double).compareTo(a['qty'] as double));
    return result;
  }

  /// Total pengeluaran hari ini
  Future<double> getTotalPengeluaranHariIni() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));

    final rows = await (select(pengeluarans)
          ..where((p) =>
              p.tanggal.isBiggerOrEqualValue(todayStart) &
              p.tanggal.isSmallerThanValue(todayEnd)))
        .get();

    double total = 0.0;
    for (final row in rows) {
      total += row.jumlah;
    }
    return total;
  }
}

/// ================= OPEN DATABASE =================

LazyDatabase _open() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, "laundry.db"));
    return NativeDatabase(file);
  });
}