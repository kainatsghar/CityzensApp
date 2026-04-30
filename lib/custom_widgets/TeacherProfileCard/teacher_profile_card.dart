import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/gen/assets.gen.dart';
import 'package:tcs_app/provider/TeacherProfile/teacher_profile_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:tcs_app/utils/media_query_util.dart';

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

        return Container(
          margin: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
            image: DecorationImage(
              image: AssetImage(Assets.images.tcsLogoWhite.path),
              fit: BoxFit.fitHeight,
              opacity: 0.1,
              alignment: Alignment.centerRight,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryBlue.withOpacity(0.05),
                AppColors.primaryBlue.withOpacity(0.15),
              ],
            ),
            border: Border.all(
              color: AppColors.primaryBlue.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Avatar with gender-based image
                    Container(
                      width: MediaQueryUtil.getResponsivePercentageSize(8),
                      height: MediaQueryUtil.getResponsivePercentageSize(8),
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child: Hero(
                          tag: 'teacher_profile_image',
                          child: CustomUserImage(
                            userId: profile.employeeCode ?? '',
                            disableUploadImage: true,
                            isMale: isMale,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Teacher Name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQueryUtil.getWidthPercentage(62),
                          child: Text(
                            HelperFunction.noNullStringText(
                              profile.teacherName ?? '',
                            ).toUpperCase(),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDarkColor,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Designation
                        SizedBox(
                          width: MediaQueryUtil.getWidthPercentage(62),
                          child: Text(
                            HelperFunction.noNullStringText(
                              profile.designation ?? '',
                            ).toUpperCase(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Branch Name
                        Row(
                          children: [
                            Container(
                              width: MediaQueryUtil.getWidthPercentage(62),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 6.0,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: AppColors.primaryBlue.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  HelperFunction.noNullStringText(
                                    profile.branch ?? '',
                                  ).toUpperCase(),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryBlue,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
