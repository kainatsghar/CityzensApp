import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';

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
    return SizedBox(
        height: imageSize ?? size.width * 0.32,
        width: imageSize ?? size.width * 0.32,
        child: Consumer<LocalDataProvider>(
            builder: (context, value, _) => GestureDetector(
                onTap: disableUploadImage
                    ? null
                    : () => HelperFunction.imagePickerBottomSheet(),
                child: ClipOval(
                  child: FutureBuilder(
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
                                  : Image.asset('images/profile_avatar.png');
                            } else {
                              return Image.asset('images/profile_avatar.png');
                            }
                        }
                      }),
                ))));
  }
}
