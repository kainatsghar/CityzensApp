import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CityzensIcons/cityzens_icons.dart';
import 'package:tcs_app/CustomWidgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/citizen/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/Utils/helper_function.dart';

class NavigationalDrawer extends StatelessWidget {
  const NavigationalDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final double topPad = MediaQuery.paddingOf(context).top;

    return Consumer<LocalDataProvider>(
      builder: (context, value, _) {
        final String userType = value.userData?.userType ?? 'Student';
        final String displayName = userType == 'Student'
            ? HelperFunction.noNullStringText('${value.userData?.info?.name}')
            : userType == 'Teacher'
                ? HelperFunction.noNullStringText('${value.userData?.name}')
                : HelperFunction.noNullStringText('${value.userData?.userName}');

        final String idLabel = userType == 'Student'
            ? 'Roll no.'
            : userType == 'Parent'
                ? 'CNIC no.'
                : 'Emp no.';
        final String idValue = userType == 'Student'
            ? value.studentId.toString()
            : (value.userData?.userName ?? '');

        return Drawer(
          width: MediaQuery.sizeOf(context).width * 0.76,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(
              right: Radius.circular(22),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blue Top Header matching S3b Menu mockup (Left-aligned)
              Container(
                width: double.infinity,
                color: AppColors.blue,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        18,
                        topPad + 18,
                        18,
                        18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Photo with 3px yellow border ring
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: AppColors.yellow,
                              shape: BoxShape.circle,
                            ),
                            child: CustomUserImage(
                              userId: value.userData?.userName ?? '',
                              imageSize: 64,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Display Name (left-aligned)
                          Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppThemes.sora(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // ID Badge Pill (left-aligned)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$idLabel  ',
                                  style: AppThemes.roboto(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white.withValues(alpha: 0.75),
                                  ),
                                ),
                                Text(
                                  idValue,
                                  style: AppThemes.sora(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Circular X Close Button in top-right
                    Positioned(
                      top: topPad + 12,
                      right: 12,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.14),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Drawer Menu Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  children: [
                    _buildDrawerTile(
                      iconType: CityzensIconType.info,
                      title: 'About us',
                      onTap: () {
                        Navigator.of(context).pop();
                        AppNavigation.navigateTo(AppNavRoutes.aboutUsRoute);
                      },
                    ),
                    _buildDrawerTile(
                      iconType: CityzensIconType.feedback,
                      title: 'App feedback',
                      onTap: () {
                        Navigator.of(context).pop();
                        AppNavigation.navigateTo(AppNavRoutes.appFeedbackRoute);
                      },
                    ),
                    if (userType != 'Teacher')
                      _buildDrawerTile(
                        iconType: CityzensIconType.lock,
                        title: 'Change password',
                        onTap: () {
                          Navigator.of(context).pop();
                          AppNavigation.navigateTo(
                            AppNavRoutes.changePasswordRoute,
                          );
                        },
                      ),

                    // Single Divider only above Log out
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 6,
                      ),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFEEF1F5),
                      ),
                    ),

                    _buildDrawerTile(
                      iconType: CityzensIconType.logout,
                      title: 'Log out',
                      isDestructive: true,
                      onTap: () => value.logout(context),
                    ),
                  ],
                ),
              ),

              // Footer App Version (bottom-left aligned)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
                  child: Text(
                    'App version ${AppConstants.appVersion}',
                    style: AppThemes.roboto(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawerTile({
    required CityzensIconType iconType,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Row(
            children: [
              CityzensIcon(
                type: iconType,
                size: 26,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: AppThemes.sora(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                        isDestructive ? const Color(0xFFC42840) : AppColors.ink,
                  ),
                ),
              ),
              if (!isDestructive)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFA0A8B5),
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
