import 'package:app_laundry/data/datasources/service_type_local_ds.dart';
import 'package:app_laundry/data/repositories/service_type_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'view/pages/home.dart';

import 'core/database/app_database.dart';

/// DATASOURCES
import 'data/datasources/customer_local_ds.dart';
import 'data/datasources/service_local_ds.dart';
import 'data/datasources/perfume_local_ds.dart';
import 'data/datasources/unit_local_ds.dart';

/// REPOSITORIES
import 'data/repositories/customer_repository.dart';
import 'data/repositories/service_repository.dart';
import 'data/repositories/perfume_repository.dart';
import 'data/repositories/unit_repository.dart';
import 'data/repositories/transaction_repository.dart';

/// VIEWMODELS
import 'view/viewmodels/customer_vm.dart';
import 'view/viewmodels/perfume_vm.dart';
import 'view/viewmodels/unit_vm.dart';
import 'view/viewmodels/service_vm.dart';
import 'view/viewmodels/kasir_vm.dart';
import 'view/viewmodels/service_type_vm.dart';
import 'view/viewmodels/home_vm.dart';
import 'view/viewmodels/pengeluaran_vm.dart';
import 'view/viewmodels/profile_vm.dart';
import 'view/viewmodels/transaksi_vm.dart';
import 'view/viewmodels/outlet_vm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  final db = AppDatabase();

  runApp(
    MultiProvider(
      providers: [

        /// DATABASE
        Provider(create: (_) => db),

        /// DATASOURCE
        Provider(create: (c) => CustomerLocalDS(c.read())),
        Provider(create: (c) => ServiceLocalDS(c.read())),
        Provider(create: (c) => PerfumeLocalDS(c.read())),
        Provider(create: (c) => UnitLocalDS(c.read())),
        Provider(create: (c) => ServiceTypeLocalDS(c.read())),

        /// REPOSITORY
        Provider(create: (c) => CustomerRepository(c.read())),
        Provider(create: (c) => ServiceRepository(c.read())),
        Provider(create: (c) => PerfumeRepository(c.read())),
        Provider(create: (c) => UnitRepository(c.read())),
        Provider(create: (c) => TransactionRepository(c.read())),
        Provider(create: (c) => ServiceTypeRepository(c.read())),

        /// VIEWMODEL
        ChangeNotifierProvider(
          create: (c) => CustomerVM(c.read())..load(),
        ),

        ChangeNotifierProvider(
          create: (c) => PerfumeVM(c.read())..load(),
        ),

        ChangeNotifierProvider(
          create: (c) => UnitVM(c.read())..load(),
        ),

        ChangeNotifierProvider(
          create: (c) => ServiceVM(c.read())..load(),
        ),

        ChangeNotifierProvider(
  create: (c) => ServiceTypeVM(c.read()),
),

        ChangeNotifierProvider(
          create: (c) => KasirVM(c.read()),
        ),

        ChangeNotifierProvider(
          create: (c) => HomeVM(c.read()),
        ),

        ChangeNotifierProvider(
          create: (c) => PengeluaranVM(c.read())..load(),
        ),

        ChangeNotifierProvider(
          create: (c) => ProfileVM(c.read()),
        ),

        ChangeNotifierProvider(
          create: (c) => TransaksiVM(c.read()),
        ),

        ChangeNotifierProvider(
          create: (_) => OutletVM()..load(),
        ),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (_, __) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Laundryque",
        home: HomePage(),
      ),
    );
  }
}