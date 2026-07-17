import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:tcs_app/custom_widgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/custom_widgets/CustomStudentInfo/custom_student_info.dart';
import 'package:tcs_app/custom_widgets/ParticleBackground/particle_background.dart';
import 'package:tcs_app/provider/Dashboard/dashboard_provider.dart';
import 'package:tcs_app/provider/StudentDashboard/student_dashboard_provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/utils/app_colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _particleController;
  late DashboardProvider _provider;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _provider = Provider.of<DashboardProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );
    _provider.initializeData();
  }

  @override
  void dispose() {
    _particleController.dispose();
    _provider.disposeData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'CHANGE PASSWORD'),
      body: Stack(
        children: [
          ParticleBackground(
            animation: _particleController,
            particleColor: AppColors.primaryBlue.withValues(alpha: 0.15),
          ),
          SafeArea(
            child: Consumer<DashboardProvider>(
              builder: (context, value, _) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Header Section
                    SliverToBoxAdapter(
                      child: Consumer<LocalDataProvider>(
                        builder: (context, localData, _) {
                          if (localData.userData?.userType == 'Parent') {
                            return _buildParentHeader(localData);
                          }
                          return _buildReusableHeader();
                        },
                      ),
                    ),

                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverToBoxAdapter(
                        child: FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLightBlue.withValues(
                                    alpha: 0.8,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: AppColors.primaryBlue.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Form(
                                  key: value.changePasswordFormKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildSectionTitle('ACCOUNT SECURITY'),
                                      const SizedBox(height: 16),
                                      CustomTextFormField(
                                        isEnable: false,
                                        hintText: value.userNameController.text,
                                        prefixIcon:
                                            Icons.person_outline_rounded,
                                      ),
                                      const SizedBox(height: 16),
                                      CustomTextFormField(
                                        controller: value.oldPassController,
                                        obscureText: value.obscureText,
                                        suffixWidget: GestureDetector(
                                          onTap: () => value.showHidePassword(),
                                          child: Icon(
                                            value.obscureText
                                                ? Icons.visibility_off_rounded
                                                : Icons.visibility_rounded,
                                            color: AppColors.white,
                                            size: 20,
                                          ),
                                        ),
                                        hintText: 'Current Password',
                                        prefixIcon: Icons.lock_outline_rounded,
                                        validator: value.validator,
                                      ),
                                      const SizedBox(height: 16),
                                      const Divider(
                                        height: 32,
                                        thickness: 0.5,
                                        color: AppColors.primaryTitleColor,
                                      ),
                                      _buildSectionTitle('NEW PASSWORD'),
                                      const SizedBox(height: 16),
                                      CustomTextFormField(
                                        controller: value.newPassController,
                                        obscureText:
                                            value.obscureTextNewPassword,
                                        suffixWidget: GestureDetector(
                                          onTap: () =>
                                              value.showHideNewPassword(),
                                          child: Icon(
                                            value.obscureTextNewPassword
                                                ? Icons.visibility_off_rounded
                                                : Icons.visibility_rounded,
                                            color: AppColors.white,
                                            size: 20,
                                          ),
                                        ),
                                        hintText: 'New Password',
                                        prefixIcon: Icons.password_rounded,
                                        validator: value.passwordValidator,
                                      ),
                                      const SizedBox(height: 16),
                                      CustomTextFormField(
                                        obscureText:
                                            value.obscureTextConfirmPassword,
                                        controller: value.confirmPassController,
                                        hintText: 'Confirm New Password',
                                        prefixIcon:
                                            Icons.verified_user_outlined,
                                        suffixWidget: GestureDetector(
                                          onTap: () =>
                                              value.showHideConfirmPassword(),
                                          child: Icon(
                                            value.obscureTextConfirmPassword
                                                ? Icons.visibility_off_rounded
                                                : Icons.visibility_rounded,
                                            color: AppColors.white,
                                            size: 20,
                                          ),
                                        ),
                                        validator:
                                            value.confirmPasswordValidator,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Action Button
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: FadeInUp(
                          delay: const Duration(milliseconds: 200),
                          child: CustomAppButton(
                            buttonTitle: 'UPDATE PASSWORD',
                            onTap: () => value.changePassword(),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: AppColors.primaryBlue,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildParentHeader(LocalDataProvider localData) {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryDarkBlue, Color(0xED002D62)],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.admin_panel_settings_rounded,
                color: AppColors.goldenYellow,
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PARENT ACCOUNT',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: AppColors.goldenYellow,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    localData.userData?.name?.toUpperCase() ?? 'PARENT',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'CNIC: ${localData.userData?.userName ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
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

  Widget _buildReusableHeader() {
    return Consumer2<StudentDashboardProvider, LocalDataProvider>(
      builder: (context, dashboardProvider, localData, _) {
        final profile =
            dashboardProvider.activeChildData?.profile?.profile?.firstOrNull;

        if (profile == null) {
          return CustomStudentInfo(info: localData.userData?.info);
        }

        final infoWrapper = {
          'rollNo': profile.studentId,
          'name': profile.name,
          'className': profile.className,
          'centerName': profile.center,
        };

        return CustomStudentInfo(info: StudentInfoWrapper(infoWrapper));
      },
    );
  }
}

