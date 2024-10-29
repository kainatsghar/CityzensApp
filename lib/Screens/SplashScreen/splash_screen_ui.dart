import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tcs_app/PushNotifications/push_notifications.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<StatefulWidget> createState() {
    return SplashScreenUIState();
  }
}

class SplashScreenUIState extends State<SplashScreenUI>
    with SingleTickerProviderStateMixin {
  late Animation<double> _iconAnimation;
  late AnimationController _iconAnimationController;

  @override
  void initState() {
    super.initState();
    _iconAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _iconAnimation =
        CurvedAnimation(parent: _iconAnimationController, curve: Curves.linear);
    _iconAnimation.addListener(() => setState(() {}));
    _iconAnimationController.forward();
    Future.delayed(const Duration(seconds: 3), () {
      AppNavigation.pushReplacementTo(AppNavRoutes.authWrapperRoute);
      PushNotificationsManager.init();
    });
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('images/tcs_logo_white.png',
                    height: _iconAnimation.value * size.height / 3),
                SizedBox(height: size.height * 0.02),
                const Text(
                  ' W E L C O M E ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500),
                )
              ],
            )),
          ],
        ));
  }
}
