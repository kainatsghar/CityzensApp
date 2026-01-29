import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/utils/app_colors.dart';

import '../../custom_widgets/CustomAppButton/custom_app_button.dart';
import '../../custom_widgets/CustomCoverImage/custom_cover_image.dart';
import '../../custom_widgets/ShowCustomMessage/show_custom_message.dart';
import '../../provider/EyeOnYourChild/eye_on_your_child_provider.dart';
import '../../utils/app_constants.dart';

class EyeOnYourChildComponent extends StatefulWidget {
  const EyeOnYourChildComponent({super.key});

  @override
  State<EyeOnYourChildComponent> createState() =>
      _EyeOnYourChildComponentState();
}

class _EyeOnYourChildComponentState extends State<EyeOnYourChildComponent> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<EyeOnYourChildProvider>(
      builder: (context, value, _) {
        var responseData = value.eyeOnChildResponse;
        // var update = [
        //   'Just took a nap!',
        //   'Enjoyed lunch today!',
        //   'Had a great play time!',
        //   'Learnt something new!',
        //   'Is feeling happy today!',
        //   'Reached a milestone!',
        //   'Is feeling sleepy now!',
        //   'Is learning through play!',
        //   'Made new friends today!',
        //   'Enjoyed storytime!'
        // ];

        // var childs = ['Nafay Ali', 'Zainab Fahad', 'Aun Saif'];

        return responseData == null
            ? const ShowCustomMessage(message: AppConstants.noRecordFound)
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                    key: value.formKey,
                    child: Column(
                      children: [
                        const CustomCoverImage(
                          title: 'EYE ON YOUR CHILD',
                          imagePath: 'location.png',
                        ),
                        SizedBox(height: size.height * 0.01),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 10.0,
                            left: 10.0,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: size.height * 0.02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          const Text(
                                            ' Select update to send',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.blackColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: size.height * 0.01),
                                          Container(
                                            height:
                                                2, // Set the height of the divider
                                            width:
                                                size.width *
                                                0.4, // Set the width of the divider
                                            color: AppColors.primaryColor,
                                          ),
                                          Transform.translate(
                                            offset: const Offset(
                                              0,
                                              -12,
                                            ), // Adjust this value as needed
                                            child: const Icon(
                                              Icons.arrow_drop_down_sharp,
                                              size: 32,
                                              color: AppColors
                                                  .primaryColor, // Set the color of the arrow
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        '       Select child             ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.blackColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      Container(
                                        height:
                                            2, // Set the height of the divider
                                        width:
                                            size.width *
                                            0.4, // Set the width of the divider
                                        color: AppColors.primaryColor,
                                      ),
                                      Transform.translate(
                                        offset: const Offset(
                                          0,
                                          -12,
                                        ), // Adjust this value as needed
                                        child: const Icon(
                                          Icons.arrow_drop_down_sharp,
                                          size: 32,
                                          color: AppColors
                                              .primaryColor, // Set the color of the arrow
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 0.0,
                            right: 5.0,
                            left: 5.0,
                          ),
                          child: SizedBox(
                            height: size.height * 0.41,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            size.width *
                                            0.45, // Set the width of the selection card
                                        child: ListView.builder(
                                          physics:
                                              const ClampingScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemCount: responseData
                                              .studentUpdateDetails
                                              ?.length,
                                          itemBuilder: (_, index) {
                                            final updates = responseData
                                                .studentUpdateDetails?[index];
                                            return SizedBox(
                                              height: size.height * 0.04,
                                              child: GestureDetector(
                                                onTap: () {
                                                  value.setSelectedUpdate(
                                                    updates.updateName ?? '',
                                                    updates.id ?? 0,
                                                  );
                                                },
                                                child: Card(
                                                  color:
                                                      value.selectedUpdate ==
                                                          updates!.updateName
                                                              .toString()
                                                      ? AppColors
                                                            .primaryDarkColor
                                                      : AppColors
                                                            .primaryLightBlue,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  elevation: 2,
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      updates.updateName ?? '',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            value.selectedUpdate ==
                                                                updates
                                                                    .updateName
                                                                    .toString()
                                                            ? AppColors
                                                                  .whiteColor
                                                            : AppColors
                                                                  .blackColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.47,
                                        // height: size.height * 0.41,
                                        child: ListView.builder(
                                          physics:
                                              const ClampingScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          // shrinkWrap: true,
                                          itemCount: responseData
                                              .studentDetails
                                              ?.length,
                                          itemBuilder: (_, index) {
                                            final child = responseData
                                                .studentDetails?[index];
                                            return SizedBox(
                                              height: size.height * 0.04,
                                              child: GestureDetector(
                                                onTap: () {
                                                  value.setSelectedChild(
                                                    child.studentName ?? '',
                                                    child.studentId ?? 0,
                                                  );
                                                },
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  elevation: 0,
                                                  // ignore: unrelated_type_equality_checks
                                                  color:
                                                      value.selectedChild ==
                                                          child!.studentName
                                                      ? AppColors
                                                            .primaryDarkColor
                                                      : const Color.fromARGB(
                                                          255,
                                                          212,
                                                          210,
                                                          210,
                                                        ),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8.0,
                                                            ),
                                                        child: Text(
                                                          child.studentName
                                                              .toString()
                                                              .trim(),
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            // ignore: unrelated_type_equality_checks
                                                            color:
                                                                value.selectedChild ==
                                                                    child
                                                                        .studentName
                                                                ? AppColors
                                                                      .whiteColor
                                                                : AppColors
                                                                      .blackColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        //if(responseData.studentDetails!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 1.0),
                          child: responseData.studentDetails!.isNotEmpty
                              ? const Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start, // Added
                                  children: [
                                    Text(
                                      'Upload photos (for all) (maximum 3)',
                                      style: TextStyle(fontSize: 16),
                                      textAlign: TextAlign
                                          .start, // Added textAlign property
                                    ),
                                  ],
                                )
                              : null,
                        ),
                        SizedBox(height: size.height * 0.01),
                        Stack(
                          children: [
                            Positioned(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: value.files.isNotEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: value.files.length,
                                            itemBuilder: (context, index) {
                                              // Check if the index is valid and if the file exists at that index
                                              if (index < value.files.length) {
                                                File? file = value
                                                    .files[index]; // Get the file at the current index
                                                if (file != null) {
                                                  return SizedBox(
                                                    width: size.width * 0.45,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            left: 6,
                                                          ),
                                                      child: Card(
                                                        elevation: 2,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: Center(
                                                            child: Text(
                                                              file.path
                                                                  .split('/')
                                                                  .last,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                              // If the index is invalid or the file is null, return an empty SizedBox
                                              return const SizedBox();
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 10,
                                              top: 10,
                                            ),
                                            child:
                                                responseData
                                                    .studentDetails!
                                                    .isNotEmpty
                                                ? InkWell(
                                                    onTap: () => value
                                                        .uploadAttachment(),
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                        shape:
                                                            BoxShape.rectangle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              8.0,
                                                            ),
                                                        child: Image.asset(
                                                          'assets/images/attachment.png',
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          SizedBox(height: size.height * 0.01),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            child:
                                                responseData
                                                    .studentDetails!
                                                    .isNotEmpty
                                                ? const Text(
                                                    'UPLOAD\nATTACHMENT',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                      fontSize: 10,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  )
                                                : null,
                                          ),
                                        ],
                                      )
                                    : Center(
                                        child:
                                            responseData
                                                .studentDetails!
                                                .isNotEmpty
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                          right: 10,
                                                        ),
                                                    child: InkWell(
                                                      onTap: () => value
                                                          .uploadAttachment(),
                                                      child: Container(
                                                        height: 40,
                                                        width: 40,
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8,
                                                              ),
                                                          shape: BoxShape
                                                              .rectangle,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8.0,
                                                              ),
                                                          child: Image.asset(
                                                            'assets/images/attachment.png',
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: size.height * 0.01,
                                                  ),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                      right: 10,
                                                    ),
                                                    child: Text(
                                                      'UPLOAD\nATTACHMENT',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.grey,
                                                        fontSize: 10,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : null,
                                      ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: size.height * 0.01),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: responseData.studentDetails!.isNotEmpty
                              ? CustomAppButton(
                                  buttonTitle: 'SAVE',
                                  onTap: () => {value.submitEyeOnChildRecord()},
                                )
                              : null,
                        ),
                        SizedBox(height: size.height * 0.01),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}
