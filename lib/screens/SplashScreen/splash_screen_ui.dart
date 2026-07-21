import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/LogoWidget/logo_widget.dart';
import 'package:tcs_app/custom_widgets/ParticleBackground/particle_background.dart';
import 'package:tcs_app/provider/Splash/splash_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';

/// A performance-optimized production Splash Screen.
///
/// Performance Highlights:
/// - [RepaintBoundary] around the animated center to isolate branding animations.
/// - [const] constructors used for all static UI elements.
/// - Leverages hardware acceleration via specialized background painters.
class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<StatefulWidget> createState() => SplashScreenUIState();
}

class SplashScreenUIState extends State<SplashScreenUI>
    with TickerProviderStateMixin {
  late final SplashProvider _splashProvider;

  // Optimized Orchestrator Controllers
  late final AnimationController _entryController;
  late final AnimationController _ambientController;

  // Immutable Animation Maps
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;
  late final Animation<double> _textFade;
  late final Animation<double> _versionFade;
  late final Animation<Color?> _bgGradientColor;

  @override
  void initState() {
    super.initState();

    _splashProvider = Provider.of<SplashProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );
    _splashProvider.loadInitialData();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);

    _logoFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
    );

    _logoScale = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _textFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.5, 0.85, curve: Curves.easeIn),
    );

    _versionFade = CurvedAnimation(
      parent: _entryController,
      curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
    );

    _bgGradientColor =
        ColorTween(
          begin: AppColors.primaryDarkBlue,
          end: AppColors.indigoDeep,
        ).animate(
          CurvedAnimation(parent: _ambientController, curve: Curves.easeInOut),
        );

    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: AnimatedBuilder(
          animation: Listenable.merge([_bgGradientColor, _ambientController]),
          builder: (context, child) {
            return DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.2),
                  radius: 1.8,
                  colors: [
                    _bgGradientColor.value!.withValues(alpha: 0.9),
                    AppColors.primaryDarkBlue,
                  ],
                ),
              ),
              child: child,
            );
          },
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // Optimized modular particles
              ParticleBackground(
                animation: _ambientController,
                particleColor: AppColors.secondaryColor,
              ),

              // Isolated foreground content
              Center(
                child: RepaintBoundary(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeTransition(
                        opacity: _logoFade,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: LogoWidget(
                            size: MediaQuery.sizeOf(context).height * 0.28,
                            glowColor: AppColors.secondaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      FadeTransition(
                        opacity: _textFade,
                        child: const Text(
                          'W E L C O M E',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 8.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Static Footer (Optimized with const)
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _versionFade,
                  child: Text(
                    "v${AppConstants.appVersion}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.4),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
