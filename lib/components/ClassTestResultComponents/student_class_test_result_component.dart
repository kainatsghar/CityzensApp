import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_message_image.dart';
import 'package:tcs_app/model/ClassTestResult/student_test_result_list_response.dart';
import 'package:tcs_app/provider/ClassTestResult/class_test_result_provider.dart';

import '../../custom_widgets/CustomCoverImage/custom_cover_image.dart';
import '../../utils/app_colors.dart';

class StudentClassTestResultComponent extends StatelessWidget {
  const StudentClassTestResultComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Consumer<ClassTestResultProvider>(
        builder: (context, value, _) {
          List<SubjectDto>? subjectList =
              value.studentTestResultListResponse!.subjectDto;
          return subjectList!.isEmpty
              ? const ShowMessageOnImage(message: 'No results uploaded')
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const CustomCoverImage(
                        title: 'CLASS TEST RESULTS',
                        imagePath: 'class_result_c.png',
                      ),
                      SizedBox(height: size.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: size.width * 0.25,
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: AppColors.white,
                                  width: 0,
                                ),
                              ),
                            ),
                            child: const Text(
                              'SUBJECT',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryDarkBlue,
                                fontSize: 16,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          Container(
                            width: size.width * 0.21,
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(color: AppColors.grey500, width: 1),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Text(
                                'TEST 1',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDarkBlue,
                                  fontSize: 16,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: size.width * 0.21,
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(color: AppColors.grey500, width: 1),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Text(
                                'TEST 2',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDarkBlue,
                                  fontSize: 16,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: size.width * 0.21,
                            decoration: const BoxDecoration(
                              border: Border(
                                left: BorderSide(color: AppColors.grey500, width: 1),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Text(
                                'TEST 3',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDarkBlue,
                                  fontSize: 16,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...subjectList.map(
                        (e) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 10,
                              ),
                              width: size.width * 0.25,
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                    color: AppColors.white,
                                    width: 0,
                                  ),
                                ),
                              ),
                              child: Text(
                                e.subjectName ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                  fontSize: 16,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 10,
                              ),
                              width: size.width * 0.21,
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: AppColors.grey500,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(
                                  (() {
                                    if (e.categoryDto != null &&
                                        e.categoryDto!.isNotEmpty) {
                                      if (e.categoryDto!.length >= 3) {
                                        if (e.categoryDto![0].categoryId == 1) {
                                          return "${e.categoryDto![0].obtainedMarks}/${e.categoryDto![0].totalMarks}";
                                        } else if (e
                                                .categoryDto![1]
                                                .categoryId ==
                                            1) {
                                          return "${e.categoryDto![1].obtainedMarks}/${e.categoryDto![1].totalMarks}";
                                        } else if (e
                                                .categoryDto![2]
                                                .categoryId ==
                                            1) {
                                          return "${e.categoryDto![2].obtainedMarks}/${e.categoryDto![2].totalMarks}";
                                        }
                                      } else if (e.categoryDto!.length >= 2) {
                                        if (e.categoryDto![0].categoryId == 1) {
                                          return "${e.categoryDto![0].obtainedMarks}/${e.categoryDto![0].totalMarks}";
                                        } else if (e
                                                .categoryDto![1]
                                                .categoryId ==
                                            1) {
                                          return "${e.categoryDto![1].obtainedMarks}/${e.categoryDto![1].totalMarks}";
                                        }
                                      } else if (e.categoryDto!.isNotEmpty) {
                                        if (e.categoryDto![0].categoryId == 1) {
                                          return "${e.categoryDto![0].obtainedMarks}/${e.categoryDto![0].totalMarks}";
                                        }
                                      }
                                    }
                                    return '';
                                  })(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondaryColor,
                                    fontSize: 22,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 10,
                              ),
                              width: size.width * 0.21,
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: AppColors.grey500,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(
                                  (() {
                                    if (e.categoryDto != null &&
                                        e.categoryDto!.isNotEmpty) {
                                      if (e.categoryDto!.length >= 2) {
                                        if (e.categoryDto![0].categoryId == 2) {
                                          return "${e.categoryDto![0].obtainedMarks}/${e.categoryDto![0].totalMarks}";
                                        } else if (e
                                                .categoryDto![1]
                                                .categoryId ==
                                            2) {
                                          return "${e.categoryDto![1].obtainedMarks}/${e.categoryDto![1].totalMarks}";
                                        } else if (e
                                                .categoryDto![2]
                                                .categoryId ==
                                            2) {
                                          return "${e.categoryDto![2].obtainedMarks}/${e.categoryDto![2].totalMarks}";
                                        }
                                      } else if (e.categoryDto!.length >= 2) {
                                        if (e.categoryDto![0].categoryId == 2) {
                                          return "${e.categoryDto![0].obtainedMarks}/${e.categoryDto![0].totalMarks}";
                                        } else if (e
                                                .categoryDto![1]
                                                .categoryId ==
                                            2) {
                                          return "${e.categoryDto![1].obtainedMarks}/${e.categoryDto![1].totalMarks}";
                                        }
                                      } else if (e.categoryDto!.isNotEmpty) {
                                        if (e.categoryDto![0].categoryId == 2) {
                                          return "${e.categoryDto![0].obtainedMarks}/${e.categoryDto![0].totalMarks}";
                                        }
                                      }
                                    }
                                    return '';
                                  })(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondaryColor,
                                    fontSize: 22,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 10,
                              ),
                              width: size.width * 0.21,
                              decoration: const BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    color: AppColors.grey500,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(
                                  (() {
                                    if (e.categoryDto != null &&
                                        e.categoryDto!.isNotEmpty) {
                                      if (e.categoryDto!.length >= 3) {
                                        if (e.categoryDto![0].categoryId == 3) {
                                          return "${e.categoryDto![0].obtainedMarks}/${e.categoryDto![0].totalMarks}";
                                        } else if (e
                                                .categoryDto![1]
                                                .categoryId ==
                                            3) {
                                          return "${e.categoryDto![1].obtainedMarks}/${e.categoryDto![1].totalMarks}";
                                        } else if (e
                                                .categoryDto![2]
                                                .categoryId ==
                                            3) {
                                          return "${e.categoryDto![2].obtainedMarks}/${e.categoryDto![2].totalMarks}";
                                        }
                                      } else if (e.categoryDto!.length >= 2) {
                                        if (e.categoryDto![0].categoryId == 3) {
                                          return "${e.categoryDto![0].obtainedMarks}/${e.categoryDto![0].totalMarks}";
                                        } else if (e
                                                .categoryDto![1]
                                                .categoryId ==
                                            3) {
                                          return "${e.categoryDto![1].obtainedMarks}/${e.categoryDto![1].totalMarks}";
                                        }
                                      } else if (e.categoryDto!.isNotEmpty) {
                                        if (e.categoryDto![0].categoryId == 3) {
                                          return "${e.categoryDto![0].obtainedMarks}/${e.categoryDto![0].totalMarks}";
                                        }
                                      }
                                    }
                                    return '';
                                  })(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.secondaryColor,
                                    fontSize: 22,
                                    letterSpacing: 1,
                                  ),
                                ),

                                // child: Text(
                                //   e.categoryDto!.length <= 1
                                //       ? ''
                                //       : e.categoryDto?[0].categoryId == 3
                                //           ? e.categoryDto![0].obtainedMarks.toString()
                                //           : e.categoryDto?[1].categoryId == 3
                                //               ? e.categoryDto![1].obtainedMarks
                                //                   .toString()
                                //               : e.categoryDto?[2].categoryId == 3
                                //                   ? e.categoryDto![2].obtainedMarks
                                //                       .toString()
                                //                   : '',
                                //   textAlign: TextAlign.center,
                                //   style: const TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       color: AppColors.secondaryColor,
                                //       fontSize: 22,
                                //       letterSpacing: 1),
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
