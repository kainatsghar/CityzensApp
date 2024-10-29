class AddAssignmentRequest {
  String? subject;
  String? description;
  String? classWorkDate;
  int? sectionId;
  String? classTeacherId;
  String? tokenId;
  String? filePath;
  String? fileName;

  AddAssignmentRequest({
    this.subject,
    this.classWorkDate,
    this.description,
    this.classTeacherId,
    this.sectionId,
    this.tokenId,
    this.filePath,
    this.fileName,
  });

  AddAssignmentRequest.fromJson(Map<String, dynamic> json) {
    subject = json['Subject'];
    description = json['Description'];
    classWorkDate = json['ClassWorkDate'];
    classTeacherId = json['ClassTeacherId'];
    sectionId = json['SectionId'];
    tokenId = json['tokenId'];
    filePath = json['Base64String'];
    fileName = json['FileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Subject'] = subject;
    data['Description'] = description;
    data['ClassWorkDate'] = classWorkDate;
    data['ClassTeacherId'] = classTeacherId;
    data['SectionId'] = sectionId;
    data['tokenId'] = tokenId;
    data['Base64String'] = filePath;
    data['FileName'] = fileName;
    return data;
  }
}
