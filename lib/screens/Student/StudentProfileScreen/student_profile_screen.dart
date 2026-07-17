import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/StudentProfileComponents/student_profile_component.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/StudentProfile/student_profile_provider.dart';
import 'package:tcs_app/custom_widgets/ParticleBackground/particle_background.dart';
import 'package:tcs_app/utils/app_colors.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return StudentProfileScreenState();
  }
}

class StudentProfileScreenState extends State<StudentProfileScreen>
    with TickerProviderStateMixin {
  late final AnimationController _particleController;
  late final ScrollController _scrollController;
  Future? _stdProfile;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Subtle, slow particle flow for a premium feel
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 35),
    )..repeat();

    final provider = Provider.of<StudentProfileProvider>(
      context,
      listen: false,
    );

    // Efficiency Optimization:
    // If profile data already exists (fetched at start), use it immediately.
    // Still trigger a background fetch to ensure data is fresh.
    if (provider.profileResponse == null) {
      _stdProfile = provider.loadStdProfile();
    } else {
      // Data exists, set the future to complete immediately
      _stdProfile = Future.value(provider.profileResponse);
    }

    // Force dark status bar icons on initialization
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _particleController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProfileProvider>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.ultraLightGrey,
        body: Stack(
          children: [
            // 1. Dynamic Particle Layer
            ParticleBackground(
              animation: _particleController,
              particleColor: AppColors.primaryBlue.withValues(alpha: 0.15),
            ),

            // 2. Main Content
            RefreshIndicator(
              displacement: 80,
              color: AppColors.primaryBlue,
              onRefresh: () => provider.loadStdProfile(),
              child: provider.profileResponse != null
                  ? StudentProfileComponent(scrollController: _scrollController)
                  : FutureBuilder(
                      future: _stdProfile,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(child: CustomLoader());
                          default:
                            if (snapshot.hasData ||
                                provider.profileResponse != null) {
                              return StudentProfileComponent(
                                scrollController: _scrollController,
                              );
                            } else {
                              return Center(
                                child: ShowError(
                                  errorText: '${snapshot.error}',
                                ),
                              );
                            }
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
