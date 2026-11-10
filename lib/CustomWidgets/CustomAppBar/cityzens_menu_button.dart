import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';

/// Cityzens 2.0 3-Line Circular Hamburger Menu Button
/// Matches SVG symbol `#ci-menu` from design mockup and screenshot:
/// - Light-blue circular button (#9DBFEA)
/// - 3 rounded horizontal navy bars (#194F90):
///   - Top bar: wide
///   - Middle bar: wide
///   - Bottom bar: short (~65% width, left-aligned)
class CityzensMenuButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double size;
  final Color backgroundColor;
  final Color iconColor;

  const CityzensMenuButton({
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
      label: 'Open menu',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
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
              painter: _CityzensMenuPainter(color: iconColor),
            ),
          ),
        ),
      ),
    );
  }
}

class _CityzensMenuPainter extends CustomPainter {
  final Color color;

  _CityzensMenuPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // ViewBox is 48x48:
    // rect x="14" y="15.5" width="20" height="4" rx="2"
    // rect x="14" y="22.0" width="20" height="4" rx="2"
    // rect x="14" y="28.5" width="13" height="4" rx="2"
    final scale = size.width / 48.0;

    void drawBar(double x, double y, double width, double height, double r) {
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x * scale, y * scale, width * scale, height * scale),
        Radius.circular(r * scale),
      );
      canvas.drawRRect(rrect, paint);
    }

    drawBar(14.0, 15.5, 20.0, 4.0, 2.0);
    drawBar(14.0, 22.0, 20.0, 4.0, 2.0);
    drawBar(14.0, 28.5, 13.0, 4.0, 2.0);
  }

  @override
  bool shouldRepaint(covariant _CityzensMenuPainter oldDelegate) =>
      oldDelegate.color != color;
}

