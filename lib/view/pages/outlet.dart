import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:app_laundry/view/widgets/header.dart';
import 'package:app_laundry/view/viewmodels/outlet_vm.dart';
import 'package:app_laundry/view/pages/outlet_template.dart';
import 'package:app_laundry/view/pages/outlet_printer.dart';
import 'package:app_laundry/view/pages/outlet_metode.dart';

const _blue = Color(0xFF003B73);
const _bg = Color(0xFFF0F4F8);

class OutletPage extends StatefulWidget {
  const OutletPage({super.key});
  @override
  State<OutletPage> createState() => _OutletPageState();
}

class _OutletPageState extends State<OutletPage> {
  final _namaCtrl = TextEditingController();
  final _alamatCtrl = TextEditingController();
  final _catatanCtrl = TextEditingController();
  final _footerCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<OutletVM>();
      await vm.load();
      _namaCtrl.text = vm.nama;
      _alamatCtrl.text = vm.alamat;
      _catatanCtrl.text = vm.catatan;
      _footerCtrl.text = vm.footerMessage;
    });
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _alamatCtrl.dispose();
    _catatanCtrl.dispose();
    _footerCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(OutletVM vm) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: _blue),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                vm.pickFoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: _blue),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                vm.pickFoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save(OutletVM vm) async {
    await vm.save(
      newNama: _namaCtrl.text,
      newAlamat: _alamatCtrl.text,
      newCatatan: _catatanCtrl.text,
      newFooter: _footerCtrl.text,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pengaturan outlet berhasil disimpan'),
          backgroundColor: _blue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _showSettingOmzet(OutletVM vm) {
    String temp = vm.settingOmzet;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Setting Omzet',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _omzetOption(ctx, setS, temp, 'selesai',
                    'Berdasarkan Transaksi Selesai', (v) => temp = v),
                const SizedBox(height: 10),
                _omzetOption(ctx, setS, temp, 'lunas',
                    'Berdasarkan Transaksi Lunas', (v) => temp = v),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      vm.saveSettingOmzet(temp);
                      Navigator.pop(ctx);
                    },
                    child: const Text('Simpan',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _omzetOption(BuildContext ctx, StateSetter setS, String current,
      String value, String label, Function(String) onChange) {
    final selected = current == value;
    return GestureDetector(
      onTap: () => setS(() => onChange(value)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? _blue : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? _blue : Colors.grey.shade300),
        ),
        child: Row(
          children: [
            if (selected)
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
            if (selected) const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFotoArea(OutletVM vm) {
    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => _pickImage(vm),
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: vm.fotoPath != null && File(vm.fotoPath!).existsSync()
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(11),
                      child: Image.file(File(vm.fotoPath!), fit: BoxFit.cover),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, color: Colors.grey.shade400, size: 32),
                        const SizedBox(height: 4),
                        Text('Foto', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      ],
                    ),
            ),
          ),
          if (vm.fotoPath != null)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: vm.removeFoto,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 18),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => _pickImage(vm),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(color: _blue, shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController ctrl, IconData icon,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black87)),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: maxLines > 1 ? 70 : 48,
              decoration: BoxDecoration(
                color: _blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: ctrl,
                maxLines: maxLines,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _blue, width: 1.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavRow(String label, IconData icon, VoidCallback onTap,
      {String? subtitle}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: _blue, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 14)),
                  if (subtitle != null)
                    Text(subtitle,
                        style: TextStyle(
                            fontSize: 11, color: Colors.red.shade400)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OutletVM>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: _bg,
          body: Column(
            children: [
              const HeaderWidget(title: 'Pengaturan Outlet'),
              Expanded(
                child: vm.isLoading
                    ? const Center(child: CircularProgressIndicator(color: _blue))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── FOTO ─────────────────────────────────────
                            _buildFotoArea(vm),
                            const SizedBox(height: 20),

                            // ── NAMA OUTLET ───────────────────────────────
                            _buildTextField('Nama Outlet', _namaCtrl,
                                Icons.store_outlined),
                            const SizedBox(height: 14),

                            // ── ALAMAT ────────────────────────────────────
                            _buildTextField('Alamat Outlet', _alamatCtrl,
                                Icons.location_on_outlined,
                                maxLines: 2),
                            const SizedBox(height: 14),

                            // ── CATATAN ───────────────────────────────────
                            _buildTextField('Catatan', _catatanCtrl,
                                Icons.notes_outlined,
                                maxLines: 2),
                            const SizedBox(height: 14),

                            // ── FOOTER MESSAGE ───────────────────────────
                            _buildTextField('Footer Message', _footerCtrl,
                                Icons.message_outlined,
                                maxLines: 2),
                            const SizedBox(height: 24),

                            // ── SETTING OMZET ─────────────────────────────
                            _buildSectionTitle('Setting Omzet'),
                            _buildNavRow(
                              vm.settingOmzet == 'lunas'
                                  ? 'Berdasarkan Transaksi Lunas'
                                  : 'Berdasarkan Transaksi Selesai',
                              Icons.bar_chart_outlined,
                              () => _showSettingOmzet(vm),
                            ),
                            _buildNavRow(
                              'Template Struk',
                              Icons.receipt_long_outlined,
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ChangeNotifierProvider.value(
                                          value: vm,
                                          child: const OutletTemplatePage(),
                                        )),
                              ),
                            ),
                            _buildNavRow(
                              'Printer',
                              Icons.print_outlined,
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const OutletPrinterPage()),
                              ),
                              subtitle: 'Tidak Ada Printer yang terhubung!',
                            ),
                            const SizedBox(height: 16),

                            // ── PENGATURAN PRINTER ────────────────────────
                            _buildSectionTitle('Pengaturan Printer'),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Cashdrawer',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      Switch(
                                        value: vm.cashdrawer,
                                        onChanged: vm.toggleCashdrawer,
                                        activeThumbColor: _blue,
                                      ),
                                    ],
                                  ),
                                  Divider(color: Colors.grey.shade200, height: 1),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Printer AutoCut',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      Switch(
                                        value: vm.autoCut,
                                        onChanged: vm.toggleAutoCut,
                                        activeThumbColor: _blue,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // ── PENGATURAN LAINNYA ────────────────────────
                            _buildSectionTitle('Pengaturan Lainnya'),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              ChangeNotifierProvider.value(
                                                value: vm,
                                                child:
                                                    const OutletMetodePage(),
                                              )),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 14),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.grey.shade200),
                                      ),
                                      child: const Row(
                                        children: [
                                          Text('Metode Pembayaran',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.w500)),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 14),
                                  ),
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            ChangeNotifierProvider.value(
                                              value: vm,
                                              child: const OutletMetodePage(),
                                            )),
                                  ),
                                  child: const Text('Kelola Data',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: const Icon(Icons.upload, color: _blue),
                                    label: const Text('Backup',
                                        style: TextStyle(color: _blue)),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      side: BorderSide(
                                          color: Colors.grey.shade300),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content:
                                                  Text('Fitur backup segera hadir')));
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    icon: const Icon(Icons.download,
                                        color: _blue),
                                    label: const Text('Restore',
                                        style: TextStyle(color: _blue)),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14),
                                      side: BorderSide(
                                          color: Colors.grey.shade300),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Fitur restore segera hadir')));
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
              ),
              // ── SIMPAN BUTTON ─────────────────────────────────────────────
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: vm.isSaving ? null : () => _save(vm),
                    child: vm.isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text('Simpan',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
