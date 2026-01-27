import 'package:flutter/material.dart';
import 'package:tcs_app/custom_widgets/ProgressButton/progress_button.dart';
import 'package:video_player/video_player.dart';

import '../../custom_widgets/CustomAppBar/custom_app_bar.dart';
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
  var isVideoCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset(
      'assets/images/FEATURE_Citizans_App2.mp4',
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
    if (_controller.value.isCompleted && mounted && !isVideoCompleted) {
      Future.delayed(
        const Duration(milliseconds: 100),
        () => AppNavigation.pushReplacementTo(AppNavRoutes.registrationRoute),
      );
      isVideoCompleted = true;
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

          return ProgressButton(
            progress: progress,
            routeName: AppNavRoutes.registrationRoute,
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
