class AddClassTestResultRequest {
  int? categoryId;
  int? subjectId;
  int? teacherId;
  int? totalMarks;
  List<StudentMarks>? studentMarks;

  AddClassTestResultRequest({
    this.categoryId,
    this.subjectId,
    this.teacherId,
    this.totalMarks,
    this.studentMarks,
  });

  AddClassTestResultRequest.fromJson(Map<String, dynamic> json) {
    categoryId = json['CategoryId'];
    subjectId = json['SubjectId'];
    teacherId = json['TeacherId'];
    totalMarks = json['TotalMarks'];
    if (json['StudentMarks'] != null) {
      studentMarks = <StudentMarks>[];
      json['StudentMarks'].forEach((v) {
        studentMarks!.add(StudentMarks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CategoryId'] = categoryId;
    data['SubjectId'] = subjectId;
    data['TeacherId'] = teacherId;
    data['TotalMarks'] = totalMarks;
    data['StudentMarks'] = studentMarks;
    return data;
  }
}

class StudentMarks {
  int? studentId;
  int? obtainedMarks;

  StudentMarks({
    this.studentId,
    this.obtainedMarks,
  });

  StudentMarks.fromJson(Map<String, dynamic> json) {
    studentId = json['StudentId'];
    obtainedMarks = json['ObtainedMarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StudentId'] = studentId;
    data['ObtainedMarks'] = obtainedMarks;
    return data;
  }
}
