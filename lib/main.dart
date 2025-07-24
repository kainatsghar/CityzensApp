import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Provider/app_providers.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Routes/route_generator.dart';
import 'package:tcs_app/Screens/SplashScreen/splash_screen_ui.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'Utils/app_themes.dart';

void main() async {
  await HelperFunction.mainInitializer();
  runApp(const TCSApp());
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
      ),
    );
  }
}
