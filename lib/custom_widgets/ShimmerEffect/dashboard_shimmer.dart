import 'package:flutter/material.dart';
import 'package:tcs_app/utils/app_colors.dart';

class DashboardShimmer extends StatefulWidget {
  final int itemCount;
  final bool showProfile;

  const DashboardShimmer({
    this.itemCount = 6,
    this.showProfile = true,
    super.key,
    // Keep these for backward compatibility but ignore if needed
    double? itemWidth,
    double? itemHeight,
  });

  @override
  State<DashboardShimmer> createState() => _DashboardShimmerState();
}

class _DashboardShimmerState extends State<DashboardShimmer>
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
    return Column(
      children: [
        if (widget.showProfile) ...[
          _buildProfilePlaceholder(),
          const SizedBox(height: 20),
        ],
        _buildHubPlaceholder(),
        const SizedBox(height: 20),
        _buildActionGrid(),
      ],
    );
  }

  Widget _buildProfilePlaceholder() {
    return _ShimmerPlaceholder(
      animation: _animation,
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.borderGrey.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildHubPlaceholder() {
    return _ShimmerPlaceholder(
      animation: _animation,
      child: Container(
        height: 100,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.borderGrey.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildActionGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return _ShimmerPlaceholder(
          animation: _animation,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.borderGrey.withValues(alpha: 0.5),
              ),
            ),
          ),
        );
      },
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
