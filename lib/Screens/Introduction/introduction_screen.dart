import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:video_player/video_player.dart';

import '../../CustomWidgets/CustomAppBar/custom_app_bar.dart';
import '../../Routes/app_navigation.dart';
import '../../Routes/app_navigation_routes.dart';

class IntroductionScreenPage extends StatefulWidget {
  const IntroductionScreenPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IntroductionScreenPageState createState() => _IntroductionScreenPageState();
}

class _IntroductionScreenPageState extends State<IntroductionScreenPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset(
      'images/FEATURE_Citizans_App2.mp4',
    );

    try {
      await _controller.initialize();
      _controller.addListener(_onVideoProgress);
      _controller.setLooping(false);
      if (mounted) {
        setState(() {});
        _controller.play();
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
    }
  }

  void _onVideoProgress() {
    if (_controller.value.isCompleted && mounted) {
      Future.delayed(
        const Duration(milliseconds: 100),
        () => AppNavigation.pushReplacementTo(AppNavRoutes.registrationRoute),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      floatingActionButton: StreamBuilder<Duration>(
        stream: Stream.periodic(
          const Duration(milliseconds: 16), // ~60fps for smooth animation
        ).map((_) => _controller.value.position),
        builder: (context, snapshot) {
          final position = snapshot.data ?? Duration.zero;
          final duration = _controller.value.duration;
          final progress = duration.inMilliseconds > 0
              ? position.inMilliseconds / duration.inMilliseconds
              : 0.0;

          return Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: CustomPaint(
              painter: ProgressBorderPainter(
                progress: progress,
                primaryColor: AppColors.secondaryColor,
                radius: 20,
                backgroundColor: AppColors.whiteColor.withValues(alpha: 0.3),
              ),
              child: Container(
                margin: const EdgeInsets.all(2), // Space for the border
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blackColor.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      AppNavigation.pushReplacementTo(
                        AppNavRoutes.registrationRoute,
                      );
                    },
                    child: const Center(
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      body: SafeArea(child: VideoPlayer(_controller)),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

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
