class SectionSubjectRequest {
  String tokenId;
  String id;
  String teacherId;
  bool isDiary;

  SectionSubjectRequest({this.tokenId, this.teacherId, this.id, this.isDiary});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['TeacherId'] = teacherId;
    data['tokenId'] = tokenId;
    data['isDairy'] = isDiary ?? false;
    return data;
  }
}
