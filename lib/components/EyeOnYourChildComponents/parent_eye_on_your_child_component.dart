import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_message_image.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../custom_widgets/CustomCoverImage/custom_cover_image.dart';
import '../../provider/EyeOnYourChild/eye_on_your_child_provider.dart';

class ParentEyeOnYourChildComponent extends StatefulWidget {
  const ParentEyeOnYourChildComponent({super.key});

  @override
  State<ParentEyeOnYourChildComponent> createState() =>
      _ParentEyeOnYourChildComponentState();
}

class _ParentEyeOnYourChildComponentState
    extends State<ParentEyeOnYourChildComponent> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final double itemHeight = (size.height - kToolbarHeight - 24) / 6;
    final double itemWidth = size.width / 2;
    return Consumer<EyeOnYourChildProvider>(
      builder: (context, value, _) {
        var responseData = value.parentEyeOnChildResponse;

        String formattedDate = DateFormat(
          "dd'TH' MMMM yyyy",
        ).format(DateTime.now());

        return responseData!.fileList!.isEmpty
            ? const ShowMessageOnImage(message: 'No Activity\nData Uploaded')
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const CustomCoverImage(
                        title: 'EYE ON YOUR CHILD',
                        imagePath: 'location.png',
                      ),
                      SizedBox(height: size.height * 0.01),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                        child: Column(
                          children: [
                            SizedBox(height: size.height * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: size.width * 0.43,
                                  child: Card(
                                    color: AppColors.secondaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    child: const Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'UPDATE',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                                SizedBox(
                                  width: size.width * 0.43,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                    color: const Color.fromARGB(
                                      255,
                                      220,
                                      220,
                                      220,
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        formattedDate,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.01),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (value
                                .parentEyeOnChildResponse!
                                .fileList!
                                .isNotEmpty)
                              Text(
                                value
                                        .parentEyeOnChildResponse!
                                        .fileList![0]
                                        .studentUpdate ??
                                    '',
                                style: const TextStyle(fontSize: 22),
                                textAlign: TextAlign.start,
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 20,
                        ),
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: (itemWidth / itemHeight),
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(value.imagePaths!.length, (
                            index,
                          ) {
                            final imagePath = value.imagePaths![index];
                            if (imagePath.trim().isNotEmpty) {
                              return CachedNetworkImage(
                                imageUrl: imagePath,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const SizedBox(),
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
