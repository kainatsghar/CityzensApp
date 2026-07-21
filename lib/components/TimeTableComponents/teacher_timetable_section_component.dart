// === UPDATED FILE: teacher_timetable_section_component.dart ===
// Modernized: Premium selection card, improved spacing, consistent typography,
// and smooth layout using the latest design system components.
import 'package:animate_do/animate_do.dart';
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
      physics: const BouncingScrollPhysics(),
      child: Consumer2<TimeTableProvider, DashboardProvider>(
        builder: (context, value, dashboardValue, _) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            child: Column(
              children: <Widget>[
                // ── Animated Header ──
                FadeInDown(
                  duration: const Duration(milliseconds: 400),
                  child: const CustomLogoCover(),
                ),
                SizedBox(height: size.height * 0.04),

                // ── Section Selection Card ──
                FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 400),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: CustomCard(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.layers_outlined,
                                  size: 18,
                                  color: AppColors.primaryBlue.withValues(alpha: 0.7),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Select Your Class & Section',
                                  style: TextStyle(
                                    color: AppColors.primaryDarkBlue,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TabSelector<Section>(
                              items: dashboardValue.getSectionsWithDiary(false),
                              getDisplayText: (section) =>
                                  section.name ?? 'N/A',
                              onItemSelected: (section) {
                                value.sectionController.text =
                                    section.name ?? '';
                                value.setClassId(section.classId ?? 0);
                                value.setSectionId(section.classSectionId ?? 0);
                              },
                              initialItemName: value.sectionController.text,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.04),

                // ── Navigation Action ──
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: CustomAppButton(
                    buttonTitle: 'Continue to Timetable',
                    onTap: () => value.navigateToMarkTimeTable(),
                  ),
                ),
                SizedBox(height: size.height * 0.04),
              ],
            ),
          );
        },
      ),
    );
  }
}
