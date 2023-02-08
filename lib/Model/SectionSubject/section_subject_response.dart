class SectionSubjectResponse {
  List<SectionSubject> sectionSubject;
  bool isSuccessful;
  String message;
  bool isServerException;

  SectionSubjectResponse(
      {this.sectionSubject,
      this.isSuccessful,
      this.message,
      this.isServerException});

  SectionSubjectResponse.fromJson(Map<String, dynamic> json) {
    if (json['SectionSubject'] != null) {
      sectionSubject = <SectionSubject>[];
      json['SectionSubject'].forEach((v) {
        sectionSubject.add(new SectionSubject.fromJson(v));
      });
    }
    isSuccessful = json['IsSuccessful'];
    message = json['Message'];
    isServerException = json['IsServerException'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sectionSubject != null) {
      data['SectionSubject'] =
          this.sectionSubject.map((v) => v.toJson()).toList();
    }
    data['IsSuccessful'] = this.isSuccessful;
    data['Message'] = this.message;
    data['IsServerException'] = this.isServerException;
    return data;
  }
}

class SectionSubject {
  int subjectId;
  String subjectName;

  SectionSubject({this.subjectId, this.subjectName});

  SectionSubject.fromJson(Map<String, dynamic> json) {
    subjectId = json['SubjectId'];
    subjectName = json['SubjectName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SubjectId'] = this.subjectId;
    data['SubjectName'] = this.subjectName;
    return data;
  }
}
