import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Components/TimeTableComponents/teacher_timetable_component.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/citizen/Provider/TimeTable/timetable_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/cityzens_back_button.dart';

class TeacherTimeTableScreen extends StatefulWidget {
  const TeacherTimeTableScreen({super.key});

  @override
  State<TeacherTimeTableScreen> createState() => _TeacherTimeTableScreenState();
}

class _TeacherTimeTableScreenState extends State<TeacherTimeTableScreen> {
  late Future timetableRecords;

  TimeTableProvider get provider =>
      Provider.of<TimeTableProvider>(AppNavigation.currentContext!,
          listen: false);

  @override
  void initState() {
    timetableRecords = provider.loadTimeTable();
    super.initState();
  }

  @override
  void dispose() {
    provider.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: Column(
        children: [
          // Blue Header (S5 Student: back + title; T4 Teacher: + selected CLASS pill)
          Consumer<TimeTableProvider>(
            builder: (context, prov, _) {
              final bool isTeacher =
                  prov.localDataProvider.userData?.userType == 'Teacher';
              final bool showClassBanner =
                  isTeacher && prov.sectionController.text.isNotEmpty;

              return Container(
                width: double.infinity,
                color: AppColors.blue,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          8,
                          16,
                          showClassBanner ? 10 : 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CityzensBackButton(
                              size: 40,
                              onTap: () => Navigator.of(context).maybePop(),
                            ),
                            Text(
                              'Timetable',
                              style: AppThemes.sora(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 40, height: 40),
                          ],
                        ),
                      ),
                      if (showClassBanner)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.13),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'CLASS',
                                  style: AppThemes.roboto(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.6,
                                    color:
                                        Colors.white.withValues(alpha: 0.72),
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  prov.sectionController.text,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppThemes.sora(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Body (FutureBuilder with Timetable Grid)
          Expanded(
            child: FutureBuilder(
              future: timetableRecords,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CustomLoader());
                  default:
                    if (snapshot.hasData) {
                      return const TeacherTimeTableComponent();
                    } else {
                      return ShowError(errorText: '${snapshot.error}');
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
