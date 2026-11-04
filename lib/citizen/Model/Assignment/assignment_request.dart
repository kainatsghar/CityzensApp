class AssignmentRequest {
  String? classTeacherId;
  String? tokenId;
  String? studentId;

  AssignmentRequest({this.classTeacherId, this.tokenId, this.studentId});

  AssignmentRequest.fromJson(Map<String, dynamic> json) {
    classTeacherId = json['classTeacherId'];
    tokenId = json['tokenId'];
    studentId = json['StudentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (classTeacherId != null) {
      data['classTeacherId'] = classTeacherId;
    }
    if (tokenId != null) data['tokenId'] = tokenId;
    if (studentId != null) data['StudentId'] = studentId;
    return data;
  }
}
