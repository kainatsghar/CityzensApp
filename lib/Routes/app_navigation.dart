import 'package:flutter/material.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Routes/screen_arguments.dart';

class AppNavigation {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    debugPrint('[AN] Navigating to $routeName : ${arguments.toString()}');
    return navigatorKey.currentState!.pushNamed(
      routeName,
      arguments: arguments ?? const ScreenArguments(),
    );
  }

  static Future<dynamic> pushReplacementTo(
    String routeName, {
    Object? arguments,
  }) {
    debugPrint('[AN] Navigating to $routeName : ${arguments.toString()}');
    return navigatorKey.currentState!.pushReplacementNamed(
      routeName,
      arguments: arguments ?? const ScreenArguments(),
    );
  }

  static Future<dynamic> pushAndKillAll(String routeName, {Object? arguments}) {
    debugPrint('[AN] Navigating to $routeName : ${arguments.toString()}');
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      ModalRoute.withName(AppNavRoutes.initialRoute),
      arguments: arguments ?? const ScreenArguments(),
    );
  }

  static void removeRoutesUntil(String routeName) =>
      navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));

  static void removeAllRoutes() =>
      navigatorKey.currentState?.popUntil((route) => route.isFirst);

  static void goBack() {
    return navigatorKey.currentState?.pop();
  }

  static bool canPop() {
    return navigatorKey.currentState?.canPop() ?? false;
  }

  static BuildContext? get currentContext =>
      navigatorKey.currentState?.overlay?.context;
}
