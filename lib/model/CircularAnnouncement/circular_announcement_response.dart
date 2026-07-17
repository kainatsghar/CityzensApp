import 'package:tcs_app/utils/helper_function.dart';

class CircularAnnouncementResponse {
  List<CircularAnnouncementRecords>? circularRecords;
  String? message;
  bool? isSuccess;

  CircularAnnouncementResponse({
    this.circularRecords,
    this.message,
    this.isSuccess,
  });

  CircularAnnouncementResponse.fromJson(Map<String, dynamic> json) {
    if (json['circularAnnouncements'] != null) {
      circularRecords = <CircularAnnouncementRecords>[];
      json['circularAnnouncements'].forEach((v) {
        circularRecords!.add(CircularAnnouncementRecords.fromJson(v));
      });
    }
    message = json['Message'];
    isSuccess = json['IsSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (circularRecords != null) {
      data['circularAnnouncements'] = circularRecords!
          .map((v) => v.toJson())
          .toList();
    }
    data['Message'] = message;
    data['IsSuccess'] = isSuccess;
    return data;
  }
}

class CircularAnnouncementRecords {
  int? id;
  String? title;
  String? description;
  String? announcementDate;
  String? modifiedOn;
  int? classTeacherId;
  String? fileName;
  String? sectionName;
  int? sectionId;

  CircularAnnouncementRecords({
    this.id,
    this.title,
    this.description,
    this.announcementDate,
    this.modifiedOn,
    this.classTeacherId,
    this.fileName,
    this.sectionName,
    this.sectionId,
  });

  CircularAnnouncementRecords.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Subject'];
    description = json['Description'];
    announcementDate = json['AnnouncementDate'];
    modifiedOn = json['ModifiedOn'];
    classTeacherId = json['ClassTeacherId'];
    fileName = json['FileName'];
    sectionName = json['SectionName'];
    sectionId = json['SectionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Subject'] = title;
    data['Description'] = description;
    data['AnnouncementDate'] = HelperFunction.toSqlDate(announcementDate);
    data['ModifiedOn'] = modifiedOn;
    data['ClassTeacherId'] = classTeacherId;
    data['FileName'] = fileName;
    data['SectionName'] = sectionName;
    data['SectionId'] = sectionId;
    return data;
  }

  /// Helper to get only the date part (YYYY-MM-DD) for grouping/display
  String get circularDateOnly => (announcementDate ?? '').split('T')[0];
}
