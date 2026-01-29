import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/custom_widgets/CustomCard/custom_card.dart';
import 'package:tcs_app/model/TeacherSection/teacher_section_response.dart';
import 'package:tcs_app/provider/Dashboard/dashboard_provider.dart';

import '../../custom_widgets/CustomLogoCover/custom_logo_cover.dart';
import '../../custom_widgets/TabSelector/tab_selector.dart';
import '../../provider/TimeTable/timetable_provider.dart';
import '../../utils/app_colors.dart';

class TeacherTimeTableSectionComponent extends StatelessWidget {
  const TeacherTimeTableSectionComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SingleChildScrollView(
      child: Consumer2<TimeTableProvider, DashboardProvider>(
        builder: (context, value, dashboardValue, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              children: <Widget>[
                const CustomLogoCover(),
                SizedBox(height: size.height * 0.03),
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Section',
                        style: TextStyle(
                          color: AppColors.primaryDarkColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                        width: double.maxFinite,
                      ),
                      TabSelector<Section>(
                        items: dashboardValue.getSectionsWithDiary(false),
                        getDisplayText: (section) => section.name ?? 'N/A',
                        onItemSelected: (section) {
                          value.sectionController.text = section.name ?? '';
                          value.setClassId(section.classId ?? 0);
                          value.setSectionId(section.classSectionId ?? 0);
                        },
                        initialItemName: value.sectionController.text,
                      ),
                    ],
                  ),
                ),
                // CustomCard(
                //   child: Form(
                //     key: value.formKey,
                //     child: Column(
                //       children: [
                //         CustomTextFormField(
                //           hintText: 'Select Section',
                //           controller: value.sectionController,
                //           onTap: () => value.sectionBottomSheet(),
                //           readOnly: true,
                //           validator: HelperFunction.validator,
                //           suffixWidget: const ImageIcon(
                //             AssetImage('assets/images/dropdown_icon.png'),
                //             color: AppColors.whiteColor,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                SizedBox(height: size.height * 0.03),
                CustomAppButton(
                  buttonTitle: 'Next',
                  onTap: () => value.navigateToMarkTimeTable(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
