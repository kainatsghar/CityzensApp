class StudentAttendanceRequest {
  String studentId;
  String tokenId;
  String pMonth;

  StudentAttendanceRequest(
      {this.studentId,
      this.tokenId,
      this.pMonth});

  StudentAttendanceRequest.fromJson(Map<String, dynamic> json) {
    studentId = json['StudentId'];
    tokenId = json['TokenId'];
    pMonth = json['PMonth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StudentId'] = this.studentId;
    data['TokenId'] = this.tokenId;
    data['PMonth'] = this.pMonth;
    return data;
  }
}
