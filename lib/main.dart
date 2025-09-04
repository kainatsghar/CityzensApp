import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Provider/app_providers.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Routes/route_generator.dart';
import 'package:tcs_app/Screens/SplashScreen/splash_screen_ui.dart';
import 'package:tcs_app/Services/InitServices/push_notifications.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/Services/InitServices/app_initializer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// main.dart (top-level)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await AppInitializer.ensureCoreInitialized();
  await PushNotifications.instance.showFromBackgroundSafe(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // register once (must be top-level fn reference)
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await AppInitializer.ensureCoreInitialized();
  runApp(const TCSApp());
  unawaited(AppInitializer.bootstrapAll());
}

class TCSApp extends StatelessWidget {
  const TCSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: appProviders,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cityzens',
        theme: AppThemes.lightTheme,
        home: const SplashScreenUI(),
        initialRoute: AppNavRoutes.initialRoute,
        navigatorKey: AppNavigation.navigatorKey,
        onGenerateRoute: RouteGenerator.generateRoute,
        navigatorObservers: [AppInitializer.analyticsObserver],
      ),
    );
  }
}
