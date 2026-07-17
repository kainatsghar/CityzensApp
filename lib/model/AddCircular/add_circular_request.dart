import 'package:tcs_app/utils/helper_function.dart';

class AddCircularRequest {
  String? title;
  String? body;
  String? subject;
  int? sectionId;
  String? classTeacherId;
  String? tokenId;
  String? filePath;
  String? fileName;

  String? announcementDate;

  AddCircularRequest({
    this.title,
    this.body,
    this.subject,
    this.classTeacherId,
    this.sectionId,
    this.tokenId,
    this.filePath,
    this.fileName,
    this.announcementDate,
  });

  AddCircularRequest.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    body = json['Body'];
    subject = json['Subject'];
    classTeacherId = json['ClassTeacherId'];
    sectionId = json['SectionId'];
    tokenId = json['tokenId'];
    filePath = json['Base64String'];
    fileName = json['FileName'];
    announcementDate = json['AnnouncementDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Title'] = title;
    data['Body'] = body;
    data['Subject'] = subject;
    data['ClassTeacherId'] = classTeacherId;
    data['SectionId'] = sectionId;
    data['tokenId'] = tokenId;
    data['Base64String'] = filePath;
    data['FileName'] = fileName;
    data['AnnouncementDate'] = HelperFunction.toSqlDate(announcementDate);
    return data;
  }
}
