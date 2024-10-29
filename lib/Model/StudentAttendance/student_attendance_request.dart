class StudentAttendanceRequest {
  String? studentId;
  String? tokenId;
  String? pMonth;

  StudentAttendanceRequest({
    this.studentId,
    this.tokenId,
    this.pMonth,
  });

  StudentAttendanceRequest.fromJson(Map<String, dynamic> json) {
    studentId = json['StudentId'];
    tokenId = json['TokenId'];
    pMonth = json['PMonth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StudentId'] = studentId;
    data['TokenId'] = tokenId;
    data['PMonth'] = pMonth;
    return data;
  }
}
