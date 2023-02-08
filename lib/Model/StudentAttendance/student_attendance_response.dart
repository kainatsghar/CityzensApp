import 'package:flutter/cupertino.dart';

class StudentAttendanceResponse {
  List<MonthlyAttendance> monthlyAttendance;
  bool isSuccessful;
  String message;
  bool isServerException;

  StudentAttendanceResponse(
      {this.monthlyAttendance,
      this.isSuccessful,
      this.message,
      this.isServerException});

  StudentAttendanceResponse.fromJson(Map<String, dynamic> json) {
    if (json['MonthlyAttandanceDto'] != null) {
      monthlyAttendance = <MonthlyAttendance>[];
      json['MonthlyAttandanceDto'].forEach((v) {
        monthlyAttendance.add(new MonthlyAttendance.fromJson(v));
      });
    }
    isSuccessful = json['IsSuccessful'];
    message = json['Message'];
    isServerException = json['IsServerException'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.monthlyAttendance != null) {
      data['MonthlyAttandanceDto'] =
          this.monthlyAttendance.map((v) => v.toJson()).toList();
    }
    data['IsSuccessful'] = this.isSuccessful;
    data['Message'] = this.message;
    data['IsServerException'] = this.isServerException;
    return data;
  }
}

class MonthlyAttendance {
  int attnTypeId;
  String attnType;
  int sectionId;
  int subjectId;
  String attnDate;

  MonthlyAttendance(
      {this.attnTypeId,
      this.attnType,
      this.sectionId,
      this.subjectId,
      this.attnDate});

  MonthlyAttendance.fromJson(Map<String, dynamic> json) {
    attnTypeId = json['AttnTypeId'];
    attnType = json['AttnType'];
    sectionId = json['SectionId'];
    subjectId = json['SubjectId'];
    attnDate = json['AttnDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AttnTypeId'] = this.attnTypeId;
    data['AttnType'] = this.attnType;
    data['SectionId'] = this.sectionId;
    data['SubjectId'] = this.subjectId;
    data['AttnDate'] = this.attnDate;
    return data;
  }
}

class Event {
  final String title;
  final String attendance;
  final String studentName;
  final String studentId;
  final Color color;
  final DateTime dateTime;

  Event(
      {this.title,
      this.attendance,
      this.color,
      this.dateTime,
      this.studentId,
      this.studentName});
}
