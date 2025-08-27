import 'package:flutter/material.dart';

class ProgressBorderPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color backgroundColor;
  final double radius;

  ProgressBorderPainter({
    required this.progress,
    required this.primaryColor,
    required this.backgroundColor,
    this.radius = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Create the rounded rectangle path
    final roundedRectPath = Path()
      ..moveTo(width / 2, 0) // Start from top center
      ..lineTo(width - radius, 0) // Top right line
      ..arcToPoint(
        // Top right corner
        Offset(width, radius),
        radius: Radius.circular(radius),
        clockwise: true,
      )
      ..lineTo(width, height - radius) // Right line
      ..arcToPoint(
        // Bottom right corner
        Offset(width - radius, height),
        radius: Radius.circular(radius),
        clockwise: true,
      )
      ..lineTo(radius, height) // Bottom line
      ..arcToPoint(
        // Bottom left corner
        Offset(0, height - radius),
        radius: Radius.circular(radius),
        clockwise: true,
      )
      ..lineTo(0, radius) // Left line
      ..arcToPoint(
        // Top left corner
        Offset(radius, 0),
        radius: Radius.circular(radius),
        clockwise: true,
      )
      ..lineTo(width / 2, 0); // Back to top center

    // Draw background
    canvas.drawPath(
      roundedRectPath,
      Paint()
        ..color = backgroundColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );

    // Draw progress
    if (progress > 0) {
      final pathMetric = roundedRectPath.computeMetrics().first;
      final totalLength = pathMetric.length;

      final progressPath = Path();
      progressPath.addPath(
        pathMetric.extractPath(0, totalLength * progress),
        Offset.zero,
      );

      canvas.drawPath(
        progressPath,
        Paint()
          ..color = primaryColor
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(ProgressBorderPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.radius != radius;
  }
}
