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
  String? subject;
  String? description;
  int? classTeacherId;
  String? diaryDate;
  String? fileName;

  DiaryRecords(
      {this.subject,
      this.description,
      this.classTeacherId,
      this.diaryDate,
      this.fileName});

  DiaryRecords.fromJson(Map<String, dynamic> json) {
    subject = json['Subject'];
    description = json['Description'];
    classTeacherId = json['ClassTeacherId'];
    diaryDate = json['DiaryDate'];
    fileName = json['FileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Subject'] = subject;
    data['Description'] = description;
    data['ClassTeacherId'] = classTeacherId;
    data['DiaryDate'] = diaryDate;
    data['FileName'] = fileName;
    return data;
  }
}
