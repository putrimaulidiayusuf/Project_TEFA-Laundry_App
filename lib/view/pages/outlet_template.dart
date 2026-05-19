import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_laundry/view/widgets/header.dart';
import 'package:app_laundry/view/viewmodels/outlet_vm.dart';
import 'package:app_laundry/view/pages/custom_struk_page.dart';
import 'package:app_laundry/core/routes/slide_route.dart';

const _blue = Color(0xFF003B73);
const _blueAccent = Color(0xFF1565C0);
const _bg = Color(0xFFF0F4F8);

class OutletTemplatePage extends StatelessWidget {
  const OutletTemplatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OutletVM>(builder: (context, vm, _) {
      return Scaffold(
        backgroundColor: _bg,
        body: Column(
          children: [
            const HeaderWidget(title: 'Template Print'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSizeSection(context, vm, '58 mm', [
                      _TemplateItem(
                        id: 'default_58',
                        label: 'Default',
                        isCustom: false,
                        current: vm.templateStruk,
                        onSelect: vm.saveTemplate,
                      ),
                      _TemplateItem(
                        id: 'custom_58',
                        label: 'Custom Struk',
                        isCustom: true,
                        current: vm.templateStruk,
                        onSelect: vm.saveTemplate,
                        onSettingsTap: () => Navigator.push(
                          context,
                          SlideRoute(page: const CustomStrukPage()),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 24),
                    _buildSizeSection(context, vm, '80 mm', [
                      _TemplateItem(
                        id: 'default_80',
                        label: 'Default',
                        isCustom: false,
                        current: vm.templateStruk,
                        onSelect: vm.saveTemplate,
                      ),
                      _TemplateItem(
                        id: 'custom_80',
                        label: 'Custom Struk',
                        isCustom: true,
                        current: vm.templateStruk,
                        onSelect: vm.saveTemplate,
                        onSettingsTap: () => Navigator.push(
                          context,
                          SlideRoute(page: const CustomStrukPage()),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSizeSection(BuildContext context, OutletVM vm, String ukuran,
      List<_TemplateItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            Text('Ukuran Kertas $ukuran',
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87)),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: items
              .map((item) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: item,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _TemplateItem extends StatelessWidget {
  final String id;
  final String label;
  final bool isCustom;
  final String current;
  final Future<void> Function(String) onSelect;
  final VoidCallback? onSettingsTap;

  const _TemplateItem({
    required this.id,
    required this.label,
    required this.isCustom,
    required this.current,
    required this.onSelect,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = current == id;

    return GestureDetector(
      onTap: () => onSelect(id),
      child: Column(
        children: [
          Stack(
            children: [
              // ── Card border ──────────────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 190,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? _blueAccent : Colors.grey.shade200,
                    width: isSelected ? 2.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isSelected
                          ? _blue.withValues(alpha: 0.12)
                          : Colors.black.withValues(alpha: 0.05),
                      blurRadius: isSelected ? 10 : 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: isCustom ? _buildCustomPreview() : _buildDefaultPreview(),
                ),
              ),

              // ── "Di Pakai" badge ─────────────────────────────────
              if (isSelected)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _blueAccent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _blueAccent.withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, color: Colors.white, size: 10),
                        SizedBox(width: 3),
                        Text('Di Pakai',
                            style:
                                TextStyle(color: Colors.white, fontSize: 10)),
                      ],
                    ),
                  ),
                ),

              // ── Settings gear icon (hanya di custom) ─────────────
              if (isCustom)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onSettingsTap,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _blue,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: _blue.withValues(alpha: 0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.settings,
                          color: Colors.white, size: 15),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(label,
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? _blue : Colors.black87,
              )),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // DEFAULT PREVIEW — putih bersih, logo abu-abu
  // ══════════════════════════════════════════════════════════════════
  Widget _buildDefaultPreview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFC107),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.local_laundry_service,
                color: Colors.white, size: 20),
          ),
          const SizedBox(height: 5),

          // Nama outlet
          Container(
              width: 80, height: 5, color: Colors.grey.shade400,
              margin: const EdgeInsets.only(bottom: 3)),
          Container(
              width: 60, height: 3, color: Colors.grey.shade300,
              margin: const EdgeInsets.only(bottom: 7)),

          // Divider
          _dottedLine(),
          const SizedBox(height: 5),

          // Info rows
          ..._infoRows(4, 'default'),

          const SizedBox(height: 5),
          _dottedLine(),
          const SizedBox(height: 5),

          // Items
          _itemRow(),
          const SizedBox(height: 3),
          _itemRow(width2: 40),

          const SizedBox(height: 5),
          _dottedLine(),
          const SizedBox(height: 5),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 30, height: 3, color: Colors.grey.shade400),
              Container(width: 30, height: 3, color: Colors.grey.shade500),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 24, height: 3, color: Colors.grey.shade300),
              Container(width: 24, height: 3, color: Colors.grey.shade300),
            ],
          ),

          const SizedBox(height: 6),
          _dottedLine(),
          const SizedBox(height: 5),

          // Footer
          Center(
            child: Column(children: [
              Container(width: 50, height: 3, color: Colors.grey.shade300),
              const SizedBox(height: 2),
              Container(width: 40, height: 2, color: Colors.grey.shade200),
            ]),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // CUSTOM PREVIEW — tema biru, header biru, logo putih
  // ══════════════════════════════════════════════════════════════════
  Widget _buildCustomPreview() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header biru
        Container(
          width: double.infinity,
          color: _blue,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              // Logo putih
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4), width: 1),
                ),
                child: const Icon(Icons.local_laundry_service,
                    color: Colors.white, size: 17),
              ),
              const SizedBox(height: 4),
              Container(
                  width: 70, height: 4, color: Colors.white.withValues(alpha: 0.8),
                  margin: const EdgeInsets.only(bottom: 2)),
              Container(
                  width: 50, height: 3, color: Colors.white.withValues(alpha: 0.5)),
            ],
          ),
        ),

        // Body struk
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Info rows dengan garis biru
              ..._infoRowsBlue(4),

              const SizedBox(height: 4),
              Container(
                  width: double.infinity, height: 1,
                  color: _blue.withValues(alpha: 0.3)),
              const SizedBox(height: 4),

              // Items
              _itemRowBlue(),
              const SizedBox(height: 2),
              _itemRowBlue(width2: 40),

              const SizedBox(height: 4),
              Container(
                  width: double.infinity, height: 1,
                  color: _blue.withValues(alpha: 0.3)),
              const SizedBox(height: 4),

              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 28, height: 3,
                      color: _blue.withValues(alpha: 0.5)),
                  Container(width: 32, height: 4,
                      decoration: BoxDecoration(
                        color: _blue,
                        borderRadius: BorderRadius.circular(2),
                      )),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 22, height: 2,
                      color: Colors.grey.shade300),
                  Container(width: 22, height: 2,
                      color: Colors.grey.shade300),
                ],
              ),

              const SizedBox(height: 5),
              // Footer biru
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _blue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(children: [
                    Container(
                        width: 50, height: 3,
                        color: _blue.withValues(alpha: 0.5)),
                    const SizedBox(height: 2),
                    Container(
                        width: 38, height: 2,
                        color: _blue.withValues(alpha: 0.3)),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // Helpers
  // ══════════════════════════════════════════════════════════════════

  Widget _dottedLine() {
    return Row(
      children: List.generate(
        18,
        (i) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 1),
            height: 1,
            color: i.isEven ? Colors.grey.shade400 : Colors.transparent,
          ),
        ),
      ),
    );
  }

  List<Widget> _infoRows(int count, String variant) {
    return List.generate(count, (i) {
      final w1 = [30.0, 38.0, 32.0, 36.0][i % 4];
      final w2 = [28.0, 32.0, 26.0, 34.0][i % 4];
      return Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(width: w1, height: 3, color: Colors.grey.shade400),
            Container(width: w2, height: 3, color: Colors.grey.shade300),
          ],
        ),
      );
    });
  }

  List<Widget> _infoRowsBlue(int count) {
    return List.generate(count, (i) {
      final w1 = [30.0, 38.0, 32.0, 36.0][i % 4];
      final w2 = [28.0, 32.0, 26.0, 34.0][i % 4];
      return Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: w1, height: 3,
                color: _blue.withValues(alpha: 0.4)),
            Container(
                width: w2, height: 3,
                color: _blue.withValues(alpha: 0.25)),
          ],
        ),
      );
    });
  }

  Widget _itemRow({double width2 = 50}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 60, height: 3, color: Colors.grey.shade500,
              margin: const EdgeInsets.only(bottom: 2)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 40, height: 3, color: Colors.grey.shade300),
              Container(width: width2, height: 3, color: Colors.grey.shade400),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemRowBlue({double width2 = 50}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 60, height: 3,
              color: _blue.withValues(alpha: 0.5),
              margin: const EdgeInsets.only(bottom: 2)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 40, height: 3,
                  color: _blue.withValues(alpha: 0.25)),
              Container(
                  width: width2, height: 3,
                  color: _blue.withValues(alpha: 0.4)),
            ],
          ),
        ],
      ),
    );
  }
}
