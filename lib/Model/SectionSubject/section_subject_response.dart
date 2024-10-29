class SectionSubjectResponse {
  List<SectionSubject>? sectionSubject;
  bool? isSuccessful;
  String? message;
  bool? isServerException;

  SectionSubjectResponse({
    this.sectionSubject,
    this.isSuccessful,
    this.message,
    this.isServerException,
  });

  SectionSubjectResponse.fromJson(Map<String, dynamic> json) {
    if (json['SectionSubject'] != null) {
      sectionSubject = <SectionSubject>[];
      json['SectionSubject'].forEach((v) {
        sectionSubject!.add(SectionSubject.fromJson(v));
      });
    }
    isSuccessful = json['IsSuccessful'];
    message = json['Message'];
    isServerException = json['IsServerException'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sectionSubject != null) {
      data['SectionSubject'] = sectionSubject!.map((v) => v.toJson()).toList();
    }
    data['IsSuccessful'] = isSuccessful;
    data['Message'] = message;
    data['IsServerException'] = isServerException;
    return data;
  }
}

class SectionSubject {
  int? subjectId;
  String? subjectName;

  SectionSubject({this.subjectId, this.subjectName});

  SectionSubject.fromJson(Map<String, dynamic> json) {
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
