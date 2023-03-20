class DiaryRequest {
  String classTeacherId;
  String tokenId;
  String studentId;

  DiaryRequest({this.classTeacherId, this.tokenId, this.studentId});

  DiaryRequest.fromJson(Map<String, dynamic> json) {
    classTeacherId = json['classTeacherId'];
    tokenId = json['tokenId'];
    studentId = json['sectionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.classTeacherId != null)
      data['classTeacherId'] = this.classTeacherId;
    data['tokenId'] = this.tokenId;
    data['sectionId'] = this.studentId;
    return data;
  }
}
