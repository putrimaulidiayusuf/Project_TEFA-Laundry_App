import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/database/app_database.dart';
import 'package:app_laundry/view/pages/riwayat_transaksi/widget_no_data.dart';
import 'package:app_laundry/core/routes/slide_route.dart';

const _gold = Color(0xFF0A4174);
const _green = Color(0xFF0A4174);

String _fmtRp(double v) =>
    'Rp. ${NumberFormat('#,###', 'id_ID').format(v.toInt())}';

/// ===================================================================
/// Card ringkasan transaksi — dipakai di semua tab
/// ===================================================================
class TransaksiCard extends StatelessWidget {
  final TransactionWithDetails data;
  final VoidCallback onTap;
  final Color statusColor;
  final String statusLabel;

  const TransaksiCard({
    super.key,
    required this.data,
    required this.onTap,
    required this.statusColor,
    required this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    final trx = data.trx;
    final customer = data.customer;
    final fmt = DateFormat('dd/MM/yyyy HH:mm');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 6, 16, 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header: invoice + status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trx.invoice,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          fmt.format(trx.createdAt),
                          style: const TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // Pelanggan + total
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: (customer?.photo != null &&
                            File(customer!.photo!).existsSync())
                        ? FileImage(File(customer.photo!))
                        : null,
                    child: customer?.photo == null
                        ? const Icon(Icons.person, size: 18)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer?.name ?? 'Pelanggan',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        Text(
                          '${data.items.length} item • ${trx.metodeBayar}',
                          style: const TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Total',
                          style: TextStyle(fontSize: 11, color: Colors.black54)),
                      Text(
                        _fmtRp(trx.total),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: _green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===================================================================
/// Tab generik — dipakai oleh semua 5 tab
/// query dikirim dari RiwayatPage (search bar terpusat)
/// ===================================================================
class TabRiwayat extends StatefulWidget {
  final String status;
  final Color statusColor;
  final String statusLabel;
  final List<String> nextStatuses;
  final String query; // ← terima query dari parent

  const TabRiwayat({
    super.key,
    required this.status,
    required this.statusColor,
    required this.statusLabel,
    this.nextStatuses = const [],
    this.query = '',  // default kosong
  });

  @override
  State<TabRiwayat> createState() => _TabRiwayatState();
}

class _TabRiwayatState extends State<TabRiwayat> {
  List<TransactionWithDetails> _data = [];
  bool _loading = true;

  // Filter berdasarkan query dari parent
  List<TransactionWithDetails> get _filtered {
    final q = widget.query.toLowerCase().trim();
    if (q.isEmpty) return _data;
    return _data.where((d) {
      return d.trx.invoice.toLowerCase().contains(q) ||
          (d.customer?.name.toLowerCase().contains(q) ?? false) ||
          (d.customer?.phone.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  // Reload saat status berubah (jarang, tapi aman)
  @override
  void didUpdateWidget(TabRiwayat oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) _load();
    // query berubah → otomatis rebuild karena _filtered adalah getter
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final db = context.read<AppDatabase>();
    final list = await db.getTransactionsWithDetailsByStatus(widget.status);
    if (mounted) {
      setState(() {
        _data = list;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: _gold));
    }

    final filtered = _filtered;

    if (filtered.isEmpty) {
      return const WidgetNoData();
    }

    return RefreshIndicator(
      onRefresh: _load,
      color: _gold,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: filtered.length,
        itemBuilder: (_, i) {
          final d = filtered[i];
          return TransaksiCard(
            data: d,
            statusColor: widget.statusColor,
            statusLabel: widget.statusLabel,
            onTap: () async {
              await Navigator.push(
                context,
                SlideRoute(
                  page: DetailTransaksiPage(
                    data: d,
                    statusColor: widget.statusColor,
                    statusLabel: widget.statusLabel,
                    nextStatuses: widget.nextStatuses,
                  ),
                ),
              );
              _load();
            },
          );
        },
      ),
    );
  }
}

/// ===================================================================
/// Halaman Detail Transaksi
/// ===================================================================
class DetailTransaksiPage extends StatelessWidget {
  final TransactionWithDetails data;
  final Color statusColor;
  final String statusLabel;
  final List<String> nextStatuses;

  const DetailTransaksiPage({
    super.key,
    required this.data,
    required this.statusColor,
    required this.statusLabel,
    required this.nextStatuses,
  });

  @override
  Widget build(BuildContext context) {
    final trx = data.trx;
    final fmt = DateFormat('dd/MM/yyyy – HH:mm');
    final fmtDate = DateFormat('dd/MM/yyyy');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: _gold,
        foregroundColor: Colors.white,
        title: const Text('Detail Transaksi',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== Info Pelanggan =====
            _Card(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: (data.customer?.photo != null &&
                            File(data.customer!.photo!).existsSync())
                        ? FileImage(File(data.customer!.photo!))
                        : null,
                    child: data.customer?.photo == null
                        ? const Icon(Icons.person, size: 22)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.customer?.name ?? '-',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Row(children: [
                          const Icon(Icons.phone, size: 13, color: _gold),
                          const SizedBox(width: 4),
                          Text(data.customer?.phone ?? '-',
                              style: const TextStyle(fontSize: 13)),
                        ]),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(statusLabel,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ===== Info Transaksi =====
            _Card(
              child: Column(
                children: [
                  _InfoRow('No. Invoice', trx.invoice),
                  _InfoRow('Tanggal', fmt.format(trx.createdAt)),
                  _InfoRow('Metode', trx.metodeBayar),
                  if (trx.diskon > 0)
                    _InfoRow(
                        'Diskon',
                        trx.diskonPersen
                            ? '${trx.diskon.toInt()}%'
                            : _fmtRp(trx.diskon)),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ===== Tanggal Masuk & Estimasi =====
            if (data.items.isNotEmpty) ...[
              _Card(
                child: Column(
                  children: [
                    _InfoRow('Tanggal Masuk',
                        fmtDate.format(data.items.first.item.tanggalMasuk)),
                    _InfoRow('Estimasi Selesai',
                        fmtDate.format(data.items.first.item.estimasiSelesai)),
                    if (data.items.first.item.keterangan != null)
                      _InfoRow('Keterangan', data.items.first.item.keterangan!),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],

            // ===== Detail Item =====
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: const [
                    Icon(Icons.receipt_long, color: _gold, size: 18),
                    SizedBox(width: 6),
                    Text('Detail Order',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                  ]),
                  const Divider(height: 16),
                  ...data.items.map((d) => _ItemRow(detail: d)),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ===== Total =====
            _Card(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Harga',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      Text(_fmtRp(trx.total),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: _green)),
                    ],
                  ),
                  if (trx.jumlahBayar > 0 && trx.jumlahBayar != trx.total) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Jumlah Bayar',
                            style: TextStyle(color: Colors.black54, fontSize: 13)),
                        Text(_fmtRp(trx.jumlahBayar),
                            style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ===== Tombol Ubah Status =====
            if (nextStatuses.isNotEmpty)
              ...nextStatuses.map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _StatusButton(
                      trxId: trx.id,
                      targetStatus: s,
                      onDone: () => Navigator.pop(context),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}

// ===== Helpers =====

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label,
                style: const TextStyle(color: Colors.black54, fontSize: 13)),
          ),
          const Text(': '),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final TransactionItemDetail detail;
  const _ItemRow({required this.detail});

  @override
  Widget build(BuildContext context) {
    final unitName = detail.unit?.name ?? '';
    final qtyStr = detail.item.qty % 1 == 0
        ? detail.item.qty.toInt().toString()
        : detail.item.qty.toString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFE3EEF7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: (detail.serviceType?.image != null &&
                    File(detail.serviceType!.image!).existsSync())
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(File(detail.serviceType!.image!),
                        fit: BoxFit.cover),
                  )
                : const Icon(Icons.inventory_2,
                    color: Color(0xFF0A4174), size: 24),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(detail.label,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
                Text(
                  '${_fmtRp(detail.item.price.toDouble())} /$unitName',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                if (detail.perfume != null)
                  Text('🍎 ${detail.perfume!.name}',
                      style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Qty $qtyStr $unitName',
                  style: const TextStyle(fontSize: 12)),
              Text(_fmtRp(detail.subtotal),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: _green)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final int trxId;
  final String targetStatus;
  final VoidCallback onDone;

  const _StatusButton({
    required this.trxId,
    required this.targetStatus,
    required this.onDone,
  });

  static const _labels = {
    'antrian': 'Pindah ke Antrian',
    'proses': 'Mulai Proses',
    'siap_ambil': 'Tandai Siap Diambil',
    'selesai': 'Selesai',
    'batal': 'Batalkan Transaksi',
  };

  static const _colors = {
    'antrian': Color(0xFF0A4174),
    'proses': Color(0xFF0D47A1),
    'siap_ambil': Color(0xFF1565C0),
    'selesai': Color(0xFF063059),
    'batal': Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    final label = _labels[targetStatus] ?? targetStatus;
    final color = _colors[targetStatus] ?? _gold;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () async {
          final db = context.read<AppDatabase>();
          await db.updateTransactionStatus(trxId, targetStatus);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Status diubah ke $targetStatus')),
            );
            onDone();
          }
        },
        child: Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ),
    );
  }
}