import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/provider/StudentProfile/student_profile_provider.dart';
import 'package:tcs_app/provider/StudentDashboard/student_dashboard_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';

import 'package:tcs_app/utils/helper_function.dart';
import 'package:tcs_app/gen/assets.gen.dart';

class CustomUserImage extends StatelessWidget {
  final bool disableUploadImage;
  final double? imageSize;
  final String userId;
  final bool isMale;

  const CustomUserImage({
    super.key,
    this.disableUploadImage = true,
    this.imageSize,
    required this.userId,
    this.isMale = true,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Consumer<LocalDataProvider>(
      builder: (context, localData, _) {
        final isTeacher = localData.userData?.userType == 'Teacher';
        final imagePath = localData.imagePaths[userId];

        // Lazily cache the image path from shared preferences if not in memory
        if (imagePath == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            localData.cacheImagePath(userId);
          });
        }

        if (isTeacher) {
          // Teacher side: Bypasses student caches entirely.
          return _buildImageStack(context, size, isMale, imagePath);
        }

        // Student/Parent side: Reactively resolve dynamic gender ID.
        return Consumer2<StudentProfileProvider, StudentDashboardProvider>(
          builder: (context, profileProvider, dashboardProvider, _) {
            bool solvedIsMale = isMale;
            int? resolvedGenderId;

            // Check cache in StudentProfileProvider
            final cachedProfile = profileProvider.cachedProfiles[userId];
            if (cachedProfile != null &&
                cachedProfile.profile != null &&
                cachedProfile.profile!.isNotEmpty) {
              resolvedGenderId = cachedProfile.profile!.first.genderId;
            }
            // Check cache in StudentDashboardProvider
            else {
              final dashboardProfile =
                  dashboardProvider.getChildData(userId)?.profile;
              if (dashboardProfile != null &&
                  dashboardProfile.profile != null &&
                  dashboardProfile.profile!.isNotEmpty) {
                resolvedGenderId = dashboardProfile.profile!.first.genderId;
              }
            }

            if (resolvedGenderId != null) {
              if (resolvedGenderId == 2) {
                solvedIsMale = false;
              } else {
                // Male (1) or default fallback is male
                solvedIsMale = true;
              }
            }

            return _buildImageStack(context, size, solvedIsMale, imagePath);
          },
        );
      },
    );
  }

  Widget _buildImageStack(
      BuildContext context, Size size, bool solvedIsMale, String? imagePath) {
    return SizedBox(
      height: imageSize ?? size.width * 0.32,
      width: imageSize ?? size.width * 0.32,
      child: Stack(
        children: [
          Card(
            margin: EdgeInsets.zero,
            elevation: 4,
            shape: const CircleBorder(),
            child: SizedBox(
              height: imageSize ?? size.width * 0.32,
              width: imageSize ?? size.width * 0.32,
              child: ClipOval(
                child: imagePath != null
                    ? Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                      )
                    : _buildProfileAvatar(solvedIsMale),
              ),
            ),
          ),
          Positioned.fromRelativeRect(
            rect: RelativeRect.fromLTRB(
              (imageSize ?? size.width * 0.32) -
                  (imageSize ?? size.width * 0.32) / 4,
              (imageSize ?? size.width * 0.32) -
                  (imageSize ?? size.width * 0.32) / 4,
              0,
              0,
            ),
            child: Visibility(
              visible: !disableUploadImage,
              child: GestureDetector(
                onTap: () => HelperFunction.imagePickerBottomSheet(),
                child: ClipOval(
                  child: Container(
                    height: 36,
                    width: 36,
                    color: AppColors.primaryColor,
                    child: Icon(
                      Icons.camera_alt,
                      color: AppColors.white,
                      size: (imageSize ?? size.width * 0.32) / 7.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(bool solvedIsMale) {
    return Card(
      color: AppColors.purple,
      shape: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 2),
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            ClipOval(
              child: Image.asset(
                solvedIsMale
                    ? Assets.images.profileIcon.path
                    : Assets.images.profileIconFemale.path,
                fit: BoxFit.scaleDown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
