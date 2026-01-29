import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
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
    return SizedBox(
      height: imageSize ?? size.width * 0.32,
      width: imageSize ?? size.width * 0.32,
      child: Stack(
        children: [
          Card(
            margin: EdgeInsets.zero,
            elevation: 4,
            shape: CircleBorder(),
            child: SizedBox(
              height: imageSize ?? size.width * 0.32,
              width: imageSize ?? size.width * 0.32,
              child: ClipOval(
                child: Consumer<LocalDataProvider>(
                  builder: (context, value, _) => FutureBuilder(
                    future: value.loadImagePath(userId),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Image.asset(
                            isMale
                                ? Assets.images.profileAvatarYellow.path
                                : Assets.images.profileAvatarFemale.path,
                            fit: BoxFit.cover,
                          );
                        default:
                          if (snapshot.hasData) {
                            return snapshot.data != null
                                ? Image.file(
                                    File('${snapshot.data}'),
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    isMale
                                        ? Assets.images.profileAvatarYellow.path
                                        : Assets
                                              .images
                                              .profileAvatarFemale
                                              .path,
                                    fit: BoxFit.cover,
                                  );
                          } else {
                            return Image.asset(
                              isMale
                                  ? Assets.images.profileAvatarYellow.path
                                  : Assets.images.profileAvatarFemale.path,
                              fit: BoxFit.cover,
                            );
                          }
                      }
                    },
                  ),
                ),
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
              visible: disableUploadImage ? false : true,
              child: GestureDetector(
                onTap: () => HelperFunction.imagePickerBottomSheet(),
                child: ClipOval(
                  child: Container(
                    height: 36,
                    width: 36,
                    color: AppColors.primaryColor,
                    child: Icon(
                      Icons.camera_alt,
                      color: AppColors.whiteColor,
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
}
