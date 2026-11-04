import 'package:flutter/material.dart';

class SaveAttendanceRequest {
  String? classSectionId;
  String? tokenId;
  String? attendanceDate;
  int? subjectId;

  List<DailyAttendance>? dailyAttendance;

  SaveAttendanceRequest({
    this.classSectionId,
    this.tokenId,
    this.attendanceDate,
    this.dailyAttendance,
    this.subjectId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ClassSectionId'] = classSectionId;
    data['TokenId'] = tokenId;
    data['AttendanceDate'] = attendanceDate;
    data['CalDayType_Id'] = '';
    // data['IsAlevel'] = this.isALevel;
    data['SubjectId'] = subjectId ?? 0;
    // data['CalDayType_Id'] = this.calDayTypeId;
    if (dailyAttendance != null) {
      data['DailyAttendance'] = dailyAttendance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DailyAttendance {
  int? studentId;
  String? name;
  String? day;
  int? attnTypeId;

  DailyAttendance({this.studentId, this.name, this.day, this.attnTypeId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StudentId'] = studentId;
    data['Name'] = name;
    data['Day'] = day;
    data['AttnType_ID'] = attnTypeId;
    return data;
  }
}

class AttendanceGraph {
  String attendance;
  int attendanceCount;
  Color? color;

  AttendanceGraph(this.attendance, this.attendanceCount, this.color);
}
