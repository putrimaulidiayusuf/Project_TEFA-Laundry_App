import 'package:flutter/material.dart';
import 'package:app_laundry/view/widgets/header.dart';

const _blue = Color(0xFF003B73);
const _bg = Color(0xFFF0F4F8);

class OutletPrinterPage extends StatefulWidget {
  const OutletPrinterPage({super.key});

  @override
  State<OutletPrinterPage> createState() => _OutletPrinterPageState();
}

class _OutletPrinterPageState extends State<OutletPrinterPage> {
  bool _isScanning = false;
  String? _connected;

  // Simulasi daftar device bluetooth yang ditemukan
  final List<Map<String, String>> _devices = [
    {'name': 'i12', 'mac': '41:42:6F:BA:D4:A5'},
    {'name': 'i12', 'mac': '41:42:6C:63:34:AF'},
    {'name': 'LAPTOP-12N2ROT9', 'mac': '9C:2F:9D:79:13:32'},
    {'name': 'Car BT', 'mac': 'FA:45:46:00:00:1C'},
    {'name': 'Oppo Neo9', 'mac': '08:4A:CF:56:78:8E'},
    {'name': 'ZOLA-K1', 'mac': 'F3:60:02:E8:7E:6C'},
    {'name': 'Galaxy A14', 'mac': '38:2D:E8:43:12:47'},
    {'name': 'BT-Speaker', 'mac': '3D:C6:4E:3F:A0:D5'},
  ];

  Future<void> _scan() async {
    setState(() => _isScanning = true);
    // Simulasi delay scanning
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isScanning = false);
  }

  void _connectDevice(Map<String, String> device) {
    setState(() => _connected = device['mac']);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Terhubung ke ${device['name']}'),
        backgroundColor: _blue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          const HeaderWidget(title: 'Scan Device Printer'),
          Expanded(
            child: _isScanning
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: _blue),
                        SizedBox(height: 16),
                        Text('Mencari printer...'),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _devices.length,
                    separatorBuilder: (_, __) =>
                        Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (context, i) {
                      final d = _devices[i];
                      final isConn = _connected == d['mac'];
                      return ListTile(
                        leading: Icon(
                          Icons.print_outlined,
                          color: isConn ? Colors.green : _blue,
                          size: 28,
                        ),
                        title: Text(
                          d['name']!,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isConn ? Colors.green : Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          d['mac']!,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                        trailing: isConn
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.green.shade300),
                                ),
                                child: Text(
                                  'Terhubung',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            : null,
                        onTap: () => _connectDevice(d),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _blue,
        onPressed: _isScanning ? null : _scan,
        child: _isScanning
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
