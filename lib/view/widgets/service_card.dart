import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/database/app_database.dart';

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
    try {
      return units.firstWhere((u) => u.id == unitId).name;
    } catch (_) {
      return 'Unit';
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = data.service;
    final types = data.types;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(blurRadius: 4, color: Colors.black12, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Header Kategori =====
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 4, 0),
            child: Row(
              children: [
                // Nama kategori
                Expanded(
                  child: Text(
                    service.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Proses icons
                _ProsesRow(service: service),

                const SizedBox(width: 4),

                // Menu button
                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu, color: Color(0xFF0A4174)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (v) {
                    if (v == 'edit') onTap();
                    if (v == 'delete') onDelete();
                    if (v == 'duplicate') onDuplicate();
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(
                        value: 'duplicate', child: Text('Duplikat')),
                    PopupMenuItem(
                        value: 'delete',
                        child: Text('Hapus',
                            style: TextStyle(color: Colors.red))),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 16, indent: 14, endIndent: 14),

          // ===== List Jenis Layanan =====
          if (types.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: GestureDetector(
                onTap: onTambahJenis,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F5FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: const Color(0xFF0A4174).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add, size: 16, color: Color(0xFF0A4174)),
                      SizedBox(width: 6),
                      Text(
                        'Tambah Jenis Layanan',
                        style: TextStyle(
                          color: Color(0xFF0A4174),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            ...types.map((t) => _JenisItem(
                  type: t,
                  unitName: _getUnitName(t.unitId),
                )),

          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

// ===== Widget baris proses (Cuci >> Kering >> Setrika) =====
class _ProsesRow extends StatelessWidget {
  final Service service;

  const _ProsesRow({required this.service});

  @override
  Widget build(BuildContext context) {
    final List<_ProsesStep> steps = [
      if (service.cuci)
        const _ProsesStep(
          icon: Icons.local_laundry_service,
          label: 'Cuci',
          color: Color(0xFFE53935),
        ),
      if (service.kering)
        const _ProsesStep(
          icon: Icons.dry,
          label: 'Kering',
          color: Color(0xFFFF8F00),
        ),
      if (service.setrika)
        const _ProsesStep(
          icon: Icons.iron,
          label: 'Setrika',
          color: Color(0xFF0A4174),
        ),
    ];

    if (steps.isEmpty) return const SizedBox();

    List<Widget> row = [];
    for (int i = 0; i < steps.length; i++) {
      row.add(steps[i]);
      if (i < steps.length - 1) {
        row.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            '>>',
            style: TextStyle(fontSize: 9, color: Colors.grey),
          ),
        ));
      }
    }

    return Row(mainAxisSize: MainAxisSize.min, children: row);
  }
}

class _ProsesStep extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ProsesStep({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.only(left: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, size: 15, color: color),
    );
  }
}

// ===== Widget satu baris jenis layanan =====
class _JenisItem extends StatelessWidget {
  final ServiceType type;
  final String unitName;

  const _JenisItem({required this.type, required this.unitName});

  String get durasiText {
    final val = type.estimateDay;
    return type.isHour ? '$val Jam' : '$val Hari';
  }

  String _formatHarga(double p) {
    if (p == p.truncateToDouble()) {
      return p
          .toInt()
          .toString()
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]}.',
          );
    }
    return p.toString();
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (type.image != null && type.image!.isNotEmpty) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(type.image!),
          width: 52,
          height: 52,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultImage(),
        ),
      );
    } else {
      imageWidget = _defaultImage();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
      child: Row(
        children: [
          imageWidget,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Rp.${_formatHarga(type.price)}/ $unitName',
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 13, color: Color(0xFFFF8F00)),
                    const SizedBox(width: 3),
                    Text(
                      durasiText,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultImage() {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFE3EEF7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.inventory_2, color: Color(0xFF0A4174), size: 26),
    );
  }
}