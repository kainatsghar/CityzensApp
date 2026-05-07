import 'dart:math' as math;
import 'dart:ui';
import 'dart:typed_data';
import 'package:flutter/material.dart';

/// A zero-allocation, ultra-high-performance particle painter.
/// Achieves absolute minimal Raster time by avoiding all per-frame object
/// allocations (no Offsets, no Lists, no Colors) and using hardware-accelerated
/// raw point drawing (`drawRawPoints`). Features size-bucketing for visual depth.
class RoyalParticlePainter extends CustomPainter {
  final double progress;
  final Color color;
  final int layer;

  // Cache complex layer data so nothing is allocated during painting.
  static final Map<int, _LayerData> _layerCacheV2 = {};

  RoyalParticlePainter({
    required this.progress,
    required this.color,
    required this.layer,
  }) {
    if (!_layerCacheV2.containsKey(layer)) {
      _layerCacheV2[layer] = _generateLayerData(layer, color);
    }
  }

  static _LayerData _generateLayerData(int layer, Color baseColor) {
    final random = math.Random(1978 + layer);

    // Increased counts for rich visibility since drawing is virtually free now
    final int totalCount = layer == 1 ? 35 : 65;
    final double baseOpacity = layer == 1 ? 0.25 : 0.12;

    // Define size buckets to allow size variation without breaking batching
    final List<double> sizes = layer == 1
        ? [2.0, 3.5, 5.0, 7.0]
        : [1.0, 1.8, 2.5, 3.5];

    final List<_SizeBucket> buckets = [];

    for (final size in sizes) {
      // Distribute particles across buckets
      final int bucketCount = (totalCount / sizes.length).ceil();
      final particles = List.generate(
        bucketCount,
        (_) => _DignifiedParticle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          speed: layer == 1
              ? 0.015 + random.nextDouble() * 0.02
              : 0.03 + random.nextDouble() * 0.04,
          swayOffset: random.nextDouble() * 100.0,
          swaySpeed: 1.5 + random.nextDouble() * 2.0,
        ),
      );

      final positions = Float32List(bucketCount * 2);

      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = baseColor.withOpacity(baseOpacity)
        ..isAntiAlias = true
        ..strokeCap = StrokeCap.round
        ..strokeWidth = size;

      buckets.add(_SizeBucket(particles, positions, paint));
    }

    return _LayerData(buckets);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final layerData = _layerCacheV2[layer];
    if (layerData == null) return;

    final double h = size.height;
    final double w = size.width;

    // Process each size bucket
    for (final bucket in layerData.buckets) {
      final particles = bucket.particles;
      final positions = bucket.positions;

      // Zero-allocation coordinate updates
      for (int i = 0; i < particles.length; i++) {
        final p = particles[i];
        final int pIndex = i * 2;

        final double sway =
            math.sin(progress * p.swaySpeed + p.swayOffset) * 15.0;

        positions[pIndex] = (p.x * w + sway) % w;
        positions[pIndex + 1] = (p.y * h + (progress * h * p.speed)) % h;
      }

      // Hardware-accelerated batched draw call per size bucket
      canvas.drawRawPoints(PointMode.points, positions, bucket.paint);
    }
  }

  @override
  bool shouldRepaint(covariant RoyalParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _LayerData {
  final List<_SizeBucket> buckets;
  _LayerData(this.buckets);
}

class _SizeBucket {
  final List<_DignifiedParticle> particles;
  final Float32List positions;
  final Paint paint;

  _SizeBucket(this.particles, this.positions, this.paint);
}

class _DignifiedParticle {
  final double x, y, speed, swayOffset, swaySpeed;
  _DignifiedParticle({
    required this.x,
    required this.y,
    required this.speed,
    required this.swayOffset,
    required this.swaySpeed,
  });
}
