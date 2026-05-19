import 'package:flutter/material.dart';

/// Custom route dengan animasi slide kanan→kiri (buka) dan kiri→kanan (tutup).
/// Gunakan sebagai pengganti [MaterialPageRoute] di seluruh aplikasi.
///
/// Contoh pemakaian:
/// ```dart
/// Navigator.push(context, SlideRoute(page: const HalamanBaru()));
/// ```
class SlideRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideRoute({required this.page, super.settings})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 280),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            // Halaman baru: masuk dari kanan ke kiri
            final slideIn = Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ));

            // Fade ringan agar transisi terasa lebih halus
            final fadeIn = Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
            ));

            return FadeTransition(
              opacity: fadeIn,
              child: SlideTransition(
                position: slideIn,
                child: child,
              ),
            );
          },
        );
}
