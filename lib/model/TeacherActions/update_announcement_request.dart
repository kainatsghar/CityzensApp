import 'package:tcs_app/utils/helper_function.dart';

class UpdateAnnouncementRequest {
  int? id;
  String? subject;
  String? description;
  String? tokenId;
  String? classTeacherId;
  String? fileName;
  String? base64String;
  int? sectionId;
  String? announcementDate;

  UpdateAnnouncementRequest({
    this.id,
    this.subject,
    this.description,
    this.tokenId,
    this.classTeacherId,
    this.fileName,
    this.base64String,
    this.sectionId,
    this.announcementDate,
  });

  UpdateAnnouncementRequest.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    subject = json['Subject'];
    description = json['Description'];
    tokenId = json['TokenId'];
    classTeacherId = json['ClassTeacherId'];
    fileName = json['FileName'];
    base64String = json['Base64String'];
    sectionId = json['SectionId'];
    announcementDate = json['AnnouncementDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Subject'] = subject;
    data['Description'] = description;
    data['TokenId'] = tokenId;
    data['ClassTeacherId'] = classTeacherId;
    data['FileName'] = fileName;
    data['Base64String'] = base64String;
    data['SectionId'] = sectionId;
    data['AnnouncementDate'] = HelperFunction.toSqlDate(announcementDate);
    return data;
  }
}
