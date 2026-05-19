
import 'package:flutter/material.dart';
import '../../core/database/app_database.dart';
import '../pages/tambah_jenis_layanan.dart' show buildImageFromPath;

const _blue1    = Color(0xFF0A4174);
const _blueLight = Color(0xFFE8F0FA);

class ServiceCard extends StatelessWidget {
  final ServiceWithTypes data;
  final List<Unit> units;

  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onTambahJenis;

  const ServiceCard({
    super.key,
    required this.data,
    required this.units,
    required this.onTap,
    required this.onDelete,
    required this.onDuplicate,
    required this.onTambahJenis,
  });

  String _getUnitName(int unitId) {
    try { return units.firstWhere((u) => u.id == unitId).name; }
    catch (_) { return 'Unit'; }
  }

  @override
  Widget build(BuildContext context) {
    final service = data.service;
    final types   = data.types;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
            decoration: BoxDecoration(
              color: _blue1,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    service.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Proses chips
                _ProsesRow(service: service),

                // Menu
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (v) {
                    if (v == 'edit')      onTap();
                    if (v == 'delete')    onDelete();
                    if (v == 'duplicate') onDuplicate();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit',      child: Text('Edit')),
                    PopupMenuItem(value: 'duplicate', child: Text('Duplikat')),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text('Hapus', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Isi: Jenis Layanan ───────────────────────────────────────────
          if (types.isEmpty)
            _buildEmptyJenis()
          else
            ...types.map((t) => _JenisItem(
                  type: t,
                  unitName: _getUnitName(t.unitId),
                )),

          // ── Footer: Tombol Tambah Jenis ─────────────────────────────────
          if (types.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: GestureDetector(
                onTap: onTambahJenis,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: _blueLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: _blue1.withValues(alpha: 0.25)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 15, color: _blue1),
                      SizedBox(width: 5),
                      Text('Tambah Jenis',
                          style: TextStyle(
                              color: _blue1,
                              fontWeight: FontWeight.w600,
                              fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyJenis() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: GestureDetector(
        onTap: onTambahJenis,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: _blueLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _blue1.withValues(alpha: 0.25)),
          ),
          child: Column(
            children: [
              Icon(Icons.add_circle_outline, color: _blue1.withValues(alpha: 0.6), size: 28),
              const SizedBox(height: 6),
              const Text(
                'Tambah Jenis Layanan',
                style: TextStyle(color: _blue1, fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 2),
              Text(
                'Belum ada jenis, tap untuk menambahkan',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Proses chips ─────────────────────────────────────────────────────────────
class _ProsesRow extends StatelessWidget {
  final Service service;
  const _ProsesRow({required this.service});

  @override
  Widget build(BuildContext context) {
    final steps = <_ProsesChip>[
      if (service.cuci)    const _ProsesChip(label: 'Cuci',    icon: Icons.water_drop_outlined),
      if (service.kering)  const _ProsesChip(label: 'Kering',  icon: Icons.air),
      if (service.setrika) const _ProsesChip(label: 'Setrika', icon: Icons.iron_outlined),
    ];
    if (steps.isEmpty) return const SizedBox();
    return Row(mainAxisSize: MainAxisSize.min, children: steps);
  }
}

class _ProsesChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _ProsesChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 3),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ── Satu baris jenis layanan ─────────────────────────────────────────────────
class _JenisItem extends StatelessWidget {
  final ServiceType type;
  final String unitName;
  const _JenisItem({required this.type, required this.unitName});

  String get _durasi =>
      type.isHour ? '${type.estimateDay} Jam' : '${type.estimateDay} Hari';

  String _fmtHarga(double p) => p.toInt()
      .toString()
      .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // Gambar
          _buildImage(),
          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _blue1),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F0FA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Rp ${_fmtHarga(type.price)} /$unitName',
                        style: const TextStyle(fontSize: 11, color: _blue1, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.access_time, size: 11, color: Colors.grey.shade500),
                    const SizedBox(width: 2),
                    Text(_durasi, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (type.image != null && type.image!.isNotEmpty) {
      return buildImageFromPath(type.image!, size: 48, radius: 10);
    }
    return Container(
      width: 48, height: 48,
      decoration: BoxDecoration(
        color: _blueLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.inventory_2_outlined, color: _blue1, size: 24),
    );
  }
}