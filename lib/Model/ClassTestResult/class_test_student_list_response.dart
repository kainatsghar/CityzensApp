class ClassTestResultStudentListResponse {
  bool? isSuccessful;
  String? message;
  bool? isException;
  List<ClassTestStudent>? studentList;

  ClassTestResultStudentListResponse({
    this.isSuccessful,
    this.message,
    this.isException,
    this.studentList,
  });

  ClassTestResultStudentListResponse.fromJson(Map<String, dynamic> json) {
    if (json['studentDto'] != null) {
      studentList = <ClassTestStudent>[];
      json['studentDto'].forEach((v) {
        studentList!.add(ClassTestStudent.fromJson(v));
      });
    }
    message = json['Message'];
    isSuccessful = json['IsSuccessful'];
    isException = json['IsServerException'];
  }
}

class ClassTestStudent {
  int? studentId;
  String? studentName;
  int? obtainedMarks;
  int? totalMarks;

  ClassTestStudent({this.studentId, this.studentName});

  ClassTestStudent.fromJson(Map<String, dynamic> json) {
    studentId = json['Id'];
    studentName = json['Name'];
    obtainedMarks = json['ObtainedMarks'] != null
        ? int.parse(json['ObtainedMarks'].toString())
        : 0;
    totalMarks = json['TotalMarks'] != null
        ? int.parse(json['TotalMarks'].toString())
        : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = studentId;
    data['Name'] = studentName;
    data['ObtainedMarks'] = obtainedMarks ?? 0;
    data['TotalMarks'] = totalMarks ?? 0;
    return data;
  }
}
