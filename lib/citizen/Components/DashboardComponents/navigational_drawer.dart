import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          backgroundColor: Colors.white,
          child: Column(
            children: [
              // Blue Top Header (S3b Menu Header)
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.paddingOf(context).top + 12,
                  20,
                  24,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.blue,
                ),
                child: Column(
                  children: [
                    // Close button X on top right
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // User Photo with white border
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CustomUserImage(
                        userId: value.userData?.userName ?? '',
                        imageSize: 76,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Display Name
                    Text(
                      displayName,
                      textAlign: TextAlign.center,
                      style: AppThemes.sora(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // ID Badge Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$idLabel ',
                            style: AppThemes.roboto(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                          Text(
                            idValue,
                            style: AppThemes.sora(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Drawer List Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    _buildDrawerTile(
                      icon: Icons.info_outline_rounded,
                      title: 'About us',
                      onTap: () {
                        Navigator.of(context).pop();
                        AppNavigation.navigateTo(AppNavRoutes.aboutUsRoute);
                      },
                    ),
                    const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: AppColors.line,
                    ),
                    _buildDrawerTile(
                      icon: Icons.feedback_outlined,
                      title: 'App feedback',
                      onTap: () {
                        Navigator.of(context).pop();
                        AppNavigation.navigateTo(AppNavRoutes.appFeedbackRoute);
                      },
                    ),
                    if (userType != 'Teacher') ...[
                      const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: AppColors.line,
                      ),
                      _buildDrawerTile(
                        icon: Icons.lock_outline_rounded,
                        title: 'Change password',
                        onTap: () {
                          Navigator.of(context).pop();
                          AppNavigation.navigateTo(
                            AppNavRoutes.changePasswordRoute,
                          );
                        },
                      ),
                    ],
                    const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: AppColors.line,
                    ),
                    _buildDrawerTile(
                      icon: Icons.logout_rounded,
                      title: 'Log out',
                      isDestructive: true,
                      onTap: () => value.logout(context),
                    ),
                  ],
                ),
              ),

              // Footer App Version
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 8),
                child: Text(
                  'App version ${AppConstants.appVersion}',
                  style: AppThemes.roboto(
                    fontSize: 12,
                    color: AppColors.muted,
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
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final Color itemColor = isDestructive ? AppColors.red : AppColors.ink;
    final Color iconColor = isDestructive ? AppColors.red : AppColors.blue;

    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDestructive
              ? AppColors.red.withValues(alpha: 0.1)
              : AppColors.blueTint,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: AppThemes.sora(
          fontSize: 14,
          fontWeight: isDestructive ? FontWeight.w700 : FontWeight.w600,
          color: itemColor,
        ),
      ),
      trailing: isDestructive
          ? null
          : const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.muted,
              size: 20,
            ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      onTap: onTap,
    );
  }
}
