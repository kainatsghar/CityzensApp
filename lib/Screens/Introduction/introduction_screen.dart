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
    _controller =
        VideoPlayerController.asset('images/FEATURE_Citizans_App2.mp4')
          ..initialize().then((_) {
            _controller.play();
            _controller.setLooping(true);
            if (mounted) {
              setState(() {});
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      floatingActionButton: SizedBox(
        height: 36,
        child: FloatingActionButton(
          backgroundColor: AppColors.whiteColor,
          onPressed: () {
            // setState(() {
            //   _controller.value.isPlaying
            //       ? _controller.pause()
            //       : _controller.pause();
            // });
            AppNavigation.pushReplacementTo(AppNavRoutes.registrationRoute);
          },
          child: const Text(
            'Skip',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: VideoPlayer(_controller),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
