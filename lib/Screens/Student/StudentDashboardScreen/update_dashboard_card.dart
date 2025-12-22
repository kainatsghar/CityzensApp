import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/media_query_util.dart';
import 'package:tcs_app/gen/assets.gen.dart';
import 'package:lottie/lottie.dart';

class ResultDashboardCard extends StatefulWidget {
  final DateTime resultReleaseTime;
  final void Function()? onViewResult;
  final Future<dynamic>? loadResultsFuture;
  final NumberAnimationType animationType;

  const ResultDashboardCard({
    super.key,
    required this.resultReleaseTime,
    required this.onViewResult,
    this.loadResultsFuture,
    this.animationType = NumberAnimationType.scale,
  });

  @override
  State<ResultDashboardCard> createState() => _ResultDashboardCardState();
}

class _ResultDashboardCardState extends State<ResultDashboardCard> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    // Only start the periodic timer if remaining time is positive
    if (_remaining.inSeconds > 0) {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => _updateRemaining(),
      );
    }
  }

  void _updateRemaining() {
    final diff = widget.resultReleaseTime.difference(DateTime.now());
    setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
  }

  bool get isAvailable => _remaining.inSeconds <= 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: MediaQueryUtil.getResponsivePadding(
          horizontal: 2,
          vertical: 1,
        ),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: isAvailable ? _availableState() : _lockedState(),
      ),
    );
  }

  // ---------------- LOCKED ----------------

  Widget _lockedState() {
    final double gapSmall = MediaQueryUtil.getResponsivePercentageSize(
      0.1,
    ).clamp(4.0, 8.0);
    final double gapMedium = MediaQueryUtil.getResponsivePercentageSize(
      0.5,
    ).clamp(8.0, 16.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(showNew: false),
        Expanded(flex: 1, child: SizedBox(height: gapSmall)),
        Text(
          'Result will be available in',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w600,
            fontSize: MediaQueryUtil.getResponsiveFontSize(
              14,
            ).clamp(12.0, 16.0),
          ),
        ),
        Expanded(flex: 2, child: SizedBox(height: gapMedium)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _timeUnit(_remaining.inDays, 'DAYS'),
            _timeUnit(_remaining.inHours % 24, 'HRS'),
            _timeUnit(_remaining.inMinutes % 60, 'MIN'),
            _timeUnit(_remaining.inSeconds % 60, 'SEC'),
          ],
        ),
      ],
    );
  }

  Widget _timeUnit(int value, String label) {
    return Flexible(
      fit: FlexFit.tight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _numberBox(
            AnimatedNumber(value: value, animationType: widget.animationType),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.whiteColor),
          ),
        ],
      ),
    );
  }

  // ---------------- AVAILABLE ----------------

  Widget _availableState() {
    final double gapMedium = MediaQueryUtil.getResponsivePercentageSize(
      0.5,
    ).clamp(8.0, 16.0);
    final double buttonHeight = MediaQueryUtil.getResponsivePercentageSize(
      1,
    ).clamp(40.0, 56.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(showNew: true),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your result is now available',
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQueryUtil.getResponsiveFontSize(
                    14,
                  ).clamp(13.0, 16.0),
                ),
              ),
              SizedBox(width: gapMedium),
              Lottie.asset(
                Assets.lotties.diplomaCertificate,
                alignment: Alignment.centerLeft,
                width: MediaQueryUtil.getResponsivePercentageSize(
                  8,
                ).clamp(40.0, 75.0),
                height: MediaQueryUtil.getResponsivePercentageSize(
                  8,
                ).clamp(60.0, 75.0),
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),

        const Spacer(),
        Builder(
          builder: (ctx) {
            final future = widget.loadResultsFuture;
            if (future == null) {
              return SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: widget.onViewResult,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'View Result',
                    style: TextStyle(
                      fontSize: MediaQueryUtil.getResponsiveFontSize(
                        16,
                      ).clamp(14.0, 18.0),
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
              );
            }

            return FutureBuilder<dynamic>(
              future: future,
              builder: (context, snapshot) {
                final loading =
                    snapshot.connectionState == ConnectionState.waiting;
                return SizedBox(
                  width: double.infinity,
                  height: buttonHeight,
                  child: ElevatedButton(
                    onPressed: loading ? null : widget.onViewResult,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: loading
                        ? SizedBox(
                            height: MediaQueryUtil.getResponsivePercentageSize(
                              2.5,
                            ).clamp(18.0, 24.0),
                            width: MediaQueryUtil.getResponsivePercentageSize(
                              2.5,
                            ).clamp(18.0, 24.0),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.secondaryColor,
                            ),
                          )
                        : Text(
                            'View Result',
                            style: TextStyle(
                              fontSize: MediaQueryUtil.getResponsiveFontSize(
                                16,
                              ).clamp(14.0, 18.0),
                              color: AppColors.blackColor,
                            ),
                          ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _header({required bool showNew}) {
    return Row(
      children: [
        const Icon(
          Icons.emoji_events_rounded,
          color: AppColors.secondaryColor,
          size: 26,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'FIRST TERM RESULT 2025-2026',
            style: TextStyle(
              fontSize: MediaQueryUtil.getResponsiveFontSize(
                16,
              ).clamp(14.0, 16.0),
              color: AppColors.secondaryColor,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        if (showNew) ...[const SizedBox(width: 8), _newBadge()],
      ],
    );
  }

  Widget _newBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        'NEW',
        style: TextStyle(fontSize: 10, color: Colors.black),
      ),
    );
  }

  Widget _numberBox(Widget child) {
    final double boxHeight = MediaQueryUtil.getResponsivePercentageSize(
      4.5,
    ).clamp(36.0, 56.0);
    final double boxWidth = MediaQueryUtil.getWidthPercentage(
      16,
    ).clamp(48.0, 84.0);
    return Container(
      height: boxHeight,
      width: boxWidth,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: const Offset(3, 3),
            blurRadius: 6,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            offset: const Offset(-2, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: child,
    );
  }
}

// ---------------- TEXT-ONLY ANIMATIONS ----------------

class AnimatedNumber extends StatelessWidget {
  final int value;
  final NumberAnimationType animationType;

  const AnimatedNumber({
    super.key,
    required this.value,
    required this.animationType,
  });

  @override
  Widget build(BuildContext context) {
    switch (animationType) {
      case NumberAnimationType.flip:
        return _flip();
      case NumberAnimationType.odometer:
        return _odometer();
      case NumberAnimationType.fade:
        return _fade();
      case NumberAnimationType.scale:
        return _scale();
      case NumberAnimationType.counter:
        return _counter();
    }
  }

  Widget _text(String v) => Text(
    v.padLeft(2, '0'),
    key: ValueKey(v),
    style: TextStyle(
      fontSize: MediaQueryUtil.getResponsiveFontSize(18).clamp(16.0, 22.0),
      fontWeight: FontWeight.bold,
    ),
  );

  Widget _flip() => AnimatedSwitcher(
    duration: const Duration(milliseconds: 350),
    transitionBuilder: (child, anim) =>
        RotationTransition(turns: anim, child: child),
    child: _text(value.toString()),
  );

  Widget _odometer() => AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    transitionBuilder: (child, anim) => SlideTransition(
      position: Tween(
        begin: const Offset(0, 0.6),
        end: Offset.zero,
      ).animate(anim),
      child: child,
    ),
    child: _text(value.toString()),
  );

  Widget _fade() => AnimatedSwitcher(
    duration: const Duration(milliseconds: 250),
    transitionBuilder: (child, anim) =>
        FadeTransition(opacity: anim, child: child),
    child: _text(value.toString()),
  );

  Widget _scale() => AnimatedSwitcher(
    duration: const Duration(milliseconds: 300),
    transitionBuilder: (child, anim) =>
        ScaleTransition(scale: anim, child: child),
    child: _text(value.toString()),
  );

  Widget _counter() => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: value.toDouble()),
    duration: const Duration(milliseconds: 300),
    builder: (_, val, __) => Text(
      val.toInt().toString().padLeft(2, '0'),
      style: TextStyle(
        fontSize: MediaQueryUtil.getResponsiveFontSize(18).clamp(16.0, 22.0),
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

enum NumberAnimationType { flip, odometer, fade, scale, counter }
