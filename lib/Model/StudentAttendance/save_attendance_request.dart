import 'package:flutter/material.dart';

class SaveAttendanceRequest {
  String classSectionId;
  String tokenId;
  String attendanceDate;
  int subjectId;

  List<DailyAttendance> dailyAttendance;

  SaveAttendanceRequest(
      {this.classSectionId,
      this.tokenId,
      this.attendanceDate,
      this.dailyAttendance,
      this.subjectId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ClassSectionId'] = this.classSectionId;
    data['TokenId'] = this.tokenId;
    data['AttendanceDate'] = this.attendanceDate;
    data['CalDayType_Id'] = '';
    // data['IsAlevel'] = this.isALevel;
    data['SubjectId'] = this.subjectId ?? 0;
    // data['CalDayType_Id'] = this.calDayTypeId;
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
  int attnTypeId;

  DailyAttendance({this.studentId, this.name, this.day, this.attnTypeId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StudentId'] = this.studentId;
    data['Name'] = this.name;
    data['Day'] = this.day;
    data['AttnType_ID'] = this.attnTypeId;
    return data;
  }
}

class AttendanceGraph {
  String attendance;
  int attendanceCount;
  Color color;

  AttendanceGraph(this.attendance, this.attendanceCount, this.color);
}
