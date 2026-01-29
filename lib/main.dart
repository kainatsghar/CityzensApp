import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:tcs_app/utils/media_query_util.dart';

import 'provider/app_providers.dart';
import 'routes/app_navigation.dart';
import 'routes/app_navigation_routes.dart';
import 'routes/route_generator.dart';
import 'screens/SplashScreen/splash_screen_ui.dart';
import 'services/InitServices/app_initializer.dart';
import 'utils/app_themes.dart';

// Background FCM handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await AppInitializer.ensureCoreInitialized();
  await AppInitializer.push.showFromBackgroundSafe(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    runApp(const TCSApp());
  } else {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await AppInitializer.ensureCoreInitialized();
    runApp(const TCSApp());
    unawaited(AppInitializer.bootstrapAll());
  }
}

class TCSApp extends StatelessWidget {
  const TCSApp({super.key});

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);
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
        navigatorObservers: !kIsWeb ? [AppInitializer.analyticsObserver] : [],
      ),
    );
  }
}
