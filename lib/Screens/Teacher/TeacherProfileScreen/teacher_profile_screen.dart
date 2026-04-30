import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/TeacherProfileComponents/teacher_profile_component.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/TeacherProfile/teacher_profile_provider.dart';

import 'package:tcs_app/custom_widgets/ParticleBackground/particle_background.dart';
import 'package:tcs_app/utils/app_colors.dart';

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return TeacherProfileScreenState();
  }
}

class TeacherProfileScreenState extends State<TeacherProfileScreen>
    with TickerProviderStateMixin {
  late final AnimationController _particleController;
  late final ScrollController _scrollController;
  Future? _teacherProfile;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Subtle, slow particle flow for a premium feel
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 35),
    )..repeat();

    final provider = Provider.of<TeacherProfileProvider>(
      context,
      listen: false,
    );
    if (provider.profileResponse == null) {
      _teacherProfile = provider.loadTeacherProfile();
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
    final provider = Provider.of<TeacherProfileProvider>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Dark icons for Android
        statusBarBrightness: Brightness.light, // Dark icons for iOS
      ),
      child: Scaffold(
        backgroundColor: AppColors.ultraLightGrey,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryLightBlue, AppColors.ultraLightGrey],
            ),
          ),
          child: Stack(
            children: [
              // 1. Dynamic Particle Layer (Very subtle for light theme)
              ParticleBackground(
                animation: _particleController,
                particleColor: AppColors.primaryBlue.withValues(alpha: 0.15),
              ),

              // 2. Main Content
              RefreshIndicator(
                displacement: 80,
                color: AppColors.primaryBlue,
                onRefresh: () => provider.loadTeacherProfile(),
                child: provider.profileResponse != null
                    ? TeacherProfileComponent(
                        scrollController: _scrollController,
                      )
                    : FutureBuilder(
                        future: _teacherProfile,
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return const Center(child: CustomLoader());
                            default:
                              if (snapshot.hasData ||
                                  provider.profileResponse != null) {
                                return TeacherProfileComponent(
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
      ),
    );
  }
}
