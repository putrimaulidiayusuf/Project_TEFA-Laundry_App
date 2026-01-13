import 'package:flutter/material.dart';
import 'package:app_laundry/view/widget/header.dart';

class ParfumPage extends StatefulWidget {
  const ParfumPage({super.key});
  @override
  _ParfumPageState createState() => _ParfumPageState();
}

class _ParfumPageState extends State<ParfumPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _parfumList = [
    "Arizona",
    "Aroma Lily",
    "Cherry Blossom",
    "Fresh",
    "Lavender",
    "Molto",
    "Vanilla"
  ];

  List<String> _filteredParfum = [];

  @override
  void initState() {
    super.initState();
    _filteredParfum = List.from(_parfumList);
  }

  void _filterParfum(String query) {
    setState(() {
      _filteredParfum = _parfumList
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _hapusParfum(String nama) {
    setState(() {
      _parfumList.remove(nama);
      _filteredParfum.remove(nama);
    });
  }

  void _tambahParfum() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController parfumBaru = TextEditingController();
        return AlertDialog(
          title: const Text("Tambah Parfum"),
          content: TextField(
            controller: parfumBaru,
            decoration: const InputDecoration(hintText: "Nama parfum baru"),
          ),
          actions: [
            TextButton(
              child: const Text("Batal"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Tambah"),
              onPressed: () {
                if (parfumBaru.text.isNotEmpty) {
                  setState(() {
                    _parfumList.add(parfumBaru.text);
                    _filteredParfum = List.from(_parfumList);
                  });
                  Navigator.pop(context);
                }
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(title: "Kelola Parfum"),
            const SizedBox(height: 20),
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                onChanged: _filterParfum,
                decoration: InputDecoration(
                  hintText: "Cari",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // List Parfum
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _filteredParfum.length,
                itemBuilder: (context, index) {
                  final nama = _filteredParfum[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                            'assets/parfume.png',
                          width: 40,
                          height: 40,
                          ),
                      title: Text(
                        nama,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF003366),
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _hapusParfum(nama),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Tombol Tambah
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003366),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: _tambahParfum,
                child: const Text(
                  "Tambah Parfum",
                  style: TextStyle(fontSize: 16,
                   fontWeight: FontWeight.bold,
                   color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
