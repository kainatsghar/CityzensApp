class AttendanceSubjectsResponse {
  Null sectionSubject;
  List<SubjectsDtos>? subjectsDtos;
  bool? isSuccessful;
  String? message;
  bool? isServerException;

  AttendanceSubjectsResponse({
    this.sectionSubject,
    this.subjectsDtos,
    this.isSuccessful,
    this.message,
    this.isServerException,
  });

  AttendanceSubjectsResponse.fromJson(Map<String, dynamic> json) {
    sectionSubject = json['SectionSubject'];
    if (json['subjectsDtos'] != null) {
      subjectsDtos = <SubjectsDtos>[];
      json['subjectsDtos'].forEach((v) {
        subjectsDtos!.add(SubjectsDtos.fromJson(v));
      });
    }
    isSuccessful = json['IsSuccessful'];
    message = json['Message'];
    isServerException = json['IsServerException'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SectionSubject'] = sectionSubject;
    if (subjectsDtos != null) {
      data['subjectsDtos'] = subjectsDtos!.map((v) => v.toJson()).toList();
    }
    data['IsSuccessful'] = isSuccessful;
    data['Message'] = message;
    data['IsServerException'] = isServerException;
    return data;
  }
}

class SubjectsDtos {
  int? subjectId;
  String? subjectName;

  SubjectsDtos({this.subjectId, this.subjectName});

  SubjectsDtos.fromJson(Map<String, dynamic> json) {
    subjectId = json['SubjectId'];
    subjectName = json['SubjectName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SubjectId'] = subjectId;
    data['SubjectName'] = subjectName;
    return data;
  }
}
