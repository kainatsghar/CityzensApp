class StudentALevelAttendanceRequest {
  String? studentId;
  int? subjectId;
  String? tokenId;
  String? pMonth;

  StudentALevelAttendanceRequest({
    this.studentId,
    this.subjectId,
    this.tokenId,
    this.pMonth,
  });

  StudentALevelAttendanceRequest.fromJson(Map<String, dynamic> json) {
    studentId = json['StudentId'];
    subjectId = json['SubjectId'];
    tokenId = json['TokenId'];
    pMonth = json['PMonth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StudentId'] = studentId;
    data['SubjectId'] = subjectId;
    data['TokenId'] = tokenId;
    data['PMonth'] = pMonth;
    return data;
  }
}
