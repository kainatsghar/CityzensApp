import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Provider/ClassTestResult/class_test_result_provider.dart';
import 'package:tcs_app/Screens/Teacher/TeacherClassTestResultScreen/test_1.dart';
import 'package:tcs_app/Screens/Teacher/TeacherClassTestResultScreen/test_2.dart';
import 'package:tcs_app/Screens/Teacher/TeacherClassTestResultScreen/test_3.dart';

import '../../CustomWidgets/CustomCoverImage/custom_cover_image.dart';
import '../../Utils/app_colors.dart';

class TestResultComponent extends StatelessWidget {
  const TestResultComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<ClassTestResultProvider>(builder: (context, value, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size.width,
                decoration: const BoxDecoration(),
                child: Column(
                  children: [
                    const CustomCoverImage(
                      title: 'CLASS TEST RESULTS',
                      imagePath: 'class_result_c.png',
                    ),
                    SizedBox(height: size.height * 0.01),
                    Container(
                      width: size.width * 0.9,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10.0),
                      decoration: BoxDecoration(
                          color: AppColors.secondaryColor,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Text(
                        value.selectedSubjectName.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryTitleColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.01),
              DefaultTabController(
                length: 3,
                initialIndex: 0,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: AppColors.whiteColor,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      indicatorColor: AppColors.whiteColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      splashBorderRadius: BorderRadius.circular(16),
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: AppColors.primaryDarkColor),
                      tabs: const [
                        Tab(text: 'TEST 1'),
                        Tab(text: 'TEST 2'),
                        Tab(text: 'TEST 3'),
                      ],
                      indicatorPadding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.5,
                      child: const TabBarView(
                        children: [
                          Test1(),
                          Test2(),
                          Test3(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
