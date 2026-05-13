import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:app_laundry/core/database/app_database.dart';
import 'package:app_laundry/view/widgets/header.dart';

const _blue = Color(0xFF003B73);
const _green = Color(0xFF388E3C);
const _bg = Color(0xFFF0F4F8);

final _fmtDate = DateFormat('dd MMM yyyy', 'id_ID');
final _fmtDateTime = DateFormat('dd/MM/yyyy HH:mm', 'id_ID');
final _rp = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

class ExportExcelPage extends StatefulWidget {
  const ExportExcelPage({super.key});

  @override
  State<ExportExcelPage> createState() => _ExportExcelPageState();
}

class _ExportExcelPageState extends State<ExportExcelPage> {
  DateTime _from = DateTime.now().subtract(const Duration(days: 29));
  DateTime _to = DateTime.now();
  bool _exporting = false;
  bool _exported = false;
  String _exportedPath = '';
  int _rowCount = 0;

  Future<void> _pickDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(start: _from, end: _to),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(colorScheme: const ColorScheme.light(primary: _blue)),
        child: child!,
      ),
    );
    if (range != null) setState(() { _from = range.start; _to = range.end; _exported = false; });
  }

  Future<void> _export() async {
    setState(() { _exporting = true; _exported = false; });

    try {
      final db = context.read<AppDatabase>();
      final fromStart = DateTime(_from.year, _from.month, _from.day);
      final toEnd = DateTime(_to.year, _to.month, _to.day, 23, 59, 59);
      final data = await db.getLaporanTransaksi(from: fromStart, to: toEnd);

      // Build CSV
      final lines = <String>[];
      lines.add('No,Invoice,Tanggal,Pelanggan,Status,Metode Bayar,Total,Diskon,Jumlah Bayar');
      for (var i = 0; i < data.length; i++) {
        final d = data[i];
        final t = d.trx;
        final name = (d.customer?.name ?? '').replaceAll(',', ' ');
        lines.add('${i + 1},${t.invoice},${_fmtDateTime.format(t.createdAt)},$name,${t.status},${t.metodeBayar},${t.total.toInt()},${t.diskon.toInt()},${t.jumlahBayar.toInt()}');
      }

      final csv = lines.join('\n');
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'laporan_transaksi_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.csv';
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(csv, encoding: utf8);

      setState(() {
        _exporting = false;
        _exported = true;
        _exportedPath = file.path;
        _rowCount = data.length;
      });
    } catch (e) {
      setState(() => _exporting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal export: $e')));
      }
    }
  }

  Future<void> _share() async {
    if (_exportedPath.isEmpty) return;
    await Share.shareXFiles(
      [XFile(_exportedPath)],
      text: 'Laporan Transaksi Laundry',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          const HeaderWidget(title: 'Export Data Transaksi'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ── Info Card ──────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF388E3C), Color(0xFF1B5E20)],
                          begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: _green.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 5))],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.table_chart_rounded, color: Colors.white, size: 48),
                        const SizedBox(height: 12),
                        const Text('Export ke CSV / Excel',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        const Text('Data transaksi akan diekspor dalam format CSV yang bisa dibuka di Excel, Google Sheets, atau aplikasi spreadsheet lainnya.',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Date Range Picker ──────────────────────────────────
                  _sectionLabel('Rentang Tanggal'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickDateRange,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: _blue, size: 20),
                          const SizedBox(width: 10),
                          Text('${_fmtDate.format(_from)} – ${_fmtDate.format(_to)}',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          const Spacer(),
                          const Icon(Icons.edit_calendar, color: Colors.grey, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Kolom yang Diekspor ────────────────────────────────
                  _sectionLabel('Kolom yang Akan Diekspor'),
                  const SizedBox(height: 8),
                  _columnsList(),
                  const SizedBox(height: 24),

                  // ── Tombol Export ──────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _exporting ? null : _export,
                      icon: _exporting
                          ? const SizedBox(width: 20, height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.download_rounded, color: Colors.white),
                      label: Text(_exporting ? 'Mengekspor...' : 'Export CSV',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  // ── Result Card ────────────────────────────────────────
                  if (_exported) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _green.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _green.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.check_circle, color: _green, size: 24),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Export Berhasil!',
                                        style: TextStyle(color: _green, fontWeight: FontWeight.bold, fontSize: 15)),
                                    Text('$_rowCount baris data diekspor',
                                        style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: _green),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: _share,
                              icon: const Icon(Icons.share_rounded, color: _green),
                              label: const Text('Bagikan File', style: TextStyle(color: _green, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) => Align(
    alignment: Alignment.centerLeft,
    child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
  );

  Widget _columnsList() {
    const cols = ['No', 'Invoice', 'Tanggal', 'Pelanggan', 'Status', 'Metode Bayar', 'Total', 'Diskon', 'Jumlah Bayar'];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: cols.map((c) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _blue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(c, style: const TextStyle(fontSize: 12, color: _blue, fontWeight: FontWeight.w500)),
        )).toList(),
      ),
    );
  }
}
