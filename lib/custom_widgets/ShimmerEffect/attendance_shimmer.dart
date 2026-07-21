import 'package:flutter/material.dart';
import 'package:tcs_app/utils/app_colors.dart';

class AttendanceShimmer extends StatefulWidget {
  const AttendanceShimmer({super.key});

  @override
  State<AttendanceShimmer> createState() => _AttendanceShimmerState();
}

class _AttendanceShimmerState extends State<AttendanceShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(
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
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          // Subjects horizontal list shimmer
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, index) => _ShimmerPlaceholder(
                animation: _animation,
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Monthly Summary Shimmer
          _ShimmerPlaceholder(
            animation: _animation,
            child: Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Calendar Shimmer
          _ShimmerPlaceholder(
            animation: _animation,
            child: Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerPlaceholder extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const _ShimmerPlaceholder({required this.animation, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.borderGrey.withValues(alpha: 0.3),
                AppColors.primaryLightBlue.withValues(alpha: 0.4),
                AppColors.white.withValues(alpha: 0.6),
                AppColors.primaryLightBlue.withValues(alpha: 0.4),
                AppColors.borderGrey.withValues(alpha: 0.3),
              ],
              stops: [
                0.0,
                (animation.value - 0.5).clamp(0.0, 1.0),
                animation.value.clamp(0.0, 1.0),
                (animation.value + 0.5).clamp(0.0, 1.0),
                1.0,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}
