class AddDiaryRequest {
  String subject;
  String description;
  String diaryDate;
  int sectionId;
  String classTeacherId;

  AddDiaryRequest(
      {this.subject,
      this.diaryDate,
      this.description,
      this.classTeacherId,
      this.sectionId});

  AddDiaryRequest.fromJson(Map<String, dynamic> json) {
    subject = json['Subject'];
    description = json['Description'];
    diaryDate = json['DiaryDate'];
    classTeacherId = json['ClassTeacherId'];
    sectionId = json['SectionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Subject'] = this.subject;
    data['Description'] = this.description;
    data['DiaryDate'] = this.diaryDate;
    data['ClassTeacherId'] = this.classTeacherId;
    data['SectionId'] = this.sectionId;
    return data;
  }
}
