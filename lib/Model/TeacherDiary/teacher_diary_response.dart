class TeacherDiaryResponse {
  List<DiaryRecords> diaryRecords;
  String message;
  bool isSuccess;

  TeacherDiaryResponse(
      {this.diaryRecords, this.message, this.isSuccess});

  TeacherDiaryResponse.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      diaryRecords = <DiaryRecords>[];
      json['Data'].forEach((v) {
        diaryRecords.add(new DiaryRecords.fromJson(v));
      });
    }
    message = json['Message'];
    isSuccess = json['IsSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.diaryRecords != null) {
      data['Data'] = this.diaryRecords.map((v) => v.toJson()).toList();
    }
    data['Message'] = this.message;
    data['IsSuccess'] = this.isSuccess;
    return data;
  }
}

class DiaryRecords {
  String subject;
  String description;
  int classTeacherId;
  String diaryDate;

  DiaryRecords(
      {this.subject, this.description, this.classTeacherId, this.diaryDate});

  DiaryRecords.fromJson(Map<String, dynamic> json) {
    subject = json['Subject'];
    description = json['Description'];
    classTeacherId = json['ClassTeacherId'];
    diaryDate = json['DiaryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Subject'] = this.subject;
    data['Description'] = this.description;
    data['ClassTeacherId'] = this.classTeacherId;
    data['DiaryDate'] = this.diaryDate;
    return data;
  }
}
