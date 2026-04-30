import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/TeacherProfile/teacher_profile_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:tcs_app/utils/helper_function.dart';

import 'package:tcs_app/gen/assets.gen.dart';

class TeacherProfileComponent extends StatelessWidget {
  final ScrollController scrollController;
  const TeacherProfileComponent({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherProfileProvider>(
      builder: (context, value, _) {
        if (value.profileResponse == null) {
          return const Center(
            child: ShowError(errorText: AppConstants.noRecordFound),
          );
        }

        final profile = value.profileResponse!;

        return CustomScrollView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // 1. Premium Parallax Header (Redesigned for Light Theme)
            SliverAppBar(
              expandedHeight: 340,
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: true,
              systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.light,
              ),
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: AppColors.primaryBlue,
                    size: 18,
                  ),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop();
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Parallax Image & Info
                    AnimatedBuilder(
                      animation: scrollController,
                      builder: (context, child) {
                        double offset = 0;
                        if (scrollController.hasClients) {
                          offset = scrollController.offset * 0.4;
                        }
                        return Transform.translate(
                          offset: Offset(0, offset),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 40),
                              // Profile Image with Soft Shadow
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryBlue.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Hero(
                                  tag: 'teacher_profile_image',
                                  child: CustomUserImage(
                                    userId: '${profile.employeeCode}',
                                    disableUploadImage: false,
                                    isMale: profile.gender == 'Male',
                                    imageSize: 130,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Name & Designation with Dark Theme Contrast
                              Text(
                                HelperFunction.noNullStringText(
                                  '${profile.teacherName}',
                                ).toUpperCase(),
                                style: const TextStyle(
                                  color: AppColors.primaryDarkBlue,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 24.0,
                                  letterSpacing: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue.withValues(
                                    alpha: 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  HelperFunction.noNullStringText(
                                    '${profile.designation}',
                                  ),
                                  style: const TextStyle(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 2. Information Cards
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 40),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildAnimatedCard(
                    delay: 100,
                    child: _ProfileCard(
                      title: 'Work Information',
                      children: [
                        _buildProfileField(
                          icon: Icons.badge_rounded,
                          label: 'Employee ID',
                          value: '${profile.employeeCode}',
                        ),
                        _buildProfileField(
                          icon: Icons.business_rounded,
                          label: 'Branch',
                          value: '${profile.branch}',
                        ),
                        _buildProfileField(
                          icon: Icons.public_rounded,
                          label: 'Region & City',
                          value: '${profile.region}, ${profile.city}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildAnimatedCard(
                    delay: 250,
                    child: _ProfileCard(
                      title: 'Contact Details',
                      children: [
                        _buildProfileField(
                          icon: Icons.phone_android_rounded,
                          label: 'Cell Number',
                          value: '${profile.employeeCell}',
                        ),
                        _buildProfileField(
                          icon: Icons.alternate_email_rounded,
                          label: 'Email Address',
                          value: '${profile.email}',
                        ),
                        _buildProfileField(
                          icon: Icons.home_work_rounded,
                          label: 'Resident Address',
                          value: '${profile.address}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildAnimatedCard(
                    delay: 400,
                    child: _ProfileCard(
                      title: 'Personal Details',
                      children: [
                        _buildProfileField(
                          icon: Icons.fingerprint_rounded,
                          label: 'CNIC Number',
                          value: '${profile.cnicNumber}',
                        ),
                        _buildProfileField(
                          icon: Icons.favorite_rounded,
                          label: 'Marital Status',
                          value: profile.maritalStatus == 'M'
                              ? 'Married'
                              : 'Single',
                        ),
                        _buildProfileField(
                          icon: Icons.auto_awesome_rounded,
                          label: 'Religion',
                          value: '${profile.religion}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // School Branding Footer
                  Center(
                    child: Image.asset(
                      Assets
                          .images
                          .tcsLogo
                          .path, // Use color logo for light theme
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedCard({required Widget child, required int delay}) {
    return FadeInUp(
      duration: const Duration(milliseconds: 800),
      delay: Duration(milliseconds: delay),
      child: child,
    );
  }

  Widget _buildProfileField({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderGrey, width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primaryBlue, size: 20),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.softGreyText,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    HelperFunction.noNullStringText(value).isEmpty
                        ? 'N/A'
                        : HelperFunction.noNullStringText(value),
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.primaryDarkBlue,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
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

class _ProfileCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ProfileCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.goldenYellow,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primaryDarkBlue,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}
