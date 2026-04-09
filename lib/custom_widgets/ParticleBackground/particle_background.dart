import 'package:flutter/material.dart';
import '../RoyalParticlePainter/royal_particle_painter.dart';

/// A reusable background widget that displays a dual-layer royal particle system.
///
/// This widget handles the isolation of painting via [RepaintBoundary] to ensure
/// the particle animations always run at a buttery-smooth 60 FPS without
/// affecting the main UI performance.
class ParticleBackground extends StatelessWidget {
  /// The current animation progress (0.0 to 1.0)
  final Animation<double> animation;

  /// The base color of the particles (usually a gold or ivory tone)
  final Color particleColor;

  const ParticleBackground({
    super.key,
    required this.animation,
    required this.particleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Layer 1: Foreground, larger, and more prominent dust motes
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, _) => CustomPaint(
                painter: RoyalParticlePainter(
                  progress: animation.value,
                  color: particleColor,
                  layer: 1,
                ),
              ),
            ),
          ),
        ),
        // Layer 2: Background, smaller, and more atmospheric motes
        Positioned.fill(
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, _) => CustomPaint(
                painter: RoyalParticlePainter(
                  progress: animation.value,
                  color: particleColor.withOpacity(0.5),
                  layer: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
