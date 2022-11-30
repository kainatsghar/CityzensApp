class UserDataRequest {
  String tokenId;
  String userName;
  String group;

  UserDataRequest({this.tokenId, this.userName, this.group});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = userName;
    data['tokenId'] = tokenId;
    data['Grp'] = group;
    return data;
  }
}
