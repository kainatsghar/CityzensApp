import 'package:flutter/material.dart';

class SaveAttendanceRequest {
  String classSectionId;
  String tokenId;
  String attendanceDate;
  List<DailyAttendance> dailyAttendance;

  SaveAttendanceRequest(
      {this.classSectionId,
      this.tokenId,
      this.attendanceDate,
      this.dailyAttendance});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClassSectionId'] = this.classSectionId;
    data['TokenId'] = this.tokenId;
    data['AttendanceDate'] = this.attendanceDate;
    if (this.dailyAttendance != null) {
      data['DailyAttendance'] =
          this.dailyAttendance.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyAttendance {
  int studentId;
  String name;
  String day;

  DailyAttendance({this.studentId, this.name, this.day});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StudentId'] = this.studentId;
    data['Name'] = this.name;
    data['Day'] = this.day;
    return data;
  }
}

class AttendanceGraph {
  String attendance;
  int attendanceCount;
  Color color;

  AttendanceGraph(this.attendance, this.attendanceCount, this.color);
}
