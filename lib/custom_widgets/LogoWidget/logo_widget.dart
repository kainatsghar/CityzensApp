import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:tcs_app/gen/assets.gen.dart';

/// A performance-optimized school logo widget with internal animation management.
/// 
/// Refined for Performance:
/// - Uses [RepaintBoundary] to isolate rotation/scale animations from the background.
/// - Minimal widget tree depth.
class LogoWidget extends StatefulWidget {
  final double size;
  final Color glowColor;

  const LogoWidget({
    super.key,
    this.size = 220,
    this.glowColor = const Color(0xFFF3CD50),
  });

  @override
  State<LogoWidget> createState() => _LogoWidgetState();
}

class _LogoWidgetState extends State<LogoWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _rotateAnimation;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _rotateAnimation = Tween<double>(
      begin: -1.2 * (math.pi / 180), 
      end: 1.2 * (math.pi / 180),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Isolating the animation in a RepaintBoundary to prevent global repaints
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Transform.rotate(
              angle: _rotateAnimation.value,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Subtle glow
                  Container(
                    width: widget.size * 0.9,
                    height: widget.size * 0.9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.glowColor.withOpacity(_glowAnimation.value * 0.2),
                          blurRadius: 70,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  // Logo image
                  child!,
                ],
              ),
            ),
          );
        },
        child: Hero(
          tag: 'school_logo',
          child: Image.asset(
            Assets.images.tcsLogoWhite.path,
            height: widget.size,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
