import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/Model/StudentAttendance/student_attendance_response.dart';

import '../../Routes/app_navigation.dart';
import '../../Services/StudentAttendance/student_attendance_service.dart';
import '../LocalData/local_data_provider.dart';

class StudentAttendanceProvider with ChangeNotifier {
  StudentAttendanceResponse studentAttendanceResponse;

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
      AppNavigation.currentContext,
      listen: false);

  void setAttendanceData(StudentAttendanceResponse response) {
    studentAttendanceResponse = response;
    setEventsOnCalender();
    notifyListeners();
  }

  DateTime selectedDate = DateTime.now();

  List<MonthlyAttendance> absentDates = [];
  List<MonthlyAttendance> presentDates = [];
  List<MonthlyAttendance> leaveDates = [];

  Map<DateTime, List<Event>> studentAttendance = {};

  setEventsOnCalender() {
    studentAttendance.clear();
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
              userName: localDataProvider.userData.userName);
      setAttendanceData(response);
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

  void clearDate() {
    selectedDate = DateTime.now();
  }
}
