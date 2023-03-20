class MarkUnverifiedRequest {
  String studentId;
  String studentName;
  int reasonId;
  String teacherRemarks;
  int sectionId;
  String employeeId;
  String tokenId;

  MarkUnverifiedRequest(
      {this.studentId,
      this.studentName,
      this.reasonId,
      this.teacherRemarks,
      this.sectionId,
      this.employeeId,
      this.tokenId});

  MarkUnverifiedRequest.fromJson(Map<String, dynamic> json) {
    studentId = json['studentId'];
    studentName = json['studentName'];
    reasonId = json['reasonId'];
    teacherRemarks = json['teacherRemarks'];
    sectionId = json['Section_Id'];
    employeeId = json['Employee_Id'];
    tokenId = json['tokenId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['studentId'] = this.studentId;
    data['studentName'] = this.studentName;
    data['reasonId'] = this.reasonId;
    data['teacherRemarks'] = this.teacherRemarks;
    data['Section_Id'] = this.sectionId;
    data['Employee_Id'] = this.employeeId;
    data['tokenId'] = this.tokenId;
    return data;
  }
}
