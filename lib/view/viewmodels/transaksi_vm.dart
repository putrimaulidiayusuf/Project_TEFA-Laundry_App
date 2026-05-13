import 'package:flutter/material.dart';
import 'package:app_laundry/core/database/app_database.dart';
import 'package:app_laundry/data/repositories/transaction_repository.dart';

// ============================================================
// CartItem — model item keranjang (lokal, tidak di DB)
// ============================================================
class CartItem {
  final ServiceType serviceType;
  final Service service;
  final Unit unit;
  final double qty;
  final Perfume? perfume;

  CartItem({
    required this.serviceType,
    required this.service,
    required this.unit,
    required this.qty,
    this.perfume,
  });

  double get subtotal => serviceType.price * qty;
}

// ============================================================
// TransaksiVM — cart state untuk halaman transaksi/checkout
// ============================================================
class TransaksiVM extends ChangeNotifier {
  final TransactionRepository _repo;

  TransaksiVM(this._repo);

  // ── State ────────────────────────────────────────────────
  final List<CartItem> _items = [];
  Customer? _pelanggan;
  String _keterangan = '';
  DateTime _tanggalMasuk = DateTime.now();
  DateTime _estimasiSelesai = DateTime.now().add(const Duration(days: 2));
  bool _langsungBayar = false;
  String _metodeBayar = 'Cash';
  double _diskon = 0;
  bool _diskonPersen = false;

  // ── Getters ──────────────────────────────────────────────
  List<CartItem> get items => List.unmodifiable(_items);
  Customer? get pelanggan => _pelanggan;
  String get keterangan => _keterangan;
  DateTime get tanggalMasuk => _tanggalMasuk;
  DateTime get estimasiSelesai => _estimasiSelesai;
  bool get langsungBayar => _langsungBayar;
  String get metodeBayar => _metodeBayar;
  double get diskon => _diskon;
  bool get diskonPersen => _diskonPersen;

  double get subtotal => _items.fold(0.0, (s, i) => s + i.subtotal);

  double get total {
    if (_diskonPersen) {
      final disc = subtotal * (_diskon / 100);
      return (subtotal - disc).clamp(0, double.infinity);
    } else {
      return (subtotal - _diskon).clamp(0, double.infinity);
    }
  }

  // ── Mutators ─────────────────────────────────────────────
  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void setPelanggan(Customer? c) {
    _pelanggan = c;
    notifyListeners();
  }

  void setKeterangan(String v) {
    _keterangan = v;
    notifyListeners();
  }

  void setTanggalMasuk(DateTime dt) {
    _tanggalMasuk = dt;
    notifyListeners();
  }

  void setEstimasiSelesai(DateTime dt) {
    _estimasiSelesai = dt;
    notifyListeners();
  }

  void setLangsungBayar(bool v) {
    _langsungBayar = v;
    notifyListeners();
  }

  void setMetodeBayar(String v) {
    _metodeBayar = v;
    notifyListeners();
  }

  void setDiskon(double val, bool persen) {
    _diskon = val;
    _diskonPersen = persen;
    notifyListeners();
  }

  // ── Reset / Checkout ─────────────────────────────────────
  void reset() {
    _items.clear();
    _pelanggan = null;
    _keterangan = '';
    _tanggalMasuk = DateTime.now();
    _estimasiSelesai = DateTime.now().add(const Duration(days: 2));
    _langsungBayar = false;
    _metodeBayar = 'Cash';
    _diskon = 0;
    _diskonPersen = false;
    notifyListeners();
  }

  Future<void> checkout({double? jumlahBayar}) async {
    if (_pelanggan == null) throw Exception('Pelanggan belum dipilih');
    if (_items.isEmpty) throw Exception('Keranjang masih kosong');

    await _repo.createFull(
      customerId: _pelanggan!.id,
      items: _items,
      keterangan: _keterangan,
      tanggalMasuk: _tanggalMasuk,
      estimasiSelesai: _estimasiSelesai,
      metodeBayar: _metodeBayar,
      diskon: _diskon,
      diskonPersen: _diskonPersen,
      jumlahBayar: jumlahBayar ?? total,
    );

    reset();
  }
}
