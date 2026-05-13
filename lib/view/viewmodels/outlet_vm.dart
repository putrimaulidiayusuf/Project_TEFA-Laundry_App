import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OutletVM extends ChangeNotifier {
  // ── Keys ─────────────────────────────────────────────────────────────────
  static const _kNama = 'outlet_nama';
  static const _kAlamat = 'outlet_alamat';
  static const _kCatatan = 'outlet_catatan';
  static const _kFooter = 'outlet_footer';
  static const _kFoto = 'outlet_foto';
  static const _kSettingOmzet = 'outlet_setting_omzet';
  static const _kCashdrawer = 'outlet_cashdrawer';
  static const _kAutoCut = 'outlet_autocut';
  static const _kTemplateStruk = 'outlet_template_struk';
  static const _kMetodeBayar = 'outlet_metode_bayar';

  // ── State ─────────────────────────────────────────────────────────────────
  bool isLoading = false;
  bool isSaving = false;

  String nama = '';
  String alamat = '';
  String catatan = '';
  String footerMessage = '';
  String? fotoPath;

  /// 'selesai' | 'lunas'
  String settingOmzet = 'selesai';

  bool cashdrawer = false;
  bool autoCut = false;

  /// 'default_58' | 'custom_58' | 'default_80' | 'custom_80'
  String templateStruk = 'default_58';

  List<String> metodeBayar = ['Cash', 'Transfer'];

  // ── Load ──────────────────────────────────────────────────────────────────
  Future<void> load() async {
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    nama = prefs.getString(_kNama) ?? '';
    alamat = prefs.getString(_kAlamat) ?? '';
    catatan = prefs.getString(_kCatatan) ?? '';
    footerMessage = prefs.getString(_kFooter) ?? '';
    fotoPath = prefs.getString(_kFoto);
    settingOmzet = prefs.getString(_kSettingOmzet) ?? 'selesai';
    cashdrawer = prefs.getBool(_kCashdrawer) ?? false;
    autoCut = prefs.getBool(_kAutoCut) ?? false;
    templateStruk = prefs.getString(_kTemplateStruk) ?? 'default_58';
    final metodeRaw = prefs.getStringList(_kMetodeBayar);
    metodeBayar = metodeRaw ?? ['Cash', 'Transfer'];

    isLoading = false;
    notifyListeners();
  }

  // ── Save ──────────────────────────────────────────────────────────────────
  Future<void> save({
    required String newNama,
    required String newAlamat,
    required String newCatatan,
    required String newFooter,
    String? newFotoPath,
  }) async {
    isSaving = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kNama, newNama);
    await prefs.setString(_kAlamat, newAlamat);
    await prefs.setString(_kCatatan, newCatatan);
    await prefs.setString(_kFooter, newFooter);
    if (newFotoPath != null) {
      await prefs.setString(_kFoto, newFotoPath);
      fotoPath = newFotoPath;
    }
    nama = newNama;
    alamat = newAlamat;
    catatan = newCatatan;
    footerMessage = newFooter;

    isSaving = false;
    notifyListeners();
  }

  // ── Setting Omzet ─────────────────────────────────────────────────────────
  Future<void> saveSettingOmzet(String value) async {
    settingOmzet = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSettingOmzet, value);
    notifyListeners();
  }

  // ── Toggle ────────────────────────────────────────────────────────────────
  Future<void> toggleCashdrawer(bool v) async {
    cashdrawer = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kCashdrawer, v);
    notifyListeners();
  }

  Future<void> toggleAutoCut(bool v) async {
    autoCut = v;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kAutoCut, v);
    notifyListeners();
  }

  // ── Template Struk ────────────────────────────────────────────────────────
  Future<void> saveTemplate(String value) async {
    templateStruk = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTemplateStruk, value);
    notifyListeners();
  }

  // ── Metode Bayar ──────────────────────────────────────────────────────────
  Future<void> tambahMetode(String metode) async {
    if (metode.trim().isEmpty) return;
    if (metodeBayar.contains(metode.trim())) return;
    metodeBayar = [...metodeBayar, metode.trim()];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kMetodeBayar, metodeBayar);
    notifyListeners();
  }

  Future<void> hapusMetode(String metode) async {
    metodeBayar = metodeBayar.where((m) => m != metode).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kMetodeBayar, metodeBayar);
    notifyListeners();
  }

  // ── Foto ──────────────────────────────────────────────────────────────────
  Future<void> pickFoto(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: source, imageQuality: 75);
    if (picked != null) {
      fotoPath = picked.path;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kFoto, picked.path);
      notifyListeners();
    }
  }

  void removeFoto() async {
    fotoPath = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kFoto);
    notifyListeners();
  }
}
