import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ProgressButton/progress_button.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/Splash/splash_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/services/FirebaseServices/ad_analytics_service.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:video_player/video_player.dart';

class PromotionScreenUI extends StatefulWidget {
  const PromotionScreenUI({super.key});

  @override
  State<PromotionScreenUI> createState() => _PromotionScreenUIState();
}

class _PromotionScreenUIState extends State<PromotionScreenUI>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoController;
  Timer? _timer;
  double _progress = 0.0;
  // Change _progressDuration to a shorter interval for smoother updates
  final _progressDuration = const Duration(milliseconds: 50);
  DateTime? _startTime;
  bool _isPaused = false;

  // Add these variables to track pause time
  DateTime? _pauseStartTime;
  Duration _totalPausedDuration = Duration.zero;

  late SplashProvider splashProvider;

  @override
  void initState() {
    super.initState();

    splashProvider = Provider.of<SplashProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );

    if (splashProvider.activePromotion!.promotionType.toLowerCase() ==
        AdType.video.displayName.toLowerCase()) {
      _initializeVideo();
    } else {
      _startTimer();
    }
    AdAnalyticsService.logAdImpression(
      adId: splashProvider.activePromotion!.id.toString(),
      position: AdPosition.launchPage.displayName,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _startTime = null;
    _totalPausedDuration = Duration.zero;
    _pauseStartTime = null;
    _videoController?.removeListener(_onVideoProgress);
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    _videoController = VideoPlayerController.asset(
      splashProvider.activePromotion!.url!,
    );

    try {
      await _videoController!.initialize();
      _videoController!.addListener(_onVideoProgress);
      _videoController!.setLooping(false);
      if (mounted) {
        setState(() {});
        _videoController!.play();
      }
    } catch (e) {
      debugPrint('Error initializing video: $e');
      _navigateToNextScreen();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _startTime ??= DateTime.now();

    _timer = Timer.periodic(_progressDuration, (timer) {
      if (mounted && !_isPaused) {
        setState(() {
          final currentDuration =
              DateTime.now().difference(_startTime!) - _totalPausedDuration;
          _progress =
              currentDuration.inMilliseconds /
              Duration(
                seconds: splashProvider.activePromotion!.displayDuration,
              ).inMilliseconds;
          if (_progress >= 1.0) {
            _navigateToNextScreen();
          }
        });
      }
    });
  }

  void _onVideoProgress() {
    if (_videoController != null &&
        _videoController!.value.isCompleted &&
        mounted) {
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() {
    _timer?.cancel();
    AppNavigation.pushReplacementTo(AppNavRoutes.authWrapperRoute);
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPaused = true;
      _pauseStartTime = DateTime.now();
      _timer?.cancel();
      if (_videoController?.value.isPlaying ?? false) {
        _videoController?.pause();
      }
    });
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPaused) {
      if (_pauseStartTime != null) {
        _totalPausedDuration += DateTime.now().difference(_pauseStartTime!);
      }
      setState(() {
        _isPaused = false;
        _pauseStartTime = null;
        if (_videoController != null) {
          _videoController?.play();
        } else {
          _startTimer();
        }
      });
    }
  }

  void _handleTapCancel() {
    _handleTapUp(TapUpDetails(kind: PointerDeviceKind.touch));
  }

  @override
  Widget build(BuildContext context) {
    final insets = MediaQuery.of(context).systemGestureInsets;
    bool isGestureNav = insets.left > 0 || insets.right > 0;
    return SafeArea(
      top: false,
      bottom: Platform.isIOS ? false : !isGestureNav,
      child: Scaffold(
        floatingActionButton: _buildSkipButton(),
        body: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: Stack(
            children: [
              // Content (Image or Video)
              if (splashProvider.activePromotion!.promotionType.toLowerCase() ==
                      AdType.video.displayName.toLowerCase() &&
                  _videoController?.value.isInitialized == true)
                Center(
                  child: AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  ),
                )
              else if (splashProvider.activePromotion!.promotionType
                      .toLowerCase() ==
                  AdType.image.displayName.toLowerCase())
                Positioned.fill(
                  child: FadeIn(
                    child: InkWell(
                      onTap:
                          (splashProvider.activePromotion!.tapLinkURL == null &&
                              splashProvider
                                  .activePromotion!
                                  .tapLinkURL!
                                  .isEmpty)
                          ? null
                          : () async {
                              // Track the tap
                              await AdAnalyticsService.logAdTap(
                                adId: splashProvider.activePromotion!.id.toString(),
                                position: AdPosition.launchPage.displayName,
                                adTitle: splashProvider.activePromotion!.title!,
                              );

                              // Track link open
                              await AdAnalyticsService.logAdOpenLink(
                                adId: splashProvider.activePromotion!.id.toString(),
                                position: AdPosition.launchPage.displayName,
                              );
                              HelperFunction.launchURL(
                                splashProvider.activePromotion!.tapLinkURL!,
                              );
                            },
                      child: CachedNetworkImage(
                        imageUrl: splashProvider.activePromotion!.url!,
                        fit: splashProvider.activePromotion!.isFullScreen
                            ? BoxFit.fill
                            : BoxFit.contain,
                        placeholder: (context, url) =>
                            const Center(child: CustomLoader()),
                        errorWidget: (context, url, error) => Center(
                          child: ShowError(errorText: error.toString()),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    final progress =
        splashProvider.activePromotion!.promotionType.toLowerCase() ==
                AdType.video.displayName.toLowerCase() &&
            _videoController?.value.duration != null
        ? (_videoController!.value.position.inMilliseconds.toDouble() /
              _videoController!.value.duration.inMilliseconds.toDouble())
        : _progress;

    return ProgressButton(
      progress: progress,
      routeName: AppNavRoutes.authWrapperRoute,
    );
  }
}
