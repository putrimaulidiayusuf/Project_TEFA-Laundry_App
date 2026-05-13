import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_laundry/controllers/printer_controller.dart';
import 'package:app_laundry/view/widgets/header.dart';

const _blue = Color(0xFF003B73);
const _bg = Color(0xFFF0F4F8);

class OutletPrinterPage extends StatelessWidget {
  const OutletPrinterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final printer = Get.find<PrinterController>();

    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          const HeaderWidget(title: 'Scan Device Printer'),

          Obx(() {
            if (printer.connectedMac.value == null) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          printer.connectedName.value ?? '',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.green.shade800),
                        ),
                        Text(
                          printer.connectedMac.value ?? '',
                          style: TextStyle(
                              fontSize: 11, color: Colors.green.shade600),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: printer.testPrint,
                    icon: const Icon(Icons.print, size: 16),
                    label: const Text('Test'),
                    style: TextButton.styleFrom(foregroundColor: _blue),
                  ),
                  TextButton(
                    onPressed: printer.disconnect,
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Putus'),
                  ),
                ],
              ),
            );
          }),

          Expanded(
            child: Obx(() {
              if (printer.isScanning.value) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: _blue),
                      SizedBox(height: 16),
                      Text('Mencari printer...'),
                    ],
                  ),
                );
              }

              if (printer.devices.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bluetooth_disabled,
                          size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text('Tidak ada perangkat paired',
                          style: TextStyle(color: Colors.grey.shade600)),
                      const SizedBox(height: 6),
                      Text(
                        'Pair printer dulu via\nPengaturan → Bluetooth',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: printer.devices.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: Colors.grey.shade200),
                itemBuilder: (context, i) {
                  final d = printer.devices[i];
                  return Obx(() {
                    final isConn = printer.connectedMac.value == d.macAdress;
                    return ListTile(
                      leading: Icon(Icons.print_outlined,
                          color: isConn ? Colors.green : _blue, size: 28),
                      title: Text(d.name,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isConn ? Colors.green : Colors.black87)),
                      subtitle: Text(d.macAdress,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600)),
                      trailing: isConn
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: Colors.green.shade300),
                              ),
                              child: Text('Terhubung',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w600)),
                            )
                          : printer.isConnecting.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: _blue),
                                )
                              : null,
                      onTap: printer.isConnecting.value
                          ? null
                          : () => isConn
                              ? printer.disconnect()
                              : printer.connect(d),
                    );
                  });
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() => FloatingActionButton(
            backgroundColor: _blue,
            onPressed: printer.isScanning.value ? null : printer.scan,
            child: printer.isScanning.value
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.refresh, color: Colors.white),
          )),
    );
  }
}