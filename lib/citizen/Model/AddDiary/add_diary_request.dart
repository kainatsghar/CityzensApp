class AddDiaryRequest {
  String? subject;
  String? description;
  String? diaryDate;
  int? sectionId;
  String? classTeacherId;
  String? tokenId;
  String? filePath;
  String? fileName;

  AddDiaryRequest({
    this.subject,
    this.diaryDate,
    this.description,
    this.classTeacherId,
    this.sectionId,
    this.tokenId,
    this.filePath,
    this.fileName,
  });

  AddDiaryRequest.fromJson(Map<String, dynamic> json) {
    subject = json['Subject'];
    description = json['Description'];
    diaryDate = json['DiaryDate'];
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
    data['DiaryDate'] = diaryDate;
    data['ClassTeacherId'] = classTeacherId;
    data['SectionId'] = sectionId;
    data['tokenId'] = tokenId;
    data['Base64String'] = filePath;
    data['FileName'] = fileName;
    return data;
  }
}
