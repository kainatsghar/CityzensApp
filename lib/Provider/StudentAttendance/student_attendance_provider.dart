import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/Model/StudentAttendance/attendance_percentage_response.dart';
import 'package:tcs_app/Model/StudentAttendance/student_attendance_response.dart';
import 'package:tcs_app/Services/AttendancePercentage/attendance_percentage_service.dart';

import '../../Model/StudentAttendance/save_attendance_request.dart';
import '../../Routes/app_navigation.dart';
import '../../Services/StudentAttendance/student_attendance_service.dart';
import '../LocalData/local_data_provider.dart';

class StudentAttendanceProvider with ChangeNotifier {
  StudentAttendanceResponse studentAttendanceResponse;
  AttendancePercentageResponse attendancePercentage;

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
      AppNavigation.currentContext,
      listen: false);

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

  setEventsOnCalender() {
    studentAttendance.clear();
    final sets = Set();
    presentDates = studentAttendanceResponse.monthlyAttendance
        .where((e) => e.attnTypeId == 1)
        .toList();
    presentDates.forEach(
        (data) => studentAttendance[DateTime.parse('${data.attnDate}Z')] = [
              Event(
                  title: 'Attendance',
                  attendance: 'Present',
                  color: Colors.green.withOpacity(0.9),
                  dateTime: DateTime.parse(data.attnDate),
                  studentId: localDataProvider.studentId,
                  studentName: localDataProvider.userData.info.name)
            ]);
    absentDates = studentAttendanceResponse.monthlyAttendance
        .where((e) => e.attnTypeId == 2)
        .toList();
    absentDates.forEach(
        (data) => studentAttendance[DateTime.parse('${data.attnDate}Z')] = [
              Event(
                  title: 'Attendance',
                  attendance: 'Absent',
                  color: Colors.red.withOpacity(0.9),
                  dateTime: DateTime.parse(data.attnDate),
                  studentId: localDataProvider.studentId,
                  studentName: localDataProvider.userData.name)
            ]);
    leaveDates = studentAttendanceResponse.monthlyAttendance
        .where((e) => e.attnTypeId == 3)
        .toList();
    leaveDates.forEach(
        (data) => studentAttendance[DateTime.parse('${data.attnDate}Z')] = [
              Event(
                  title: 'Attendance',
                  attendance: 'Leave',
                  color: Colors.amber.withOpacity(0.9),
                  dateTime: DateTime.parse(data.attnDate),
                  studentId: localDataProvider.studentId,
                  studentName: localDataProvider.userData.name)
            ]);
    presentDates.retainWhere((e) => sets.add(e.attnDate));
    absentDates.retainWhere((e) => sets.add(e.attnDate));
    leaveDates.retainWhere((e) => sets.add(e.attnDate));
    generateAttendanceGraph();
  }

  List<Event> getAttendance(DateTime dateTime) =>
      studentAttendance[dateTime] ?? [];

  String attendanceDate = DateFormat('yyyyMM').format(DateTime.now());

  Future<StudentAttendanceResponse> loadAttendance({DateTime date}) async {
    try {
      StudentAttendanceResponse response =
          await StudentAttendanceService.studentAttendanceRequest(
              tokenId: localDataProvider.userData.tokenId,
              attendanceDate:
                  DateFormat('yyyyMM').format(date ?? DateTime.now()),
              userName: localDataProvider.studentId);
      setAttendanceData(response);
      return response;
    } catch (ex) {
      throw ex;
    }
  }

  Future<AttendancePercentageResponse> getAttendancePercentage() async {
    try {
      AttendancePercentageResponse response =
          await AttendancePercentageService.attendancePercentage(
              tokenId: localDataProvider.userData.tokenId,
              userName: localDataProvider.studentId);
      setAttendancePercentage(response);
      return response;
    } catch (ex) {
      throw ex;
    }
  }

  setSelectedDate(DateTime dateTime) {
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
          Colors.green),
      AttendanceGraph(
          'Absent',
          absentDates.where((e) => e.attnTypeId == 2).toList().length,
          Colors.red),
      AttendanceGraph(
          'Leave',
          leaveDates.where((e) => e.attnTypeId == 3).toList().length,
          Colors.amber),
    ];
  }

  List<PieChartSectionData> getSections() => List.generate(
      pieData.length,
      (index) => PieChartSectionData(
          titleStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600),
          radius: 25,
          titlePositionPercentageOffset: 1.6,
          color: pieData[index].color,
          value: double.parse('${pieData[index].attendanceCount}'),
          title: '${pieData[index].attendanceCount}'));

  void clearDate() {
    selectedDate = DateTime.now();
  }
}
