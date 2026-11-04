class ClassTestResultStudentListRequest {
  String? teacherId;
  String? subjectId;
  String? sectionId;
  int? categoryId;
  int? totalMarks;

  ClassTestResultStudentListRequest(
      {this.teacherId,
      this.subjectId,
      this.sectionId,
      this.categoryId,
      this.totalMarks});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = teacherId ?? '';
    data['SubjectId'] = subjectId ?? '';
    data['SectionId'] = sectionId ?? 0;
    data['CategoryId'] = categoryId ?? 0;
    data['TotalMarks'] = totalMarks ?? 0;
    return data;
  }
}
