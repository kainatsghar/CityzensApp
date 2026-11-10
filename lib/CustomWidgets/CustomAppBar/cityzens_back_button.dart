import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';

/// Cityzens 2.0 Circular Back Button matching SVG `#ci-back`:
/// - Light-blue circular background (#9DBFEA)
/// - Dark navy left arrow (#194F90)
class CityzensBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  const CityzensBackButton({
    super.key,
    this.onTap,
    this.size = 40.0,
    this.backgroundColor = const Color(0xFF9DBFEA),
    this.iconColor = AppColors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Back',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () => Navigator.of(context).maybePop(),
          borderRadius: BorderRadius.circular(size / 2),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: CustomPaint(
              size: Size(size, size),
              painter: _CityzensBackPainter(color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}

class _CityzensBackPainter extends CustomPainter {
  final Color color;

  _CityzensBackPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 48.0;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.2 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // SVG: M33 24H16m6.5-7.5L15 24l7.5 7.5
    final shaft = Path()
      ..moveTo(33 * s, 24 * s)
      ..lineTo(16 * s, 24 * s);
    canvas.drawPath(shaft, paint);

    final head = Path()
      ..moveTo(22.5 * s, 16.5 * s)
      ..lineTo(15 * s, 24 * s)
      ..lineTo(22.5 * s, 31.5 * s);
    canvas.drawPath(head, paint);
  }

  @override
  bool shouldRepaint(covariant _CityzensBackPainter oldDelegate) =>
      oldDelegate.color != color;
}

