class StudentListRequest {
  String classSectionId;
  String tokenId;
  String attendanceData;
  String subjectId;
  String pMonth;
  String studentId;

  StudentListRequest(
      {this.classSectionId,
      this.tokenId,
      this.attendanceData,
      this.subjectId,
      this.pMonth,
      this.studentId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ClassSectionId'] = classSectionId ?? '';
    data['TokenId'] = tokenId ?? '';
    data['AttendanceDate'] = attendanceData ?? '';
    data['SubjectId'] = subjectId ?? '';
    data['PMonth'] = pMonth ?? '';
    data['StudentId'] = studentId ?? '';
    return data;
  }
}
