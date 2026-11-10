import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';

enum CityzensIconType {
  event,
  chevronRight,
  homework,
  timetable,
  classwork,
  user,
  attendance,
  results,
  tests,
  fees,
  circulars,
  library,
  eyeChild,
  info,
  feedback,
  lock,
  logout,
  camera,
  classIcon,
  phone,
  search,
  plus,
  switchArrows,
}

/// Custom vector icon widget rendering Cityzens 2.0 two-tone SVG symbols
/// directly via CustomPaint matching the design mockup viewBox (0 0 48 48).
class CityzensIcon extends StatelessWidget {
  final CityzensIconType type;
  final double size;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;

  const CityzensIcon({
    super.key,
    required this.type,
    this.size = 28.0,
    this.primaryColor = AppColors.blue,
    this.secondaryColor = AppColors.yellow,
    this.accentColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CityzensIconPainter(
        type: type,
        ci1: primaryColor,
        ci2: secondaryColor,
        ci3: accentColor,
      ),
    );
  }
}

class _CityzensIconPainter extends CustomPainter {
  final CityzensIconType type;
  final Color ci1;
  final Color ci2;
  final Color ci3;

  _CityzensIconPainter({
    required this.type,
    required this.ci1,
    required this.ci2,
    required this.ci3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 48.0;

    switch (type) {
      case CityzensIconType.event:
        _paintEvent(canvas, s);
        break;
      case CityzensIconType.chevronRight:
        _paintChevronRight(canvas, s);
        break;
      case CityzensIconType.homework:
        _paintHomework(canvas, s);
        break;
      case CityzensIconType.timetable:
        _paintTimetable(canvas, s);
        break;
      case CityzensIconType.classwork:
        _paintClasswork(canvas, s);
        break;
      case CityzensIconType.user:
        _paintUser(canvas, s);
        break;
      case CityzensIconType.attendance:
        _paintAttendance(canvas, s);
        break;
      case CityzensIconType.results:
        _paintResults(canvas, s);
        break;
      case CityzensIconType.tests:
        _paintTests(canvas, s);
        break;
      case CityzensIconType.fees:
        _paintFees(canvas, s);
        break;
      case CityzensIconType.circulars:
        _paintCirculars(canvas, s);
        break;
      case CityzensIconType.library:
        _paintLibrary(canvas, s);
        break;
      case CityzensIconType.eyeChild:
        _paintEyeChild(canvas, s);
        break;
      case CityzensIconType.info:
        _paintInfo(canvas, s);
        break;
      case CityzensIconType.feedback:
        _paintFeedback(canvas, s);
        break;
      case CityzensIconType.lock:
        _paintLock(canvas, s);
        break;
      case CityzensIconType.logout:
        _paintLogout(canvas, s);
        break;
      case CityzensIconType.camera:
        _paintCamera(canvas, s);
        break;
      case CityzensIconType.classIcon:
        _paintClassIcon(canvas, s);
        break;
      case CityzensIconType.phone:
        _paintPhone(canvas, s);
        break;
      case CityzensIconType.search:
        _paintSearch(canvas, s);
        break;
      case CityzensIconType.plus:
        _paintPlus(canvas, s);
        break;
      case CityzensIconType.switchArrows:
        _paintSwitchArrows(canvas, s);
        break;
    }
  }

  void _drawStar(Canvas canvas, double s, double cx, double cy, double outerR,
      double innerR, Color color) {
    final path = Path();
    for (int i = 0; i < 10; i++) {
      final angle = -math.pi / 2 + (i * math.pi / 5);
      final r = (i % 2 == 0) ? outerR : innerR;
      final x = (cx + r * math.cos(angle)) * s;
      final y = (cy + r * math.sin(angle)) * s;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.fill);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6 * s
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _paintEvent(Canvas canvas, double s) {
    final p1 = Paint()..color = ci1;
    final p2 = Paint()..color = ci2;
    final p3 = Paint()..color = ci3.withValues(alpha: 0.9);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(6 * s, 9 * s, 36 * s, 34 * s), Radius.circular(6 * s)),
      p1,
    );
    canvas.drawRect(Rect.fromLTWH(6 * s, 17 * s, 36 * s, 2.4 * s), p3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(13.5 * s, 4.5 * s, 5 * s, 9.5 * s),
          Radius.circular(2.5 * s)),
      p2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(29.5 * s, 4.5 * s, 5 * s, 9.5 * s),
          Radius.circular(2.5 * s)),
      p2,
    );
    _drawStar(canvas, s, 24.0, 30.8, 8.6, 4.0, ci2);
  }

  void _paintChevronRight(Canvas canvas, double s) {
    canvas.drawCircle(
      Offset(24 * s, 24 * s),
      20 * s,
      Paint()..color = ci2,
    );
    final path = Path()
      ..moveTo(21 * s, 15.5 * s)
      ..lineTo(29.5 * s, 24 * s)
      ..lineTo(21 * s, 32.5 * s);
    canvas.drawPath(
      path,
      Paint()
        ..color = ci1
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.4 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _paintHomework(Canvas canvas, double s) {
    // Bottom bookmark fold (ci2 = yellow)
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        9.75 * s,
        34.5 * s,
        39 * s,
        43 * s,
        topLeft: Radius.circular(4.25 * s),
        bottomLeft: Radius.circular(4.25 * s),
      ),
      Paint()..color = ci2,
    );

    // Book main page (ci1 = white)
    final page = Path()
      ..moveTo(14 * s, 4.5 * s)
      ..lineTo(35 * s, 4.5 * s)
      ..arcToPoint(Offset(39 * s, 8.5 * s),
          radius: Radius.circular(4 * s), clockwise: true)
      ..lineTo(39 * s, 35 * s)
      ..lineTo(14 * s, 35 * s)
      ..arcToPoint(Offset(9 * s, 40 * s),
          radius: Radius.circular(5 * s), clockwise: false)
      ..lineTo(9 * s, 9.5 * s)
      ..arcToPoint(Offset(14 * s, 4.5 * s),
          radius: Radius.circular(5 * s), clockwise: true)
      ..close();
    canvas.drawPath(page, Paint()..color = ci1);

    // Inner lines (ci3 = navy blue)
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(17 * s, 12 * s, 15 * s, 4.2 * s),
          Radius.circular(2.1 * s)),
      Paint()..color = ci3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(17 * s, 19.5 * s, 9 * s, 3.2 * s),
          Radius.circular(1.6 * s)),
      Paint()..color = ci3.withValues(alpha: 0.55),
    );
  }

  void _paintTimetable(Canvas canvas, double s) {
    canvas.drawCircle(Offset(24 * s, 24 * s), 20 * s, Paint()..color = ci1);

    final tickPaint = Paint()..color = ci3.withValues(alpha: 0.65);
    canvas.drawCircle(Offset(24 * s, 9.5 * s), 1.6 * s, tickPaint);
    canvas.drawCircle(Offset(38.5 * s, 24 * s), 1.6 * s, tickPaint);
    canvas.drawCircle(Offset(24 * s, 38.5 * s), 1.6 * s, tickPaint);
    canvas.drawCircle(Offset(9.5 * s, 24 * s), 1.6 * s, tickPaint);

    final handPath = Path()
      ..moveTo(24 * s, 14.5 * s)
      ..lineTo(24 * s, 24 * s)
      ..lineTo(31 * s, 29 * s);
    canvas.drawPath(
      handPath,
      Paint()
        ..color = ci2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.2 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.drawCircle(Offset(24 * s, 24 * s), 3 * s, Paint()..color = ci3);
  }

  void _paintClasswork(Canvas canvas, double s) {
    // Pad body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(4 * s, 5 * s, 27 * s, 38 * s), Radius.circular(5 * s)),
      Paint()..color = ci1,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(10.5 * s, 13 * s, 14 * s, 3.4 * s),
          Radius.circular(1.7 * s)),
      Paint()..color = ci3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(10.5 * s, 20 * s, 10 * s, 3.4 * s),
          Radius.circular(1.7 * s)),
      Paint()..color = ci3.withValues(alpha: 0.55),
    );

    // Rotated pencil
    canvas.save();
    canvas.translate(34.25 * s, 23 * s);
    canvas.rotate(25 * math.pi / 180);
    canvas.translate(-34.25 * s, -23 * s);

    // Eraser
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(29 * s, 5.5 * s, 10.5 * s, 6.5 * s),
          Radius.circular(3 * s)),
      Paint()..color = ci1,
    );
    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(29 * s, 13 * s, 10.5 * s, 17.5 * s),
          Radius.circular(1.2 * s)),
      Paint()..color = ci2,
    );
    // Cone
    final cone = Path()
      ..moveTo(29 * s, 30.5 * s)
      ..lineTo(39.5 * s, 30.5 * s)
      ..lineTo(34.7 * s, 40.1 * s)
      ..quadraticBezierTo(34.25 * s, 40.8 * s, 33.8 * s, 40.1 * s)
      ..close();
    canvas.drawPath(cone, Paint()..color = ci2);

    // Tip
    final tip = Path()
      ..moveTo(32.6 * s, 36.6 * s)
      ..lineTo(35.9 * s, 36.6 * s)
      ..lineTo(34.5 * s, 39.6 * s)
      ..lineTo(34.0 * s, 39.6 * s)
      ..close();
    canvas.drawPath(tip, Paint()..color = ci1);

    // Stripe
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(31.2 * s, 15 * s, 2.6 * s, 13 * s),
          Radius.circular(1.3 * s)),
      Paint()..color = ci3.withValues(alpha: 0.6),
    );

    canvas.restore();
  }

  void _paintUser(Canvas canvas, double s) {
    final outerCircle =
        Path()..addOval(Rect.fromCircle(center: Offset(24 * s, 24 * s), radius: 20 * s));

    canvas.drawPath(outerCircle, Paint()..color = ci1);

    canvas.save();
    canvas.clipPath(outerCircle);

    // Head
    canvas.drawCircle(
        Offset(24 * s, 18.5 * s), 7.5 * s, Paint()..color = ci2);

    // Shoulders
    final shoulders = Path()
      ..moveTo(10.6 * s, 38.9 * s)
      ..cubicTo(12.6 * s, 32 * s, 17.6 * s, 28.4 * s, 24 * s, 28.4 * s)
      ..cubicTo(30.4 * s, 28.4 * s, 35.4 * s, 32 * s, 37.4 * s, 38.9 * s)
      ..lineTo(37.4 * s, 45 * s)
      ..lineTo(10.6 * s, 45 * s)
      ..close();
    canvas.drawPath(shoulders, Paint()..color = ci2);

    canvas.restore();
  }

  void _paintAttendance(Canvas canvas, double s) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(6 * s, 9 * s, 36 * s, 34 * s), Radius.circular(6 * s)),
      Paint()..color = ci1,
    );
    canvas.drawRect(Rect.fromLTWH(6 * s, 17 * s, 36 * s, 2.4 * s),
        Paint()..color = ci3.withValues(alpha: 0.9));
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(13.5 * s, 4.5 * s, 5 * s, 9.5 * s),
          Radius.circular(2.5 * s)),
      Paint()..color = ci2,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(29.5 * s, 4.5 * s, 5 * s, 9.5 * s),
          Radius.circular(2.5 * s)),
      Paint()..color = ci2,
    );

    final check = Path()
      ..moveTo(16 * s, 30.5 * s)
      ..lineTo(21.5 * s, 36 * s)
      ..lineTo(32.5 * s, 25 * s);
    canvas.drawPath(
      check,
      Paint()
        ..color = ci2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.4 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _paintResults(Canvas canvas, double s) {
    final leftRibbon = Path()
      ..moveTo(10 * s, 3.5 * s)
      ..lineTo(20 * s, 3.5 * s)
      ..lineTo(27 * s, 18 * s)
      ..lineTo(17 * s, 18 * s)
      ..close();
    final rightRibbon = Path()
      ..moveTo(38 * s, 3.5 * s)
      ..lineTo(28 * s, 3.5 * s)
      ..lineTo(21 * s, 18 * s)
      ..lineTo(31 * s, 18 * s)
      ..close();

    canvas.drawPath(leftRibbon, Paint()..color = ci2);
    canvas.drawPath(rightRibbon, Paint()..color = ci2);
    canvas.drawCircle(Offset(24 * s, 30 * s), 14 * s, Paint()..color = ci1);
    _drawStar(canvas, s, 24.0, 30.2, 7.2, 3.3, ci3);
  }

  void _paintTests(Canvas canvas, double s) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(8 * s, 8 * s, 32 * s, 36 * s), Radius.circular(5 * s)),
      Paint()..color = ci1,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(16 * s, 4 * s, 16 * s, 9 * s),
          Radius.circular(3.5 * s)),
      Paint()..color = ci2,
    );

    final check = Path()
      ..moveTo(16 * s, 28 * s)
      ..lineTo(21.2 * s, 33.2 * s)
      ..lineTo(32 * s, 22.5 * s);
    canvas.drawPath(
      check,
      Paint()
        ..color = ci2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.4 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _paintFees(Canvas canvas, double s) {
    canvas.save();
    canvas.translate(22 * s, 12 * s);
    canvas.rotate(-8 * math.pi / 180);
    canvas.translate(-22 * s, -12 * s);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(10 * s, 5 * s, 24 * s, 15 * s),
          Radius.circular(3 * s)),
      Paint()..color = ci2,
    );
    canvas.restore();

    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(4 * s, 13 * s, 40 * s, 30 * s), Radius.circular(6.5 * s)),
      Paint()..color = ci1,
    );

    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        25 * s,
        22 * s,
        44 * s,
        34 * s,
        topLeft: Radius.circular(6 * s),
        bottomLeft: Radius.circular(6 * s),
      ),
      Paint()..color = ci2,
    );

    canvas.drawCircle(Offset(31.5 * s, 28 * s), 2.4 * s, Paint()..color = ci1);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(9 * s, 18 * s, 12 * s, 3 * s), Radius.circular(1.5 * s)),
      Paint()..color = ci3.withValues(alpha: 0.55),
    );
  }

  void _paintCirculars(Canvas canvas, double s) {
    // Handle
    final handle = Path()
      ..moveTo(10.5 * s, 30.5 * s)
      ..lineTo(17.5 * s, 30.5 * s)
      ..lineTo(19.1 * s, 40.1 * s)
      ..arcToPoint(Offset(16.6 * s, 43 * s),
          radius: Radius.circular(2.5 * s), clockwise: true)
      ..lineTo(14.8 * s, 43 * s)
      ..arcToPoint(Offset(12.3 * s, 40.9 * s),
          radius: Radius.circular(2.5 * s), clockwise: true)
      ..close();
    canvas.drawPath(handle, Paint()..color = ci1);

    // Cone
    final cone = Path()
      ..moveTo(16 * s, 17.5 * s)
      ..lineTo(33.3 * s, 9 * s)
      ..quadraticBezierTo(37 * s, 7.6 * s, 37 * s, 11.2 * s)
      ..lineTo(37 * s, 36.8 * s)
      ..quadraticBezierTo(37 * s, 40.4 * s, 33.3 * s, 39 * s)
      ..lineTo(16 * s, 30.5 * s)
      ..close();
    canvas.drawPath(cone, Paint()..color = ci1);

    // Back cap
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        4.5 * s,
        17.5 * s,
        17.5 * s,
        30.5 * s,
        topLeft: Radius.circular(4.5 * s),
        bottomLeft: Radius.circular(4.5 * s),
      ),
      Paint()..color = ci2,
    );

    // Sound wave arc
    final wave = Path()
      ..moveTo(41.5 * s, 19.5 * s)
      ..quadraticBezierTo(44.2 * s, 24 * s, 41.5 * s, 28.5 * s);
    canvas.drawPath(
      wave,
      Paint()
        ..color = ci2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.6 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _paintLibrary(Canvas canvas, double s) {
    // Left book
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(5 * s, 10 * s, 10 * s, 33 * s),
          Radius.circular(2.6 * s)),
      Paint()..color = ci1,
    );
    canvas.drawRect(Rect.fromLTWH(5 * s, 16 * s, 10 * s, 2.4 * s), Paint()..color = ci3);
    canvas.drawRect(Rect.fromLTWH(5 * s, 35 * s, 10 * s, 2.4 * s), Paint()..color = ci3);

    // Middle book
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(17 * s, 5 * s, 10 * s, 38 * s),
          Radius.circular(2.6 * s)),
      Paint()..color = ci2,
    );
    canvas.drawRect(Rect.fromLTWH(17 * s, 11 * s, 10 * s, 2.4 * s), Paint()..color = ci3);
    canvas.drawRect(Rect.fromLTWH(17 * s, 35 * s, 10 * s, 2.4 * s), Paint()..color = ci3);

    // Tilted right book
    canvas.save();
    canvas.translate(41 * s, 43 * s);
    canvas.rotate(14 * math.pi / 180);
    canvas.translate(-41 * s, -43 * s);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(31 * s, 9 * s, 10 * s, 34 * s),
          Radius.circular(2.6 * s)),
      Paint()..color = ci1,
    );
    canvas.drawRect(Rect.fromLTWH(31 * s, 15 * s, 10 * s, 2.4 * s), Paint()..color = ci3);
    canvas.restore();
  }

  void _paintEyeChild(Canvas canvas, double s) {
    final shield = Path()
      ..moveTo(22.2 * s, 4.6 * s)
      ..quadraticBezierTo(24 * s, 3.8 * s, 25.8 * s, 4.6 * s)
      ..lineTo(38.2 * s, 9.3 * s)
      ..quadraticBezierTo(41 * s, 10.5 * s, 41 * s, 13.5 * s)
      ..lineTo(41 * s, 22 * s)
      ..cubicTo(41 * s, 32 * s, 34.3 * s, 39.9 * s, 25.4 * s, 43.2 * s)
      ..quadraticBezierTo(24 * s, 43.8 * s, 22.6 * s, 43.2 * s)
      ..cubicTo(13.7 * s, 39.9 * s, 7 * s, 32 * s, 7 * s, 22 * s)
      ..lineTo(7 * s, 13.5 * s)
      ..quadraticBezierTo(7 * s, 10.5 * s, 9.8 * s, 9.3 * s)
      ..close();
    canvas.drawPath(shield, Paint()..color = ci1);

    final eye = Path()
      ..moveTo(12.5 * s, 23 * s)
      ..cubicTo(15.4 * s, 18.4 * s, 19.3 * s, 16 * s, 24 * s, 16 * s)
      ..cubicTo(28.7 * s, 16 * s, 32.6 * s, 18.4 * s, 35.5 * s, 23 * s)
      ..cubicTo(32.6 * s, 27.6 * s, 28.7 * s, 30 * s, 24 * s, 30 * s)
      ..cubicTo(19.3 * s, 30 * s, 15.4 * s, 27.6 * s, 12.5 * s, 23 * s)
      ..close();
    canvas.drawPath(eye, Paint()..color = ci2);

    canvas.drawCircle(Offset(24 * s, 23 * s), 4.6 * s, Paint()..color = ci1);
    canvas.drawCircle(Offset(25.6 * s, 21.4 * s), 1.5 * s, Paint()..color = ci3);
  }

  void _paintInfo(Canvas canvas, double s) {
    canvas.drawCircle(Offset(24 * s, 24 * s), 20 * s, Paint()..color = ci1);
    canvas.drawCircle(Offset(24 * s, 14.5 * s), 3 * s, Paint()..color = ci2);
    canvas.drawLine(
      Offset(24 * s, 22 * s),
      Offset(24 * s, 34 * s),
      Paint()
        ..color = ci2
        ..strokeWidth = 5.4 * s
        ..strokeCap = StrokeCap.round,
    );
  }

  void _paintFeedback(Canvas canvas, double s) {
    final bubble = Path()
      ..moveTo(9 * s, 5 * s)
      ..lineTo(39 * s, 5 * s)
      ..arcToPoint(Offset(44 * s, 10 * s),
          radius: Radius.circular(5 * s), clockwise: true)
      ..lineTo(44 * s, 30 * s)
      ..arcToPoint(Offset(39 * s, 35 * s),
          radius: Radius.circular(5 * s), clockwise: true)
      ..lineTo(22.5 * s, 35 * s)
      ..lineTo(14.1 * s, 42.2 * s)
      ..quadraticBezierTo(11.7 * s, 43.8 * s, 11.7 * s, 41.1 * s)
      ..lineTo(11.7 * s, 35 * s)
      ..lineTo(9 * s, 35 * s)
      ..arcToPoint(Offset(4 * s, 30 * s),
          radius: Radius.circular(5 * s), clockwise: true)
      ..lineTo(4 * s, 10 * s)
      ..arcToPoint(Offset(9 * s, 5 * s),
          radius: Radius.circular(5 * s), clockwise: true)
      ..close();
    canvas.drawPath(bubble, Paint()..color = ci1);
    _drawStar(canvas, s, 24.0, 20.5, 8.8, 4.0, ci2);
  }

  void _paintLock(Canvas canvas, double s) {
    final shackle = Path()
      ..moveTo(15 * s, 21 * s)
      ..lineTo(15 * s, 16 * s)
      ..arcToPoint(Offset(33 * s, 16 * s),
          radius: Radius.circular(9 * s), clockwise: true)
      ..lineTo(33 * s, 21 * s);
    canvas.drawPath(
      shackle,
      Paint()
        ..color = ci1
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(7 * s, 19 * s, 34 * s, 25 * s), Radius.circular(6 * s)),
      Paint()..color = ci1,
    );
    canvas.drawCircle(Offset(24 * s, 29.5 * s), 4.2 * s, Paint()..color = ci2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(22 * s, 30 * s, 4 * s, 8 * s), Radius.circular(2 * s)),
      Paint()..color = ci2,
    );
  }

  void _paintLogout(Canvas canvas, double s) {
    final door = Path()
      ..moveTo(10 * s, 4 * s)
      ..lineTo(25 * s, 4 * s)
      ..arcToPoint(Offset(30 * s, 9 * s),
          radius: Radius.circular(5 * s), clockwise: true)
      ..lineTo(30 * s, 39 * s)
      ..arcToPoint(Offset(25 * s, 44 * s),
          radius: Radius.circular(5 * s), clockwise: true)
      ..lineTo(10 * s, 44 * s)
      ..arcToPoint(Offset(5 * s, 39 * s),
          radius: Radius.circular(5 * s), clockwise: true)
      ..lineTo(5 * s, 9 * s)
      ..arcToPoint(Offset(10 * s, 4 * s),
          radius: Radius.circular(5 * s), clockwise: true)
      ..close();
    canvas.drawPath(door, Paint()..color = ci1);

    canvas.drawCircle(Offset(11.5 * s, 24 * s), 2.1 * s, Paint()..color = ci3);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(17 * s, 21 * s, 17 * s, 6 * s), Radius.circular(3 * s)),
      Paint()..color = ci2,
    );

    final arrowHead = Path()
      ..moveTo(32 * s, 14.8 * s)
      ..quadraticBezierTo(32 * s, 12.8 * s, 35.1 * s, 13.4 * s)
      ..lineTo(43.5 * s, 21.6 * s)
      ..quadraticBezierTo(45.5 * s, 24 * s, 43.5 * s, 26.4 * s)
      ..lineTo(35.1 * s, 34.6 * s)
      ..quadraticBezierTo(32 * s, 35.2 * s, 32 * s, 33.2 * s)
      ..close();
    canvas.drawPath(arrowHead, Paint()..color = ci2);
  }

  void _paintCamera(Canvas canvas, double s) {
    final top = Path()
      ..moveTo(17.2 * s, 8.6 * s)
      ..quadraticBezierTo(18.5 * s, 6.5 * s, 20.3 * s, 6.5 * s)
      ..lineTo(27.7 * s, 6.5 * s)
      ..quadraticBezierTo(29.5 * s, 6.5 * s, 30.8 * s, 8.6 * s)
      ..lineTo(32.4 * s, 12 * s)
      ..lineTo(15.6 * s, 12 * s)
      ..close();
    canvas.drawPath(top, Paint()..color = ci1);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(4 * s, 11 * s, 40 * s, 31 * s), Radius.circular(6.5 * s)),
      Paint()..color = ci1,
    );
    canvas.drawCircle(Offset(24 * s, 26.5 * s), 10 * s, Paint()..color = ci2);
    canvas.drawCircle(Offset(24 * s, 26.5 * s), 5.2 * s, Paint()..color = ci1);
    canvas.drawCircle(Offset(26 * s, 24.5 * s), 1.7 * s, Paint()..color = ci3);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(34.5 * s, 16 * s, 5 * s, 3 * s),
          Radius.circular(1.5 * s)),
      Paint()..color = ci3.withValues(alpha: 0.7),
    );
  }

  void _paintClassIcon(Canvas canvas, double s) {
    final pSide = Paint()..color = ci2;
    final pMain = Paint()..color = ci1;

    // Left background person
    canvas.drawCircle(Offset(11.5 * s, 17 * s), 5 * s, pSide);
    final leftBody = Path()
      ..moveTo(3 * s, 35.5 * s)
      ..cubicTo(3 * s, 29.5 * s, 6.8 * s, 25.5 * s, 11.5 * s, 25.5 * s)
      ..cubicTo(16.2 * s, 25.5 * s, 20 * s, 29.5 * s, 20 * s, 35.5 * s)
      ..arcToPoint(Offset(18 * s, 37.5 * s), radius: Radius.circular(2 * s))
      ..lineTo(5 * s, 37.5 * s)
      ..arcToPoint(Offset(3 * s, 35.5 * s), radius: Radius.circular(2 * s))
      ..close();
    canvas.drawPath(leftBody, pSide);

    // Right background person
    canvas.drawCircle(Offset(36.5 * s, 17 * s), 5 * s, pSide);
    final rightBody = Path()
      ..moveTo(28 * s, 35.5 * s)
      ..cubicTo(28 * s, 29.5 * s, 31.8 * s, 25.5 * s, 36.5 * s, 25.5 * s)
      ..cubicTo(41.2 * s, 25.5 * s, 45 * s, 29.5 * s, 45 * s, 35.5 * s)
      ..arcToPoint(Offset(43 * s, 37.5 * s), radius: Radius.circular(2 * s))
      ..lineTo(30 * s, 37.5 * s)
      ..arcToPoint(Offset(28 * s, 35.5 * s), radius: Radius.circular(2 * s))
      ..close();
    canvas.drawPath(rightBody, pSide);

    // Center foreground person
    canvas.drawCircle(Offset(24 * s, 15 * s), 7 * s, pMain);
    final centerBody = Path()
      ..moveTo(11 * s, 40.5 * s)
      ..cubicTo(11 * s, 32.5 * s, 16.8 * s, 27 * s, 24 * s, 27 * s)
      ..cubicTo(31.2 * s, 27 * s, 37 * s, 32.5 * s, 37 * s, 40.5 * s)
      ..arcToPoint(Offset(34.5 * s, 43 * s), radius: Radius.circular(2.5 * s))
      ..lineTo(13.5 * s, 43 * s)
      ..arcToPoint(Offset(11 * s, 40.5 * s), radius: Radius.circular(2.5 * s))
      ..close();
    canvas.drawPath(centerBody, pMain);
  }

  void _paintPhone(Canvas canvas, double s) {
    canvas.save();
    canvas.translate(-3 * s, 3 * s);
    canvas.translate(24 * s, 24 * s);
    canvas.rotate(-45 * math.pi / 180);
    canvas.translate(-24 * s, -24 * s);

    final handle = Path()
      ..moveTo(21 * s, 10 * s)
      ..cubicTo(11.5 * s, 14 * s, 11.5 * s, 34 * s, 21 * s, 38 * s);
    canvas.drawPath(
      handle,
      Paint()
        ..color = ci1
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9 * s
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(15 * s, 3 * s, 15 * s, 10.5 * s),
          Radius.circular(5 * s)),
      Paint()..color = ci1,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(15 * s, 34.5 * s, 15 * s, 10.5 * s),
          Radius.circular(5 * s)),
      Paint()..color = ci1,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(13.2 * s, 17 * s, 3 * s, 11 * s),
          Radius.circular(1.5 * s)),
      Paint()..color = ci3.withValues(alpha: 0.5),
    );
    canvas.restore();

    final outerArc = Path()
      ..moveTo(29 * s, 5.5 * s)
      ..arcToPoint(
        Offset(42.5 * s, 19 * s),
        radius: Radius.circular(13.5 * s),
        clockwise: true,
      );
    canvas.drawPath(
      outerArc,
      Paint()
        ..color = ci2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4 * s
        ..strokeCap = StrokeCap.round,
    );

    final innerArc = Path()
      ..moveTo(28.5 * s, 12.5 * s)
      ..arcToPoint(
        Offset(35 * s, 19 * s),
        radius: Radius.circular(6.5 * s),
        clockwise: true,
      );
    canvas.drawPath(
      innerArc,
      Paint()
        ..color = ci2
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4 * s
        ..strokeCap = StrokeCap.round,
    );
  }

  void _paintSearch(Canvas canvas, double s) {
    canvas.drawCircle(Offset(21 * s, 21 * s), 12 * s, Paint()..color = ci2);
    canvas.drawCircle(
      Offset(21 * s, 21 * s),
      13 * s,
      Paint()
        ..color = ci1
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.5 * s,
    );
    canvas.drawLine(
      Offset(31 * s, 31 * s),
      Offset(40.5 * s, 40.5 * s),
      Paint()
        ..color = ci1
        ..strokeWidth = 7 * s
        ..strokeCap = StrokeCap.round,
    );
    final glint = Path()
      ..moveTo(15 * s, 19 * s)
      ..arcToPoint(
        Offset(19 * s, 14.6 * s),
        radius: Radius.circular(6.5 * s),
        clockwise: true,
      );
    canvas.drawPath(
      glint,
      Paint()
        ..color = ci3
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.2 * s
        ..strokeCap = StrokeCap.round,
    );
  }

  void _paintPlus(Canvas canvas, double s) {
    canvas.drawCircle(Offset(24 * s, 24 * s), 20 * s, Paint()..color = ci1);
    final paint = Paint()
      ..color = ci2
      ..strokeWidth = 4.4 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(24 * s, 15 * s), Offset(24 * s, 33 * s), paint);
    canvas.drawLine(Offset(15 * s, 24 * s), Offset(33 * s, 24 * s), paint);
  }

  void _paintSwitchArrows(Canvas canvas, double s) {
    final topArrow = Path()
      ..moveTo(8 * s, 11.5 * s)
      ..lineTo(30.5 * s, 11.5 * s)
      ..lineTo(30.5 * s, 7.2 * s)
      ..quadraticBezierTo(30.5 * s, 5.2 * s, 33.4 * s, 5.9 * s)
      ..lineTo(43 * s, 14.5 * s)
      ..quadraticBezierTo(44 * s, 16 * s, 43 * s, 17.5 * s)
      ..lineTo(33.4 * s, 26.1 * s)
      ..quadraticBezierTo(30.5 * s, 26.8 * s, 30.5 * s, 24.8 * s)
      ..lineTo(30.5 * s, 18.5 * s)
      ..lineTo(8 * s, 18.5 * s)
      ..arcToPoint(
        Offset(8 * s, 11.5 * s),
        radius: Radius.circular(3.5 * s),
        clockwise: true,
      )
      ..close();
    canvas.drawPath(topArrow, Paint()..color = ci1);

    final bottomArrow = Path()
      ..moveTo(40 * s, 29.5 * s)
      ..lineTo(17.5 * s, 29.5 * s)
      ..lineTo(17.5 * s, 25.2 * s)
      ..quadraticBezierTo(17.5 * s, 23.2 * s, 14.6 * s, 23.9 * s)
      ..lineTo(5 * s, 32.5 * s)
      ..quadraticBezierTo(4 * s, 34 * s, 5 * s, 35.5 * s)
      ..lineTo(14.6 * s, 44.1 * s)
      ..quadraticBezierTo(17.5 * s, 44.8 * s, 17.5 * s, 42.8 * s)
      ..lineTo(17.5 * s, 36.5 * s)
      ..lineTo(40 * s, 36.5 * s)
      ..arcToPoint(
        Offset(40 * s, 29.5 * s),
        radius: Radius.circular(3.5 * s),
        clockwise: true,
      )
      ..close();
    canvas.drawPath(bottomArrow, Paint()..color = ci2);
  }

  @override
  bool shouldRepaint(covariant _CityzensIconPainter oldDelegate) =>
      oldDelegate.type != type ||
      oldDelegate.ci1 != ci1 ||
      oldDelegate.ci2 != ci2 ||
      oldDelegate.ci3 != ci3;
}

