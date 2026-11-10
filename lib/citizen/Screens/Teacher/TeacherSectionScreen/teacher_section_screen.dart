import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Components/MarkAttendanceComponents/mark_attendance_header.dart';
import 'package:tcs_app/citizen/Components/MarkAttendanceComponents/student_list_component.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/citizen/Provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class TeacherSectionScreen extends StatefulWidget {
  const TeacherSectionScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return TeacherSectionScreenState();
  }
}

class TeacherSectionScreenState extends State<TeacherSectionScreen> {
  late Future<bool> _initAttendanceFuture;

  MarkAttendanceProvider get provider => Provider.of<MarkAttendanceProvider>(
        AppNavigation.currentContext!,
        listen: false,
      );

  @override
  void initState() {
    super.initState();
    _initAttendanceFuture = _initSectionsAndStudents();
  }

  Future<bool> _initSectionsAndStudents() async {
    final sectionResponse = await provider.loadSections();
    final sections = sectionResponse.section ?? [];
    if (sections.isNotEmpty) {
      final first = sections.first;
      provider.sectionId = first.classSectionId;
      provider.classId = first.classId;
      provider.sectionController.text = first.name ?? '';

      if (first.classId == 19 || first.classId == 20) {
        final subjResp = await provider.loadSubjects();
        final subjList = subjResp.sectionSubject ?? [];
        if (subjList.isNotEmpty) {
          provider.subjectId = subjList.first.subjectId ?? 0;
          provider.subjectController.text = subjList.first.subjectName ?? '';
        }
      }
      await provider.loadStudentList();
    }
    return true;
  }

  @override
  void dispose() {
    provider.clearClassSectionData();
    provider.clearAttendanceData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: Column(
        children: [
          // T2 Blue Header with Circular Back Button & Class Picker
          const MarkAttendanceHeader(),

          // Body (FutureBuilder loading sections & initial student list)
          Expanded(
            child: FutureBuilder<bool>(
              future: _initAttendanceFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CustomLoader());
                  default:
                    if (snapshot.hasData) {
                      return const StudentListComponent();
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
