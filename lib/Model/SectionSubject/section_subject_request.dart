class SectionSubjectRequest {
  String tokenId;
  String id;
  String teacherId;


  SectionSubjectRequest({this.tokenId,this.teacherId,this.id});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['TeacherId'] = teacherId;
    data['tokenId'] = tokenId;
    return data;
  }
}
