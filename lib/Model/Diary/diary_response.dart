import 'package:tcs_app/utils/helper_function.dart';

class DiaryResponse {
  List<DiaryRecords>? diaryRecords;
  String? message;
  bool? isSuccess;

  DiaryResponse({this.diaryRecords, this.message, this.isSuccess});

  DiaryResponse.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      diaryRecords = <DiaryRecords>[];
      json['Data'].forEach((v) {
        diaryRecords!.add(DiaryRecords.fromJson(v));
      });
    }
    message = json['Message'];
    isSuccess = json['IsSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (diaryRecords != null) {
      data['Data'] = diaryRecords!.map((v) => v.toJson()).toList();
    }
    data['Message'] = message;
    data['IsSuccess'] = isSuccess;
    return data;
  }
}

class DiaryRecords {
  int? id;
  String? subject;
  String? description;
  int? classTeacherId;
  String? diaryDate;
  String? fileName;
  String? sectionName;
  int? sectionId;

  DiaryRecords(
      {this.id,
      this.subject,
      this.description,
      this.classTeacherId,
      this.diaryDate,
      this.fileName,
      this.sectionName,
      this.sectionId});

  DiaryRecords.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    subject = json['Subject'];
    description = json['Description'];
    classTeacherId = json['ClassTeacherId'];
    diaryDate = json['DiaryDate'];
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
    data['DiaryDate'] = HelperFunction.toSqlDate(diaryDate); // Ensure SQL safe
    data['FileName'] = fileName;
    data['SectionName'] = sectionName;
    data['SectionId'] = sectionId;
    return data;
  }

  /// Helper to get only the date part (YYYY-MM-DD) for grouping/display
  String get diaryDateOnly => (diaryDate ?? '').split('T')[0];
}
