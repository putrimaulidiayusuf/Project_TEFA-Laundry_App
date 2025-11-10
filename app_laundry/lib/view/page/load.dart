import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'login.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> with SingleTickerProviderStateMixin {
  final Random _random = Random();
  late AnimationController _controller;
  final List<Bubble> _bubbles = [];
  Timer? _bubbleTimer;

  @override
  void initState() {
    super.initState();

    // Navigasi ke login setelah 5 detik
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    });

    // Animasi gelembung
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addListener(() {
            setState(() {
              for (var b in _bubbles) {
                b.y -= b.speed;
                b.x += sin(b.y * pi * 2) * 0.002; // gerak zig-zag
                if (b.y < -0.1) {
                  b.y = 0.8; // reset dari dekat posisi logo
                  b.x = 0.5 + _random.nextDouble() * 0.1 - 0.05; // horizontal random di sekitar logo
                  b.size = 16 + _random.nextDouble() * 16;
                  b.speed = 0.005 + _random.nextDouble() * 0.01;
                }
              }
            });
          })
          ..repeat();

    // Timer untuk menambah gelembung baru secara berkala
    _bubbleTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (_bubbles.length < 20) {
        _bubbles.add(Bubble(
          x: 0.5 + _random.nextDouble() * 0.1 - 0.05, // start di sekitar logo
          y: 0.8, // start dari posisi logo
          size: 16 + _random.nextDouble() * 16,
          speed: 0.005 + _random.nextDouble() * 0.01,
        ));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _bubbleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFF49769F),
              Color(0xFF0A4174),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Gelembung
            ..._bubbles.map((b) {
              return Positioned(
                left: b.x * screenWidth,
                top: b.y * screenHeight,
                child: Opacity(
                  opacity: (1 - (0.8 - b.y)).clamp(0.0, 1.0), // hilang saat naik
                  child: Image.asset(
                    'assets/bubble.png',
                    width: b.size,
                    height: b.size,
                  ),
                ),
              );
            }).toList(),

            // Logo
            Image.asset(
              'assets/logo.png',
              height: 120,
              width: 120,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}

// Kelas Bubble
class Bubble {
  double x; // posisi horizontal 0..1
  double y; // posisi vertical 0..1
  double size;
  double speed;

  Bubble({required this.x, required this.y, required this.size, required this.speed});
}
