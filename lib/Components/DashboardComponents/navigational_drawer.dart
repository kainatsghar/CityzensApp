import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/custom_widgets/ParticleBackground/particle_background.dart';
import 'package:tcs_app/provider/Dashboard/dashboard_provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:tcs_app/utils/helper_function.dart';

/// A premium, modular Navigation Drawer for The City School.
///
/// Design Pillars:
/// - Heritage Header: Displays school logo and user profile in a glassmorphic stack.
/// - Atmospheric Background: Royal blue radial gradient with subtle 'gold dust' particles.
/// - Staggered Menus: Smooth animated entry for all navigation options.
class NavigationalDrawer extends StatefulWidget {
  const NavigationalDrawer({super.key});

  @override
  State<NavigationalDrawer> createState() => _NavigationalDrawerState();
}

class _NavigationalDrawerState extends State<NavigationalDrawer>
    with TickerProviderStateMixin {
  late final AnimationController _particleController;
  late final AnimationController _listController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();

    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Start list entry animation after a tiny delay for smoothness
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _listController.forward();
    });
  }

  @override
  void dispose() {
    _particleController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.82,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          // 1. Atmospheric Royal Background Layer
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(-0.5, -0.6), // Offset center for depth
                radius: 1.5,
                colors: [
                  AppColors.primaryBlue.withOpacity(0.95),
                  AppColors.primaryDarkBlue,
                ],
              ),
            ),
          ),

          // 2. Performance-Isolated Particles
          ParticleBackground(
            animation: _particleController,
            particleColor: AppColors.goldenYellow,
          ),

          // 3. Modular Content
          Consumer<LocalDataProvider>(
            builder: (context, localData, _) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Consumer<DashboardProvider>(
                  builder: (context, dashboard, _) {
                    return Column(
                      children: [
                        _buildRoyalHeader(context, localData, dashboard),
                        const SizedBox(height: 20),
                        _buildNavList(context, localData, dashboard),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Builds a glassmorphic header with profile and brand logo.
  Widget _buildRoyalHeader(
    BuildContext context,
    LocalDataProvider localData,
    DashboardProvider dashboard,
  ) {
    final bool isMale = localData.userData?.userType == 'Teacher'
        ? dashboard.teacherProfileProvider.profileResponse?.isMale ?? true
        : true;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.viewPaddingOf(context).top + 40,
        bottom: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1), width: 1.0),
        ),
      ),
      child: Column(
        children: [
          // User Identity
          CustomUserImage(
            userId: localData.userData?.userName ?? '',
            imageSize: 100,
            isMale: isMale,
          ),
          const SizedBox(height: 20),
          Text(
            HelperFunction.noNullStringText(
              localData.userData?.userType == 'Student'
                  ? localData.userData?.info?.name ?? ''
                  : localData.userData?.name ?? '',
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            localData.userData?.userType == 'Student'
                ? 'Roll No: ${localData.studentId}'
                : localData.userData?.userType == 'Parent'
                ? 'CNIC No: ${localData.userData?.userName ?? ''}'
                : 'ERP No: ${localData.userData?.userName ?? ''}',
            style: TextStyle(
              color: AppColors.goldenYellow.withOpacity(0.9),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the navigable list with staggered entrance animations.
  Widget _buildNavList(
    BuildContext context,
    LocalDataProvider localData,
    DashboardProvider dashboard,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildStaggeredItem(
            index: 0,
            title: 'About Us',
            icon: Icons.info_outline_rounded,
            onTap: () {
              Scaffold.of(context).closeDrawer();
              AppNavigation.navigateTo(AppNavRoutes.aboutUsRoute);
            },
          ),
          _buildStaggeredItem(
            index: 1,
            title: 'App Feedback',
            icon: Icons.feedback_outlined,
            onTap: () {
              Scaffold.of(context).closeDrawer();
              AppNavigation.navigateTo(AppNavRoutes.appFeedbackRoute);
            },
          ),
          if (localData.userData?.userType != 'Teacher')
            _buildStaggeredItem(
              index: 2,
              title: 'Change Password',
              icon: Icons.lock_outline_rounded,
              onTap: () {
                Scaffold.of(context).closeDrawer();
                AppNavigation.navigateTo(AppNavRoutes.changePasswordRoute);
              },
            ),
          _buildStaggeredItem(
            index: 3,
            title: 'Logout',
            icon: Icons.logout_rounded,
            isDestructive: true,
            onTap: () {
              localData.logout(context);
            },
          ),
          const SizedBox(height: 40),
          _buildStaggeredItem(
            index: 4,
            child: Text(
              'App Version: ${AppConstants.appVersion}',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.white.withOpacity(0.4),
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable staggered item with fade and slide transition.
  Widget _buildStaggeredItem({
    required int index,
    String? title,
    IconData? icon,
    VoidCallback? onTap,
    Widget? child,
    bool isDestructive = false,
  }) {
    final animation = CurvedAnimation(
      parent: _listController,
      curve: Interval(
        (0.1 * index).clamp(0.0, 1.0),
        1.0,
        curve: Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(30 * (1 - animation.value), 0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child:
                  child ??
                  _DrawerTile(
                    title: title ?? '',
                    icon: icon ?? Icons.circle,
                    onTap: onTap,
                    isDestructive: isDestructive,
                  ),
            ),
          ),
        );
      },
    );
  }
}

/// A custom glassmorphic list tile for the royal drawer.
class _DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isDestructive;

  const _DrawerTile({
    required this.title,
    required this.icon,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isDestructive
                    ? Colors.redAccent.withOpacity(0.8)
                    : AppColors.goldenYellow,
                size: 22,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.2),
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
