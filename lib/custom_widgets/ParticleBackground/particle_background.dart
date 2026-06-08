import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A lightweight, compositor-driven particle background for selective use.
///
/// Optimized for screens like Splash, About Us, and Profile pages where the
/// UI is relatively static. Uses [Transform.translate] which is composited
/// on the GPU thread — the particle [Container] circles are rasterized once
/// and only their position changes, costing near-zero GPU time.
///
/// **Not recommended for heavy screens like dashboards.**
class ParticleBackground extends StatefulWidget {
  final Animation<double> animation;
  final Color particleColor;

  const ParticleBackground({
    super.key,
    required this.animation,
    required this.particleColor,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground> {
  // Pre-generated particle configs — created once, never reallocated
  static const int _particleCount = 50;
  late final List<_ParticleConfig> _particles;

  @override
  void initState() {
    super.initState();
    final r = math.Random(2024);
    _particles = List.generate(_particleCount, (i) {
      // 3 size tiers for visual depth
      final tier = i % 3;
      return _ParticleConfig(
        fx: r.nextDouble(),
        fy: r.nextDouble(),
        size: tier == 0
            ? 5.0 +
                  r.nextDouble() *
                      3.0 // Large: 5-8
            : tier == 1
            ? 2.5 +
                  r.nextDouble() *
                      2.0 // Medium: 2.5-4.5
            : 1.0 + r.nextDouble() * 1.5, // Small: 1-2.5
        opacity:
            (tier == 0
                    ? 0.15
                    : tier == 1
                    ? 0.10
                    : 0.06)
                .clamp(0.0, 1.0),
        swayAmp: 8.0 + r.nextDouble() * 20.0,
        swayFreq: 0.3 + r.nextDouble() * 0.8,
        drift: 0.02 + r.nextDouble() * 0.05,
        phase: r.nextDouble() * math.pi * 2,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return RepaintBoundary(
          child: AnimatedBuilder(
            animation: widget.animation,
            builder: (context, _) {
              final t = widget.animation.value;
              const double twoPi = 6.283185307179586;

              return Stack(
                clipBehavior: Clip.hardEdge,
                children: List.generate(_particleCount, (i) {
                  final p = _particles[i];
                  final baseX = p.fx * w;
                  final baseY = p.fy * h;
                  final color = widget.particleColor.withValues(alpha: p.opacity);

                  final x =
                      baseX +
                      math.sin(t * p.swayFreq * twoPi + p.phase) * p.swayAmp;
                  final y = (baseY + t * h * p.drift) % h;

                  return Transform.translate(
                    offset: Offset(x, y),
                    child: SizedBox(
                      width: p.size,
                      height: p.size,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        );
      },
    );
  }
}

class _ParticleConfig {
  final double fx, fy, size, opacity, swayAmp, swayFreq, drift, phase;
  const _ParticleConfig({
    required this.fx,
    required this.fy,
    required this.size,
    required this.opacity,
    required this.swayAmp,
    required this.swayFreq,
    required this.drift,
    required this.phase,
  });
}
