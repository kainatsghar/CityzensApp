class MarkUnverifiedRequest {
  String? studentId;
  String? studentName;
  int? reasonId;
  String? teacherRemarks;
  int? sectionId;
  String? employeeId;
  String? tokenId;

  MarkUnverifiedRequest({this.studentId, this.studentName, this.reasonId, this.teacherRemarks, this.sectionId, this.employeeId, this.tokenId});

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['studentId'] = studentId;
    data['studentName'] = studentName;
    data['reasonId'] = reasonId;
    data['teacherRemarks'] = teacherRemarks;
    data['Section_Id'] = sectionId;
    data['Employee_Id'] = employeeId;
    data['tokenId'] = tokenId;
    return data;
  }
}
