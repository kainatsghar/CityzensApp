import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';

import 'package:tcs_app/Utils/helper_function.dart';

class CustomUserImage extends StatelessWidget {
  final bool disableUploadImage;
  final double? imageSize;
  final String userId;

  const CustomUserImage({
    super.key,
    this.disableUploadImage = true,
    this.imageSize,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      elevation: 8,
      shape: CircleBorder(),
      child: Stack(
        children: [
          ClipOval(
            child: SizedBox(
              height: imageSize ?? size.width * 0.32,
              width: imageSize ?? size.width * 0.32,
              child: Consumer<LocalDataProvider>(
                builder: (context, value, _) => FutureBuilder(
                  future: value.loadImagePath(userId),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Image.asset(
                          'images/profile_avatar_yellow.png',
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
                                  'images/profile_avatar_yellow.png',
                                  fit: BoxFit.cover,
                                );
                        } else {
                          return Image.asset(
                            'images/profile_avatar_yellow.png',
                            fit: BoxFit.cover,
                          );
                        }
                    }
                  },
                ),
              ),
            ),
          ),
          FractionalTranslation(
            translation: const Offset(2.6, 2.6),
            child: Visibility(
              visible: disableUploadImage ? false : true,
              child: ClipOval(
                child: Container(
                  height: 35,
                  width: 35,
                  color: AppColors.primaryColor,
                  child: GestureDetector(
                    onTap: () => HelperFunction.imagePickerBottomSheet(),
                    child: const Icon(
                      Icons.camera_alt,
                      color: AppColors.whiteColor,
                      size: 20.0,
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
