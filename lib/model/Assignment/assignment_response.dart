import 'package:tcs_app/utils/helper_function.dart';

class AssignmentResponse {
  List<AssignmentRecords>? assignmentRecords;
  String? message;
  bool? isSuccess;

  AssignmentResponse({this.assignmentRecords, this.message, this.isSuccess});

  AssignmentResponse.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      assignmentRecords = <AssignmentRecords>[];
      json['Data'].forEach((v) {
        assignmentRecords!.add(AssignmentRecords.fromJson(v));
      });
    }
    message = json['Message'];
    isSuccess = json['IsSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (assignmentRecords != null) {
      data['Data'] = assignmentRecords!.map((v) => v.toJson()).toList();
    }
    data['Message'] = message;
    data['IsSuccess'] = isSuccess;
    return data;
  }
}

class AssignmentRecords {
  int? id;
  String? subject;
  String? description;
  int? classTeacherId;
  String? classWorkDate;
  String? fileName;
  String? sectionName;
  int? sectionId;

  AssignmentRecords(
      {this.id,
      this.subject,
      this.description,
      this.classTeacherId,
      this.classWorkDate,
      this.fileName,
      this.sectionName,
      this.sectionId});

  AssignmentRecords.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    subject = json['Subject'];
    description = json['Description'];
    classTeacherId = json['ClassTeacherId'];
    classWorkDate = json['ClassWorkDate'];
    fileName = json['FileName'];
    sectionName = json['SectionName'];
    sectionId = json['SectionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Subject'] = subject;
    data['Description'] = description;
    data['ClassTeacherId'] = classTeacherId;
    data['ClassWorkDate'] = HelperFunction.toSqlDate(classWorkDate);
    data['FileName'] = fileName;
    data['SectionName'] = sectionName;
    data['SectionId'] = sectionId;
    return data;
  }

  /// Helper to get only the date part (YYYY-MM-DD) for grouping/display
  String get classWorkDateOnly => (classWorkDate ?? '').split('T')[0];
}
