import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_laundry/view/widgets/header.dart';

const _blue = Color(0xFF003B73);
const _blueLight = Color(0xFF1565C0);
const _blueAccent = Color(0xFF0D47A1);
const _bg = Color(0xFFF0F4F8);

class CustomStrukPage extends StatefulWidget {
  const CustomStrukPage({super.key});

  @override
  State<CustomStrukPage> createState() => _CustomStrukPageState();
}

class _CustomStrukPageState extends State<CustomStrukPage> {
  // Keys
  static const _prefix = 'custom_struk_';

  // Toggle settings
  final Map<String, bool> _settings = {
    'logo': true,
    'nama_outlet': true,
    'alamat_outlet': true,
    'no_nota': true,
    'nama_pelanggan': true,
    'tanggal': true,
    'tanggal_estimasi': true,
    'nama_kasir': true,
    'status_transaksi': true,
    'metode_bayar': true,
    'sembunyikan_diskon_0': true,
    'sembunyikan_kembalian_0': true,
    'keterangan': true,
    'catatan': true,
    'footer_message': true,
  };

  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (final key in _settings.keys) {
        _settings[key] = prefs.getBool('$_prefix$key') ?? true;
      }
      _loading = false;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final prefs = await SharedPreferences.getInstance();
    for (final entry in _settings.entries) {
      await prefs.setBool('$_prefix${entry.key}', entry.value);
    }
    setState(() => _saving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Custom Struk berhasil disimpan'),
          backgroundColor: _blue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.pop(context);
    }
  }

  void _toggle(String key, bool val) {
    setState(() => _settings[key] = val);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          const HeaderWidget(title: 'Custom Struk'),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator(color: _blue))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Info Banner ──────────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: _blue.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: _blue.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color: _blue, size: 18),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Text(
                                  'Atur bagian mana yang ingin ditampilkan pada struk custom kamu.',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF003B73)),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ── HEADER INFO ───────────────────────────────────
                        _buildSectionTitle('Informasi Outlet'),
                        _buildToggleGroup([
                          _ToggleItem('logo', 'Logo', Icons.image_outlined),
                          _ToggleItem('nama_outlet', 'Nama Outlet',
                              Icons.store_outlined),
                          _ToggleItem('alamat_outlet', 'Alamat Outlet',
                              Icons.location_on_outlined),
                        ]),
                        const SizedBox(height: 16),

                        // ── TRANSAKSI INFO ────────────────────────────────
                        _buildSectionTitle('Informasi Transaksi'),
                        _buildToggleGroup([
                          _ToggleItem(
                              'no_nota', 'No Nota', Icons.tag_outlined),
                          _ToggleItem('nama_pelanggan', 'Nama Pelanggan',
                              Icons.person_outline),
                          _ToggleItem(
                              'tanggal', 'Tanggal', Icons.calendar_today_outlined),
                          _ToggleItem('tanggal_estimasi',
                              'Tanggal Estimasi / Selesai', Icons.schedule_outlined),
                          _ToggleItem('nama_kasir', 'Nama Kasir',
                              Icons.badge_outlined),
                        ]),
                        const SizedBox(height: 16),

                        // ── PEMBAYARAN ────────────────────────────────────
                        _buildSectionTitle('Pembayaran'),
                        _buildToggleGroup([
                          _ToggleItem('status_transaksi', 'Status Transaksi',
                              Icons.check_circle_outline),
                          _ToggleItem('metode_bayar', 'Metode Bayar',
                              Icons.payment_outlined),
                          _ToggleItem('sembunyikan_diskon_0',
                              'Sembunyikan Diskon saat "0"',
                              Icons.discount_outlined),
                          _ToggleItem('sembunyikan_kembalian_0',
                              'Sembunyikan Kembalian saat "0"',
                              Icons.money_off_outlined),
                        ]),
                        const SizedBox(height: 16),

                        // ── FOOTER ────────────────────────────────────────
                        _buildSectionTitle('Catatan & Footer'),
                        _buildToggleGroup([
                          _ToggleItem('keterangan', 'Keterangan',
                              Icons.notes_outlined),
                          _ToggleItem(
                              'catatan', 'Catatan', Icons.sticky_note_2_outlined),
                          _ToggleItem('footer_message', 'Footer Message',
                              Icons.message_outlined),
                        ]),
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
                onPressed: _saving ? null : _save,
                child: _saving
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
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: _blue,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003B73))),
        ],
      ),
    );
  }

  Widget _buildToggleGroup(List<_ToggleItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final isLast = i == items.length - 1;
          final isOn = _settings[item.key] ?? true;

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: isOn
                            ? _blue.withValues(alpha: 0.1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        item.icon,
                        size: 18,
                        color: isOn ? _blue : Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isOn ? Colors.black87 : Colors.grey.shade500,
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.85,
                      child: Switch(
                        value: isOn,
                        onChanged: (v) => _toggle(item.key, v),
                        activeThumbColor: Colors.white,
                        activeTrackColor: _blueAccent,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey.shade300,
                        trackOutlineColor:
                            WidgetStateProperty.all(Colors.transparent),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                    color: Colors.grey.shade100,
                    height: 1,
                    indent: 60,
                    endIndent: 14),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ToggleItem {
  final String key;
  final String label;
  final IconData icon;
  const _ToggleItem(this.key, this.label, this.icon);
}
