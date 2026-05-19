// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/model/StudentAttendance/student_alevel_attendance_subjects_response.dart';
import 'package:tcs_app/services/StudentAttendance/student_alevel_attendance_service.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/model/StudentAttendance/attendance_percentage_response.dart';
import 'package:tcs_app/model/StudentAttendance/student_attendance_response.dart';
import 'package:tcs_app/services/Attendance/attendance_subjects_service.dart';
import 'package:tcs_app/services/AttendancePercentage/attendance_percentage_service.dart';
import 'package:tcs_app/routes/app_navigation.dart';

import '../../model/StudentAttendance/save_attendance_request.dart';
// import '../../routes/app_navigation.dart';
// import '../../services/StudentAttendance/student_attendance_service.dart';
import '../LocalData/local_data_provider.dart';

class StudentALevelAttendanceProvider with ChangeNotifier {
  //for student_attendance_subject_component
  //
  final subjectController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  int selectedSubject = 0;
  int selectedSubjectId = 0;

  List<SubjectsDtos> subjects = [];
  //\\

  StudentAttendanceResponse? studentAttendanceResponse;
  AttendancePercentageResponse? attendancePercentage;

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  //
  void setResponse(AttendanceSubjectsResponse? listResponse) {
    subjects = listResponse?.subjectsDtos ?? [];
    notifyListeners();
  }

  Future<AttendanceSubjectsResponse> loadAttendanceSubjects() async {
    try {
      AttendanceSubjectsResponse response =
          await AttendanceSubjectsService.attendanceSubjectsRequest(
            userName: localDataProvider.studentId,
          );
      setResponse(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> loadInitialData() async {
    try {
      if (subjects.isEmpty) {
        await loadAttendanceSubjects();
      }
      if (subjects.isNotEmpty) {
        if (selectedSubjectId == 0) {
          selectedSubjectId = subjects.first.subjectId!;
          selectedSubject = subjects.first.subjectId!;
        }
        await loadAttendance();
      }
    } catch (ex) {
      rethrow;
    }
  }

  Future<void> setSelectedSubject(int subjectId) async {
    selectedSubject = subjectId;
    selectedSubjectId = subjectId;
    notifyListeners();
    DialogBuilder.showLoadingIndicator();
    await loadAttendance().whenComplete(() => DialogBuilder.hideOpenDialog());
  }

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
          studentName: localDataProvider.userData!.info!.name,
        ),
      ],
    );
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
          studentName: localDataProvider.userData!.name,
        ),
      ],
    );
    leaveDates = studentAttendanceResponse!.monthlyAttendance!
        .where((e) => e.attnTypeId == 3)
        .toList();
    leaveDates.forEach(
      (data) => studentAttendance[DateTime.parse('${data.attnDate}Z')] = [
        Event(
          title: 'Attendance',
          attendance: 'Leave',
          color: Colors.amber.withAlpha(230),
          dateTime: DateTime.parse(data.attnDate!),
          studentId: localDataProvider.studentId,
          studentName: localDataProvider.userData!.name,
        ),
      ],
    );
    presentDates.retainWhere((e) => sets.add(e.attnDate));
    absentDates.retainWhere((e) => sets.add(e.attnDate));
    leaveDates.retainWhere((e) => sets.add(e.attnDate));
    generateAttendanceGraph();
  }

  List<Event> getAttendance(DateTime dateTime) =>
      studentAttendance[dateTime] ?? [];

  String attendanceDate = DateFormat('yyyyMM').format(DateTime.now());
  /////
  Future<StudentAttendanceResponse> loadAttendance({DateTime? date}) async {
    try {
      StudentAttendanceResponse response =
          await StudentALevelAttendanceService.studentALevelAttendanceRequest(
            subjectId: selectedSubjectId,
            tokenId: localDataProvider.userData!.tokenId!,
            attendanceDate: DateFormat('yyyyMM').format(date ?? DateTime.now()),
            userName: localDataProvider.studentId,
          );
      setAttendanceData(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  ////
  Future<AttendancePercentageResponse> getAttendancePercentage() async {
    try {
      AttendancePercentageResponse response =
          await AttendancePercentageService.attendancePercentage(
            tokenId: localDataProvider.userData!.tokenId!,
            userName: localDataProvider.studentId,
          );
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
    await loadAttendance(
      date: dateTime,
    ).whenComplete(() => DialogBuilder.hideOpenDialog());
    setSelectedDate(dateTime);
  }

  void generateAttendanceGraph() {
    pieData = [
      AttendanceGraph(
        'Present',
        presentDates.where((e) => e.attnTypeId == 1).toList().length,
        Colors.green,
      ),
      AttendanceGraph(
        'Absent',
        absentDates.where((e) => e.attnTypeId == 2).toList().length,
        Colors.red,
      ),
      AttendanceGraph(
        'Leave',
        leaveDates.where((e) => e.attnTypeId == 3).toList().length,
        Colors.amber,
      ),
    ];
  }

  List<PieChartSectionData> getSections() => List.generate(
    pieData.length,
    (index) => PieChartSectionData(
      titleStyle: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
      radius: 25,
      titlePositionPercentageOffset: 1.6,
      color: pieData[index].color!,
      value: double.parse('${pieData[index].attendanceCount}'),
      title: '${pieData[index].attendanceCount}',
    ),
  );

  //\\
  void clearData() {
    selectedSubject = 0;
    subjectController.clear();
    subjects = [];
  }

  //\\
  void clearDate() {
    selectedDate = DateTime.now();
  }
}
