import 'package:flutter/material.dart';
import 'package:app_laundry/view/widget/header.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TambahPelangganPage extends StatefulWidget {
  const TambahPelangganPage({super.key});

  @override
  State<TambahPelangganPage> createState() => _TambahPelangganPageState();
}

class _TambahPelangganPageState extends State<TambahPelangganPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  File? _fotoProfil;
  String? _jenisKelamin;

  Future<void> _pilihFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _fotoProfil = File(pickedFile.path);
      });
    }
  }

  void _simpan() {
    final nama = _namaController.text.trim();
    final email = _emailController.text.trim();
    final noHp = _noHpController.text.trim();
    final alamat = _alamatController.text.trim();

    if (nama.isEmpty || email.isEmpty || noHp.isEmpty || alamat.isEmpty || _jenisKelamin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua data harus diisi')),
      );
      return;
    }

    final data = {
      'nama': nama,
      'email': email,
      'noHp': noHp,
      'jenisKelamin': _jenisKelamin,
      'alamat': alamat,
      'fotoProfil': _fotoProfil?.path,
    };

    Navigator.pop(context, data);
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(232, 233, 225, 225),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderWidget(title: "Tambah Pelanggan"),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            backgroundImage: _fotoProfil != null ? FileImage(_fotoProfil!) : null,
                            child: _fotoProfil == null
                                ? const Icon(Icons.person, size: 60,  color: Color(0xFF003B73))
                                : null,
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_a_photo,  color: Color(0xFF003B73)),
                            onPressed: _pilihFoto,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                  TextField(
                    controller: _namaController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Pelanggan',
                      prefixIcon: Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    ),
                      const SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                      const SizedBox(height: 12),
                  TextField(
                    controller: _noHpController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'No Handphone',
                      prefixIcon: Icon(Icons.phone),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Jenis Kelamin',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text('Pria'),
                            value: 'Laki-laki',
                            groupValue: _jenisKelamin,
                            shape: const CircleBorder(),
                            onChanged: (value) => setState(() => _jenisKelamin = value),
                            activeColor: const Color(0xFF003B73),
                            contentPadding: EdgeInsets.zero,
                          ),
                          RadioListTile<String>(
                            title: const Text('Wanita'),
                            value: 'Perempuan',
                            groupValue: _jenisKelamin,
                            shape: const CircleBorder(),
                            onChanged: (value) => setState(() => _jenisKelamin = value),
                            activeColor: const Color(0xFF003B73),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                  TextField(
                    controller: _alamatController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Alamat',
                      prefixIcon: Icon(Icons.home),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                      const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _simpan,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Simpan',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF003B73),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                    ],
                  ),
                
              ),
            ),
          ],
        ),
      ),
    );
  }
}