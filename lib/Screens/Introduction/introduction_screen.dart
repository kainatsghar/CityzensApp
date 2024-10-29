import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../CustomWidgets/CustomAppbar/custom_appbar.dart';
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
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraints) => AspectRatio(
              aspectRatio: constraints.maxWidth / constraints.maxHeight,
              child: VideoPlayer(_controller),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: InkWell(
              onTap: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.pause();
                });
                AppNavigation.navigateTo(AppNavRoutes.registrationRoute);
              },
              child: Container(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, right: 10, left: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 3, 108, 193)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
