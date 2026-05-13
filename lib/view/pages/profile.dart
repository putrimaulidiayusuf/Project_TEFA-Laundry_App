import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_laundry/core/database/app_database.dart';
import 'package:app_laundry/view/viewmodels/profile_vm.dart';
import 'package:app_laundry/view/viewmodels/kasir_vm.dart';
import 'package:app_laundry/view/pages/kasir.dart';

// ─── Warna ────────────────────────────────────────────────────────────────────
const _blue1 = Color(0xFF0A4174);
const _blueSoft = Color(0xFF5A86AE);
const _bgColor = Color(0xFFF4F6F8);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ProfileVM>().load();
      // Sync KasirVM juga agar list terbaru
      if (mounted) await context.read<KasirVM>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Consumer<ProfileVM>(
              builder: (context, vm, _) {
                if (vm.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: _blue1),
                  );
                }
                if (vm.kasirList.isEmpty) {
                  return _buildEmptyState(context);
                }
                return _buildContent(context, vm);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── HEADER ──────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _blue1,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 4),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Kasir Aktif',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              // Tombol ke halaman kelola kasir
              IconButton(
                icon: const Icon(Icons.manage_accounts, color: Colors.white),
                tooltip: 'Kelola Kasir',
                onPressed: () => _goToKelolaKasir(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── EMPTY STATE ─────────────────────────────────────────────────────────────
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.badge_outlined, size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'Belum ada kasir terdaftar',
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambah kasir melalui Kelola Kasir',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _blue1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Kelola Kasir',
                style: TextStyle(color: Colors.white)),
            onPressed: () => _goToKelolaKasir(context),
          ),
        ],
      ),
    );
  }

  // ── MAIN CONTENT ─────────────────────────────────────────────────────────────
  Widget _buildContent(BuildContext context, ProfileVM vm) {
    final selected = vm.selectedKasir;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── KASIR TERPILIH ─────────────────────────────────────────────────
          if (selected != null) _buildSelectedCard(context, vm, selected),

          // ── GANTI KASIR ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: _blue1,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Ganti Kasir',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _blue1,
                  ),
                ),
              ],
            ),
          ),

          // ── LIST KASIR ─────────────────────────────────────────────────────
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: vm.kasirList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final kasir = vm.kasirList[i];
              final isSelected = selected?.id == kasir.id;
              return _buildKasirListItem(context, vm, kasir, isSelected);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ── CARD KASIR TERPILIH ───────────────────────────────────────────────────
  Widget _buildSelectedCard(BuildContext context, ProfileVM vm, Kasir kasir) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_blue1, _blueSoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _blue1.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          _buildAvatar(kasir, radius: 36),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Kasir Aktif',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  kasir.nama,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (kasir.noHp != null && kasir.noHp!.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.phone, size: 13, color: Colors.white60),
                      const SizedBox(width: 4),
                      Text(
                        kasir.noHp!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: kasir.isAktif
                        ? Colors.green.shade400
                        : Colors.red.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    kasir.isAktif ? '✓ Aktif' : 'Nonaktif',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tombol Edit
          Column(
            children: [
              GestureDetector(
                onTap: () => _editKasir(context, vm, kasir),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.4), width: 1),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Edit',
                style: TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── ITEM LIST KASIR ───────────────────────────────────────────────────────
  Widget _buildKasirListItem(
      BuildContext context, ProfileVM vm, Kasir kasir, bool isSelected) {
    return GestureDetector(
      onTap: isSelected ? null : () => _pilihKasir(context, vm, kasir),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? _blue1.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _blue1 : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _blue1.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Row(
          children: [
            _buildAvatar(kasir, radius: 24),
            const SizedBox(width: 12),

            // Info kasir
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kasir.nama,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isSelected ? _blue1 : Colors.black87,
                    ),
                  ),
                  if (kasir.noHp != null && kasir.noHp!.isNotEmpty)
                    Text(
                      kasir.noHp!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: kasir.isAktif
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      kasir.isAktif ? 'Aktif' : 'Nonaktif',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: kasir.isAktif
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Status terpilih atau tombol pilih
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _blue1,
                  borderRadius: BorderRadius.circular(20),
                ),
                child:
                    const Icon(Icons.check, color: Colors.white, size: 16),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _bgColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Text(
                  'Pilih',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _blue1,
                  ),
                ),
              ),

            // Tombol edit (hanya icon kecil)
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _editKasir(context, vm, kasir),
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: _blueSoft.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit_outlined,
                    size: 16, color: _blueSoft),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── AVATAR HELPER ─────────────────────────────────────────────────────────
  Widget _buildAvatar(Kasir kasir, {double radius = 26}) {
    if (kasir.fotoPath != null && kasir.fotoPath!.isNotEmpty) {
      final f = File(kasir.fotoPath!);
      if (f.existsSync()) {
        return CircleAvatar(
          radius: radius,
          backgroundImage: FileImage(f),
        );
      }
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: _blue1,
      child: Text(
        kasir.nama.isNotEmpty ? kasir.nama[0].toUpperCase() : '?',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.75,
        ),
      ),
    );
  }

  // ── ACTIONS ───────────────────────────────────────────────────────────────
  void _pilihKasir(BuildContext context, ProfileVM vm, Kasir kasir) {
    vm.selectKasir(kasir);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kasir "${kasir.nama}" dipilih'),
        backgroundColor: _blue1,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _editKasir(
      BuildContext context, ProfileVM vm, Kasir kasir) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<KasirVM>(),
          child: KasirFormPage(kasir: kasir),
        ),
      ),
    );
    // Reload setelah edit agar data terbaru tampil
    if (mounted) await vm.load();
  }

  Future<void> _goToKelolaKasir(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<KasirVM>(),
          child: const KasirPage(),
        ),
      ),
    );
    // Reload setelah kembali dari kelola kasir
    if (mounted) await context.read<ProfileVM>().load();
  }
}
