import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/provider/TeacherProfile/teacher_profile_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/helper_function.dart';

class TeacherProfileCard extends StatelessWidget {
  final double? borderRadius;
  final EdgeInsets? padding;
  final bool isMale;
  final void Function()? onTap;

  const TeacherProfileCard({
    super.key,
    this.borderRadius,
    this.padding,
    this.isMale = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherProfileProvider>(
      builder: (context, profileProvider, _) {
        final profile = profileProvider.profileResponse;

        if (profile == null) {
          return const SizedBox.shrink();
        }

        return RepaintBoundary(
          child: Container(
            margin: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius ?? 24.0),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryBlue, AppColors.primaryDarkBlue],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDarkBlue.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius ?? 24.0),
              child: Stack(
                children: [
                  // Decorative Accents
                  Positioned(
                    right: -40,
                    top: -40,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 40,
                    bottom: -30,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.white.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -20,
                    bottom: -20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.secondaryColor.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  // Interactive Content
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Avatar Section
                            _buildAvatar(
                              profile.employeeCode ?? '',
                              AppColors.secondaryColor, // Premium Gold
                            ),
                            const SizedBox(width: 20),

                            // Info Section
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    HelperFunction.noNullStringText(
                                      profile.teacherName ?? '',
                                    ).toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.white,
                                      letterSpacing: 0.5,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 10),
                                  _buildBadge(profile.designation ?? ''),
                                  const SizedBox(height: 14),
                                  _buildBranchInfo(
                                    profile.branch ?? '',
                                    AppColors.white.withValues(alpha: 0.9),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppColors.white.withValues(alpha: 0.3),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(String employeeCode, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [borderColor, borderColor.withValues(alpha: 0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryDarkBlue, // Inner border separator
        ),
        child: ClipOval(
          child: Hero(
            tag: 'teacher_profile_image',
            child: CustomUserImage(
              userId: employeeCode,
              disableUploadImage: true,
              isMale: isMale,
              imageSize: 75,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified_rounded,
            color: AppColors.secondaryColor,
            size: 12,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.white,
                letterSpacing: 1.0,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchInfo(String branch, Color color) {
    return Row(
      children: [
        Icon(
          Icons.apartment_rounded,
          size: 14,
          color: color.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            branch.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
