class ParentEyeOnYourChildRequest {
  int? studentId;
  String? tokenId;

  ParentEyeOnYourChildRequest({this.studentId, this.tokenId});
  ParentEyeOnYourChildRequest.fromJson(Map<String, dynamic> json) {
    studentId = json['StudentId'];
    tokenId = json['tokenId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (studentId != null) data['StudentId'] = studentId;
    if (tokenId != null) data['tokenId'] = tokenId;

    return data;
  }
}
