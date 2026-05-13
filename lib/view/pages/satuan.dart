import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_laundry/view/widgets/header.dart';
import '../viewmodels/unit_vm.dart';

class SatuanPage extends StatefulWidget {
  const SatuanPage({super.key});

  @override
  State<SatuanPage> createState() => _SatuanPageState();
}

class _SatuanPageState extends State<SatuanPage> {
  final TextEditingController _searchController = TextEditingController();

  void _tambahSatuan() {
    TextEditingController satuanBaru = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tambah Satuan"),
        content: TextField(
          controller: satuanBaru,
          decoration: const InputDecoration(
            hintText: "Nama satuan",
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Tambah"),
            onPressed: () {
              if (satuanBaru.text.isNotEmpty) {
                context.read<UnitVM>().add(satuanBaru.text);
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UnitVM>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(title: "Kelola Satuan"),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                onChanged: vm.search,
                decoration: InputDecoration(
                  hintText: "Cari",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: vm.filtered.length,
                itemBuilder: (_, i) {
                  final satuan = vm.filtered[i];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(
                        satuan.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF003366),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          vm.delete(satuan.id);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _tambahSatuan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Tambah Satuan",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}