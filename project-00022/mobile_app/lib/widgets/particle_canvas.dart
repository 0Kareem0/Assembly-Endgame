import 'dart:math';
import 'package:flutter/material.dart';

class ParticleCanvasWidget extends StatefulWidget {
  final bool isShaking;
  const ParticleCanvasWidget({super.key, this.isShaking = false});

  @override
  State<ParticleCanvasWidget> createState() => _ParticleCanvasWidgetState();
}

class _ParticleCanvasWidgetState extends State<ParticleCanvasWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    for (int i = 0; i < 40; i++) {
      _particles.add(_Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        radius: _random.nextDouble() * 2 + 1,
        speedY: _random.nextDouble() * 0.05 + 0.02,
        opacity: _random.nextDouble() * 0.5 + 0.2,
        isCyan: _random.nextBool(),
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _ParticlePainter(particles: _particles, progress: _controller.value),
        );
      },
    );
  }
}

class _Particle {
  double x;
  double y;
  double radius;
  double speedY;
  double opacity;
  bool isCyan;

  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speedY,
    required this.opacity,
    required this.isCyan,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final currentY = (p.y - progress * p.speedY) % 1.0;
      final offset = Offset(p.x * size.width, currentY * size.height);

      final paint = Paint()
        ..color = (p.isCyan ? const Color(0xFF38BDF8) : const Color(0xFFF59E0B))
            .withValues(alpha: p.opacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(offset, p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
