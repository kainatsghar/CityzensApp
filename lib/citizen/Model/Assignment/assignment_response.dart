class AssignmentResponse {
  List<AssignmentRecords>? assignmentRecords;
  String? message;
  bool? isSuccess;

  AssignmentResponse({this.assignmentRecords, this.message, this.isSuccess});

  AssignmentResponse.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      assignmentRecords = <AssignmentRecords>[];
      json['Data'].forEach((v) {
        assignmentRecords!.add(AssignmentRecords.fromJson(v));
      });
    }
    message = json['Message'];
    isSuccess = json['IsSuccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (assignmentRecords != null) {
      data['Data'] = assignmentRecords!.map((v) => v.toJson()).toList();
    }
    data['Message'] = message;
    data['IsSuccess'] = isSuccess;
    return data;
  }
}

class AssignmentRecords {
  String? subject;
  String? description;
  int? classTeacherId;
  String? classWorkDate;
  String? fileName;

  AssignmentRecords(
      {this.subject,
      this.description,
      this.classTeacherId,
      this.classWorkDate,
      this.fileName});

  AssignmentRecords.fromJson(Map<String, dynamic> json) {
    subject = json['Subject'];
    description = json['Description'];
    classTeacherId = json['ClassTeacherId'];
    classWorkDate = json['ClassWorkDate'];
    fileName = json['FileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Subject'] = subject;
    data['Description'] = description;
    data['ClassTeacherId'] = classTeacherId;
    data['ClassWorkDate'] = classWorkDate;
    data['FileName'] = fileName;
    return data;
  }
}
