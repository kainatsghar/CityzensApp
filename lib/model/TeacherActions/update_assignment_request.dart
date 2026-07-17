class UpdateAssignmentRequest {
  String? tokenId;
  String? id;
  String? subject;
  String? description;
  String? classWorkDate;
  String? classTeacherId;
  num? sectionId;
  String? fileName;
  String? base64String;

  UpdateAssignmentRequest({
    this.tokenId,
    this.id,
    this.subject,
    this.description,
    this.classWorkDate,
    this.classTeacherId,
    this.sectionId,
    this.fileName,
    this.base64String,
  });

  UpdateAssignmentRequest.fromJson(Map<String, dynamic> json) {
    tokenId = json['TokenId'];
    id = json['Id'];
    subject = json['Subject'];
    description = json['Description'];
    classWorkDate = json['ClassWorkDate'];
    classTeacherId = json['ClassTeacherId'];
    sectionId = json['SectionId'];
    fileName = json['FileName'];
    base64String = json['Base64String'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tokenId != null) data['TokenId'] = tokenId;
    if (id != null) data['Id'] = id;
    if (subject != null) data['Subject'] = subject;
    if (description != null) data['Description'] = description;
    if (classWorkDate != null) data['ClassWorkDate'] = classWorkDate;
    if (classTeacherId != null) data['ClassTeacherId'] = classTeacherId;
    if (sectionId != null) data['SectionId'] = sectionId;
    if (fileName != null) data['FileName'] = fileName;
    if (base64String != null && base64String!.isNotEmpty) {
      data['Base64String'] = base64String;
    }
    return data;
  }
}
