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
                  color: AppColors.primaryBlue.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius ?? 24.0),
              child: Stack(
                children: [
                  // Interactive Content
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTap,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Avatar Section
                            _buildAvatar(
                              profile.employeeCode ?? '',
                              AppColors.whiteColor.withValues(alpha: 0.8),
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
                                      color: AppColors.whiteColor,
                                      letterSpacing: 0.5,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  _buildBadge(
                                    profile.designation ?? '',
                                    AppColors.whiteColor.withValues(
                                      alpha: 0.15,
                                    ),
                                    AppColors.whiteColor.withValues(alpha: 0.2),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildBranchInfo(
                                    profile.branch ?? '',
                                    AppColors.whiteColor.withValues(alpha: 0.9),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: AppColors.whiteColor,
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
        border: Border.all(color: borderColor, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
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
    );
  }

  Widget _buildBadge(String text, Color bg, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w900,
          color: AppColors.goldenYellow,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildBranchInfo(String branch, Color color) {
    return Row(
      children: [
        const Icon(
          Icons.location_on_rounded,
          size: 12,
          color: AppColors.goldenYellow,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            branch.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
