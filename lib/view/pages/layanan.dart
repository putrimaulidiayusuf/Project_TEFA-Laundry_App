import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/database/app_database.dart';
import '../widgets/header.dart';
import '../widgets/service_card.dart';
import '../widgets/no_data.dart';
import 'tambah_layanan.dart';

class LayananPage extends StatefulWidget {
  const LayananPage({super.key});

  @override
  State<LayananPage> createState() => _LayananPageState();
}

class _LayananPageState extends State<LayananPage> {
  List<ServiceWithTypes> data = [];
  List<ServiceWithTypes> filtered = [];
  List<Unit> units = [];

  final search = TextEditingController();

  Future<void> load() async {
    final db = context.read<AppDatabase>();

    data = await db.getServicesWithTypes();
    units = await db.getUnits();
    filtered = data;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  void doSearch(String q) {
    q = q.toLowerCase();

    filtered = data.where((e) {
      return e.service.name.toLowerCase().contains(q);
    }).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeaderWidget(title: 'Kelola Layanan'),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: TextField(
              controller: search,
              onChanged: doSearch,
              decoration: InputDecoration(
                hintText: 'Cari layanan...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF0A4174)),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
            ),
          ),

          Expanded(
            child: filtered.isEmpty
                ? const WidgetNoData()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) {
                      final s = filtered[i];

                      return ServiceCard(
                        data: s,
                        units: units,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TambahLayananPage(
                                service: s.service,
                              ),
                            ),
                          ).then((_) => load());
                        },
                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Hapus Layanan?'),
                              content: Text(
                                  'Layanan "${s.service.name}" akan dihapus.'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text('Hapus',
                                      style:
                                          TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true && mounted) {
                            final db = context.read<AppDatabase>();
                            await db.deleteService(s.service.id);
                            load();
                          }
                        },
                        onDuplicate: () async {
                          await context
                              .read<AppDatabase>()
                              .insertService(
                                ServicesCompanion.insert(
                                  name: '${s.service.name} copy',
                                  cuci: s.service.cuci,
                                  kering: s.service.kering,
                                  setrika: s.service.setrika,
                                ),
                              );
                          load();
                        },
                        onTambahJenis: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TambahLayananPage(
                                service: s.service,
                              ),
                            ),
                          ).then((_) => load());
                        },
                      );
                    },
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A4174),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TambahLayananPage(),
                  ),
                ).then((_) => load());
              },
              child: const Text(
                'Tambah Layanan',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}