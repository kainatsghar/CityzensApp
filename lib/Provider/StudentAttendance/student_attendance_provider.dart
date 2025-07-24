// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
// import 'package:tcs_app/CustomWidgets/CustomBottomSheets/custom_filter_bottom_sheet.dart';
import 'package:tcs_app/CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';
// import 'package:tcs_app/Model/StudentAttendance/student_alevel_attendance_subjects_response.dart';
// import 'package:tcs_app/model/Options/options.dart';
import 'package:tcs_app/Model/StudentAttendance/attendance_percentage_response.dart';
import 'package:tcs_app/Model/StudentAttendance/student_attendance_response.dart';
// import 'package:tcs_app/Routes/app_navigation_routes.dart';
// import 'package:tcs_app/Services/Attendance/attendance_subjects_service.dart';
import 'package:tcs_app/Services/AttendancePercentage/attendance_percentage_service.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';

import '../../Model/StudentAttendance/save_attendance_request.dart';
// import '../../Routes/app_navigation.dart';
import '../../Services/StudentAttendance/student_attendance_service.dart';
import '../LocalData/local_data_provider.dart';

class StudentAttendanceProvider with ChangeNotifier {
  //for student_attendance_subject_component
//
  // final subjectController = TextEditingController();
  // final formKey = GlobalKey<FormState>();
  // int selectedSubject = 0;

  // List<SubjectsDtos> subjects = [];
//\\

  StudentAttendanceResponse? studentAttendanceResponse;
  AttendancePercentageResponse? attendancePercentage;

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
      AppNavigation.currentContext!,
      listen: false);

//
  // void setResponse(AttendanceSubjectsResponse? listResponse) {
  //   subjects = listResponse?.subjectsDtos ?? [];
  //   notifyListeners();
  // }

  // Future<AttendanceSubjectsResponse> loadAttendanceSubjects() async {
  //   try {
  //     AttendanceSubjectsResponse response =
  //         await AttendanceSubjectsService.attendanceSubjectsRequest(
  //             userName: localDataProvider.studentId);
  //     setResponse(response);
  //     return response;
  //   } catch (ex) {
  //     throw ex;
  //   }
  // }

  // void subjectBottomSheet() {
  //   showModalBottomSheet(
  //       context: AppNavigation.currentContext!,
  //       backgroundColor: Colors.transparent,
  //       builder: (BuildContext bc) => CustomFilterBottomSheet(
  //           title: 'Subject',
  //           controller: subjectController,
  //           filterOptions: List.generate(
  //               subjects.length,
  //               (i) => Options(
  //                   title: subjects[i].subjectName,
  //                   value: subjects[i].subjectId)),
  //           onSelect: (v) => setSelectedSubject(v)));
  // }

  // void setSelectedSubject(String v) {
  //   selectedSubject =
  //       subjects.singleWhere((e) => e.subjectName == v).subjectId!;
  //   subjectController.text = v;
  //   AppNavigation.goBack();
  //   notifyListeners();
  // }

  //

  void setAttendanceData(StudentAttendanceResponse response) {
    studentAttendanceResponse = response;
    setEventsOnCalender();
    notifyListeners();
  }

  void setAttendancePercentage(AttendancePercentageResponse response) {
    attendancePercentage = response;
    notifyListeners();
  }

  List<AttendanceGraph> pieData = [];

  DateTime selectedDate = DateTime.now();

  List<MonthlyAttendance> absentDates = [];
  List<MonthlyAttendance> presentDates = [];
  List<MonthlyAttendance> leaveDates = [];

  Map<DateTime, List<Event>> studentAttendance = {};

  void setEventsOnCalender() {
    studentAttendance.clear();
    // ignore: prefer_collection_literals
    final sets = Set();
    presentDates = studentAttendanceResponse!.monthlyAttendance!
        .where((e) => e.attnTypeId == 1)
        .toList();
    presentDates.forEach(
        (data) => studentAttendance[DateTime.parse('${data.attnDate}Z')] = [
              Event(
                  title: 'Attendance',
                  attendance: 'Present',
                  color: AppColors.successGreenColor,
                  dateTime: DateTime.parse(data.attnDate!),
                  studentId: localDataProvider.studentId,
                  studentName: localDataProvider.userData!.info!.name)
            ]);
    absentDates = studentAttendanceResponse!.monthlyAttendance!
        .where((e) => e.attnTypeId == 2)
        .toList();
    absentDates.forEach(
        (data) => studentAttendance[DateTime.parse('${data.attnDate}Z')] = [
              Event(
                  title: 'Attendance',
                  attendance: 'Absent',
                  color: AppColors.valuesRedColors,
                  dateTime: DateTime.parse(data.attnDate!),
                  studentId: localDataProvider.studentId,
                  studentName: localDataProvider.userData!.name)
            ]);
    leaveDates = studentAttendanceResponse!.monthlyAttendance!
        .where((e) => e.attnTypeId == 3)
        .toList();
    leaveDates.forEach(
        (data) => studentAttendance[DateTime.parse('${data.attnDate}Z')] = [
              Event(
                  title: 'Attendance',
                  attendance: 'Leave',
                  color: Colors.amber.withOpacity(0.9),
                  dateTime: DateTime.parse(data.attnDate!),
                  studentId: localDataProvider.studentId,
                  studentName: localDataProvider.userData!.name)
            ]);
    presentDates.retainWhere((e) => sets.add(e.attnDate));
    absentDates.retainWhere((e) => sets.add(e.attnDate));
    leaveDates.retainWhere((e) => sets.add(e.attnDate));
    generateAttendanceGraph();
  }

  List<Event> getAttendance(DateTime dateTime) =>
      studentAttendance[dateTime] ?? [];

  String attendanceDate = DateFormat('yyyyMM').format(DateTime.now());

  Future<StudentAttendanceResponse> loadAttendance({DateTime? date}) async {
    try {
      StudentAttendanceResponse response =
          await StudentAttendanceService.studentAttendanceRequest(
              tokenId: localDataProvider.userData!.tokenId!,
              attendanceDate:
                  DateFormat('yyyyMM').format(date ?? DateTime.now()),
              userName: localDataProvider.studentId);
      setAttendanceData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<AttendancePercentageResponse> getAttendancePercentage() async {
    try {
      AttendancePercentageResponse response =
          await AttendancePercentageService.attendancePercentage(
              tokenId: localDataProvider.userData!.tokenId!,
              userName: localDataProvider.studentId);
      setAttendancePercentage(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  void setSelectedDate(DateTime dateTime) {
    selectedDate = dateTime;
    notifyListeners();
  }

  Future<void> reloadAttendance(DateTime dateTime) async {
    DialogBuilder.showLoadingIndicator();
    await loadAttendance(date: dateTime)
        .whenComplete(() => DialogBuilder.hideOpenDialog());
    setSelectedDate(dateTime);
  }

  void generateAttendanceGraph() {
    pieData = [
      AttendanceGraph(
          'Present',
          presentDates.where((e) => e.attnTypeId == 1).toList().length,
          AppColors.successGreenColor),
      AttendanceGraph(
          'Absent',
          absentDates.where((e) => e.attnTypeId == 2).toList().length,
          AppColors.valuesRedColors),
      AttendanceGraph(
          'Leave',
          leaveDates.where((e) => e.attnTypeId == 3).toList().length,
          Colors.amber),
    ];
  }

  List<PieChartSectionData> getSections() => List.generate(
      pieData.length,
      (index) => PieChartSectionData(
          titleStyle:
              const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
          radius: 25,
          titlePositionPercentageOffset: 1.6,
          color: pieData[index].color!,
          value: double.parse('${pieData[index].attendanceCount}'),
          title: '${pieData[index].attendanceCount}'));

  // Future<void> navigateToAttendance() async {
  //   //
  //   if (formKey.currentState!.validate()) {
  //     FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());
  //     AppNavigation.navigateTo(AppNavRoutes.attendanceRoute);
  //   }
  // }

//\\
  // void clearData() {
  //   selectedSubject = 0;
  //   subjectController.clear();
  //   subjects = [];
  // }

//\\
  void clearDate() {
    selectedDate = DateTime.now();
  }
}
