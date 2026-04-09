class CircularAnnouncementRequest {
  String? classTeacherId;
  String? tokenId;

  CircularAnnouncementRequest({this.classTeacherId, this.tokenId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TeacherId'] = classTeacherId;
    data['tokenId'] = tokenId;
    return data;
  }
}
