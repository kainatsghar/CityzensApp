import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Provider/Splash/splash_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:tcs_app/Utils/app_themes.dart';

class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<StatefulWidget> createState() => SplashScreenUIState();
}

class SplashScreenUIState extends State<SplashScreenUI>
    with SingleTickerProviderStateMixin {
  late SplashProvider splashProvider;
  late AnimationController _loadController;

  @override
  void initState() {
    super.initState();
    _loadController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    splashProvider = Provider.of<SplashProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );
    splashProvider.loadInitialData();
  }

  @override
  void dispose() {
    _loadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeInDown(
                      duration: const Duration(milliseconds: 900),
                      child: Image.asset(
                        'assets/images/tcs_logo_white.png',
                        height: 140,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeInUp(
                      duration: const Duration(milliseconds: 700),
                      delay: const Duration(milliseconds: 300),
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              style: AppThemes.sora(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                              children: const [
                                TextSpan(text: 'City'),
                                TextSpan(
                                  text: 'zens',
                                  style: TextStyle(color: AppColors.yellow),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'WELCOME',
                            style: AppThemes.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.85),
                              letterSpacing: 4.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    FadeIn(
                      duration: const Duration(milliseconds: 500),
                      delay: const Duration(milliseconds: 500),
                      child: Container(
                        width: 120,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: AnimatedBuilder(
                          animation: _loadController,
                          builder: (context, child) {
                            return Align(
                              alignment: Alignment(
                                -1.0 + (_loadController.value * 2.0),
                                0.0,
                              ),
                              child: Container(
                                width: 45,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: AppColors.yellow,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Version ${AppConstants.appVersion}',
                style: AppThemes.roboto(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
