import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/database/app_database.dart';
import '../widgets/header.dart';
import '../widgets/service_card.dart';
import '../widgets/no_data.dart';
import 'tambah_layanan.dart';
import 'package:app_laundry/core/routes/slide_route.dart';

const _blue1   = Color(0xFF0A4174);
const _bgColor = Color(0xFFF4F6F8);

class LayananPage extends StatefulWidget {
  const LayananPage({super.key});

  @override
  State<LayananPage> createState() => _LayananPageState();
}

class _LayananPageState extends State<LayananPage> {
  List<ServiceWithTypes> data     = [];
  List<ServiceWithTypes> filtered = [];
  List<Unit> units                = [];
  bool _loading = true;

  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final db = context.read<AppDatabase>();
    data     = await db.getServicesWithTypes();
    units    = await db.getUnits();
    filtered = data;
    if (mounted) setState(() => _loading = false);
  }

  void _doSearch(String q) {
    q = q.toLowerCase();
    setState(() {
      filtered = data
          .where((e) => e.service.name.toLowerCase().contains(q))
          .toList();
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────
          const HeaderWidget(title: 'Kelola Layanan'),

          // ── Summary Bar ────────────────────────────────────────────────
          if (!_loading)
            _buildSummaryBar(),

          // ── Search ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: TextField(
              controller: _search,
              onChanged: _doSearch,
              decoration: InputDecoration(
                hintText: 'Cari nama layanan...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: _blue1, size: 20),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ),

          // ── List ────────────────────────────────────────────────────────
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _blue1))
                : filtered.isEmpty
                    ? const WidgetNoData()
                    : RefreshIndicator(
                        color: _blue1,
                        onRefresh: _load,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 4, bottom: 100),
                          itemCount: filtered.length,
                          itemBuilder: (_, i) {
                            final s = filtered[i];
                            return ServiceCard(
                              data: s,
                              units: units,
                              onTap: () => _navToEdit(s),
                              onDelete: () => _confirmDelete(s),
                              onDuplicate: () => _duplicate(s),
                              onTambahJenis: () => _navToEdit(s),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),

      // ── FAB: Tambah Layanan ────────────────────────────────────────────
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: _blue1,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Layanan', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => Navigator.push(
          context,
          SlideRoute(page: const TambahLayananPage()),
        ).then((_) => _load()),
      ),
    );
  }

  // ── Summary bar ─────────────────────────────────────────────────────────
  Widget _buildSummaryBar() {
    final total  = data.length;
    final jenis  = data.fold<int>(0, (s, e) => s + e.types.length);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0A4174), Color(0xFF1565C0)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _blue1.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _statItem(total.toString(), 'Layanan', Icons.layers_outlined),
          _divider(),
          _statItem(jenis.toString(), 'Jenis', Icons.list_alt_outlined),
          _divider(),
          _statItem(
            units.length.toString(),
            'Satuan',
            Icons.straighten_outlined,
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label, IconData icon) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Text(label,
                  style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1, height: 32,
        color: Colors.white.withValues(alpha: 0.25),
      );

  // ── Actions ──────────────────────────────────────────────────────────────
  void _navToEdit(ServiceWithTypes s) {
    Navigator.push(
      context,
      SlideRoute(page: TambahLayananPage(service: s.service)),
    ).then((_) => _load());
  }

  Future<void> _confirmDelete(ServiceWithTypes s) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Layanan?'),
        content: Text('Layanan "${s.service.name}" beserta semua jenis akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await context.read<AppDatabase>().deleteService(s.service.id);
      _load();
    }
  }

  Future<void> _duplicate(ServiceWithTypes s) async {
    await context.read<AppDatabase>().insertService(
          ServicesCompanion.insert(
            name:    '${s.service.name} copy',
            cuci:    s.service.cuci,
            kering:  s.service.kering,
            setrika: s.service.setrika,
          ),
        );
    _load();
  }
}