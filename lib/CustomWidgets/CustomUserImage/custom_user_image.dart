import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';

import 'package:tcs_app/Utils/helper_function.dart';

class CustomUserImage extends StatelessWidget {
  final bool disableUploadImage;
  final double imageSize;
  final String userId;

  const CustomUserImage(
      {Key key, this.disableUploadImage = true, this.imageSize, this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ClipOval(
      child: SizedBox(
          height: imageSize ?? size.width * 0.32,
          width: imageSize ?? size.width * 0.32,
          child: Consumer<LocalDataProvider>(
              builder: (context, value, _) => Stack(
                    children: [
                      FutureBuilder(
                          future: value.loadImagePath(userId),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return const CustomLoader();
                              default:
                                if (snapshot.hasData) {
                                  return snapshot.data != null
                                      ? Image.file(File(snapshot.data),
                                          fit: BoxFit.cover)
                                      : Image.asset(
                                          'images/profile_avatar.png',
                                          fit: BoxFit.cover,
                                        );
                                } else {
                                  return Image.asset(
                                      'images/profile_avatar.png',
                                      fit: BoxFit.cover);
                                }
                            }
                          }),
                      Visibility(
                        visible: disableUploadImage ? false : true,
                        child: Positioned(
                            bottom: 0,
                            right: 0,
                            child: ClipOval(
                              child: Container(
                                height: 35,
                                width: 35,
                                color: AppColors.primaryColor,
                                child: GestureDetector(
                                  onTap: () =>
                                      HelperFunction.imagePickerBottomSheet(),
                                  child: Icon(Icons.camera_alt,
                                      color: AppColors.whiteColor, size: 20.0),
                                ),
                              ),
                            )),
                      )
                    ],
                  ))),
    );
  }
}
