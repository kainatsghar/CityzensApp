import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomCard/custom_card.dart';
import 'package:tcs_app/custom_widgets/TabSelector/tab_selector.dart';
import 'package:tcs_app/model/TeacherSection/teacher_section_response.dart';
import 'package:tcs_app/model/SectionSubject/section_subject_response.dart';

import '../../custom_widgets/CustomAppButton/custom_app_button.dart';
import '../../custom_widgets/CustomCoverImage/custom_cover_image.dart';
import '../../provider/ClassTestResult/class_test_result_provider.dart';
import '../../provider/Dashboard/dashboard_provider.dart';
import '../../utils/app_colors.dart';

class TeacherAddClassResultComponent extends StatelessWidget {
  const TeacherAddClassResultComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Consumer2<ClassTestResultProvider, DashboardProvider>(
        builder: (context, value, dashboardValue, _) {
          return Column(
            children: [
              const CustomCoverImage(
                title: 'CLASS TEST RESULTS',
                imagePath: 'class_result_c.png',
              ),
              SizedBox(height: size.height * 0.03),
              CustomCard(
                child: Form(
                  key: value.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Section',
                        style: TextStyle(
                          color: AppColors.primaryDarkBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                        width: double.maxFinite,
                      ),
                      TabSelector<Section>(
                        items: dashboardValue.getSectionsWithDiary(true),
                        getDisplayText: (section) => section.name ?? 'N/A',
                        onItemSelected: (section) {
                          value.sectionController.text = section.name ?? '';
                          value.setSectionId(section.classSectionId ?? 0);
                          // Reset subject when section changes
                          value.subjectController.clear();
                          value.setSubjectId(null, null);
                        },
                        initialItemName: value.sectionController.text,
                      ),
                      SizedBox(height: size.height * 0.02),
                      const Text(
                        'Select Subject',
                        style: TextStyle(
                          color: AppColors.primaryDarkBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      TabSelector<SectionSubject>(
                        key: ValueKey(value.sectionId),
                        items: dashboardValue.getSubjectsForSection(
                          classSectionId: value.sectionId ?? 0,
                          isDiary: true,
                        ),
                        getDisplayText: (subject) =>
                            subject.subjectName ?? 'N/A',
                        onItemSelected: (subject) {
                          value.setSubjectId(
                            subject.subjectId,
                            subject.subjectName,
                          );
                        },
                        initialItemName: value.subjectController.text,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              CustomAppButton(
                buttonTitle: 'Next',
                onTap: () => {value.navigateToAddClassResult()},
              ),
            ],
          );
        },
      ),
    );
  }
}
