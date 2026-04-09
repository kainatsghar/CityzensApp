import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A performance-optimized multi-layered particle painter.
///
/// Refined for 60 FPS:
/// - Reuses a single [Paint] object to avoid allocations in [paint]
/// - Pre-calculated particle lists
/// - Correct [shouldRepaint] logic
class RoyalParticlePainter extends CustomPainter {
  final double progress;
  final Color color;
  final int layer;
  final List<_DignifiedParticle> _particles = [];

  // Reuse the same paint object to reduce memory pressure
  final Paint _paint = Paint()..style = PaintingStyle.fill;

  RoyalParticlePainter({
    required this.progress,
    required this.color,
    required this.layer,
  }) {
    final random = math.Random(1978 + layer);
    final count = layer == 1 ? 35 : 60;

    for (int i = 0; i < count; i++) {
      _particles.add(
        _DignifiedParticle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: layer == 1
              ? 1.8 + random.nextDouble() * 2.0
              : 0.6 + random.nextDouble() * 1.2,
          speed: layer == 1
              ? 0.03 + random.nextDouble() * 0.04
              : 0.05 + random.nextDouble() * 0.07,
          baseOpacity: layer == 1
              ? 0.08 + random.nextDouble() * 0.18
              : 0.04 + random.nextDouble() * 0.12,
          twinkleFreq: 0.8 + random.nextDouble() * 2.5,
        ),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Avoid double calculation of constants
    final double halfHeight = size.height;
    final double halfWidth = size.width;

    for (var p in _particles) {
      // Calculate positions
      final double yPos =
          (p.y * halfHeight + (progress * halfHeight * p.speed)) % halfHeight;
      final double sway =
          math.sin(progress * 3.76 + (p.x * 15)) *
          14; // Constant multiplier for 1.2 * pi
      final double xPos = (p.x * halfWidth + sway) % halfWidth;

      // Subtle twinkle
      final double twinkle =
          0.75 +
          0.25 *
              math.sin(
                progress * p.twinkleFreq * 6.28 + p.x,
              ); // Constant for 2 * pi

      _paint.color = color.withOpacity(
        (p.baseOpacity * twinkle).clamp(0.0, 1.0),
      );

      canvas.drawCircle(Offset(xPos, yPos), p.size, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant RoyalParticlePainter oldDelegate) {
    // Only repaint if time has actually moved
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class _DignifiedParticle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double baseOpacity;
  final double twinkleFreq;

  _DignifiedParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.baseOpacity,
    required this.twinkleFreq,
  });
}
