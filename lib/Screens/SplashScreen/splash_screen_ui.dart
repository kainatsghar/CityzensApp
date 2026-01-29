import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/provider/Splash/splash_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';

class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<StatefulWidget> createState() => SplashScreenUIState();
}

class SplashScreenUIState extends State<SplashScreenUI> {
  late SplashProvider splashProvider;

  @override
  void initState() {
    super.initState();

    splashProvider = Provider.of<SplashProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );
    splashProvider.loadInitialData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: FadeIn(
        duration: const Duration(milliseconds: 2000),
        delay: const Duration(milliseconds: 500),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/tcs_logo_white.png',
                    height: size.height / 3,
                  ),
                  SizedBox(height: size.height * 0.02),
                  const Text(
                    ' W E L C O M E ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: size.height * 0.33),
                  Text(
                    "Version: ${AppConstants.appVersion}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
