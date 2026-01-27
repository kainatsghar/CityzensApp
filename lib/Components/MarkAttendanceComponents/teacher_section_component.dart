import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/custom_widgets/CustomCard/custom_card.dart';
import 'package:tcs_app/custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/custom_widgets/TabSelector/tab_selector.dart';
import 'package:tcs_app/Provider/Dashboard/dashboard_provider.dart';
import 'package:tcs_app/Provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/model/TeacherSection/teacher_section_response.dart';
import 'package:tcs_app/Model/SectionSubject/section_subject_response.dart';

import '../../custom_widgets/CustomLogoCover/custom_logo_cover.dart';
import '../../Utils/app_colors.dart';

class TeacherSectionComponent extends StatelessWidget {
  const TeacherSectionComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer2<MarkAttendanceProvider, DashboardProvider>(
      builder: (context, attendanceValue, dashboardValue, _) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              children: <Widget>[
                const CustomLogoCover(),
                SizedBox(height: size.height * 0.03),
                CustomCard(
                  child: Form(
                    key: attendanceValue.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                          hintText: HelperFunction.dateFormatter(
                            '${DateTime.now()}',
                          ),
                          isEnable: false,
                          readOnly: true,
                          prefixIcon: Icons.date_range,
                        ),
                        SizedBox(height: size.height * 0.02),
                        const Text(
                          'Select Section',
                          style: TextStyle(
                            color: AppColors.primaryDarkColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        TabSelector<Section>(
                          items: dashboardValue.getSectionsWithDiary(false),
                          getDisplayText: (section) => section.name ?? 'N/A',
                          onItemSelected: (section) {
                            attendanceValue.sectionController.text =
                                section.name ?? '';
                            attendanceValue.setClassId(section.classId ?? 0);
                            attendanceValue.setSectionId(
                              section.classSectionId ?? 0,
                            );
                            // Reset subject selection when section changes
                            attendanceValue.subjectController.clear();
                            attendanceValue.setSubjectId(null, null);
                          },
                          initialItemName:
                              attendanceValue.sectionController.text,
                        ),
                        Visibility(
                          visible:
                              attendanceValue.classId == 19 ||
                              attendanceValue.classId == 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: size.height * 0.02),
                              const Text(
                                'Select Subject',
                                style: TextStyle(
                                  color: AppColors.primaryDarkColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: size.height * 0.01),
                              TabSelector<SectionSubject>(
                                key: ValueKey(attendanceValue.sectionId),
                                items: dashboardValue.getSubjectsForSection(
                                  classSectionId:
                                      attendanceValue.sectionId ?? 0,
                                  isDiary: false,
                                ),
                                getDisplayText: (subject) =>
                                    subject.subjectName ?? 'N/A',
                                onItemSelected: (subject) {
                                  attendanceValue.setSubjectId(
                                    subject.subjectId,
                                    subject.subjectName,
                                  );
                                },
                                initialItemName:
                                    attendanceValue.subjectController.text,
                              ),

                              //       CustomTextFormField(
                              //   hintText: 'Select Section',
                              //   controller: value.sectionController,
                              //   onTap: () => value.sectionBottomSheet(),
                              //   readOnly: true,
                              //   validator: HelperFunction.validator,
                              //   suffixWidget: const ImageIcon(
                              //     AssetImage('assets/images/dropdown_icon.png'),
                              //     color: AppColors.whiteColor,
                              //   ),
                              // ),
                              // Visibility(
                              //   visible: value.classId == 19 || value.classId == 20,
                              //   child: Column(
                              //     children: [
                              //       SizedBox(height: size.height * 0.02),
                              //       CustomTextFormField(
                              //         hintText: 'Select Subject',
                              //         controller: value.subjectController,
                              //         onTap: () => value.subjectBottomSheet(),
                              //         readOnly: true,
                              //         validator: HelperFunction.validator,
                              //         suffixWidget: const ImageIcon(
                              //           AssetImage('assets/images/dropdown_icon.png'),
                              //           color: AppColors.whiteColor,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                CustomAppButton(
                  buttonTitle: 'Next',
                  onTap: () => attendanceValue.navigateToMarkAttendance(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
