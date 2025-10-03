import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tcs_app/Model/Firebase/Promotion/promotion_model.dart';
// import 'package:tcs_app/PushNotifications/push_notifications_manager.dart';
import 'package:tcs_app/Repositories/Promotion/promotion_repository.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Routes/promotion_args.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<StatefulWidget> createState() {
    return SplashScreenUIState();
  }
}

class SplashScreenUIState extends State<SplashScreenUI> {
  PromotionModel? _activePromotion;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      // Handle web-specific initialization here if needed
      Future.delayed(const Duration(seconds: 3), () {
        AppNavigation.pushReplacementTo(AppNavRoutes.authWrapperRoute);
      });
    } else {
      PromotionRepository().getActivePromotion().then((value) {
        if (value != null) {
          _activePromotion = value;
        }
        Future.delayed(const Duration(seconds: 3), () {
          if (_activePromotion != null &&
              ((_activePromotion!.isLive &&
                      kReleaseMode &&
                      _activePromotion!.startDate!.isBefore(DateTime.now()) &&
                      _activePromotion!.endDate!.isAfter(DateTime.now())) ||
                  (kDebugMode && _activePromotion!.isTesting))) {
            AppNavigation.pushReplacementTo(
              AppNavRoutes.promotionRoute,
              arguments: PromotionArgs(promotionModel: _activePromotion!),
            );
          } else {
            AppNavigation.pushReplacementTo(AppNavRoutes.authWrapperRoute);
          }
        });
      });
    }
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
