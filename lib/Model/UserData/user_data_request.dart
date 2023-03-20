class UserDataRequest {
  String tokenId;
  String userName;
  String group;

  UserDataRequest({this.tokenId, this.userName, this.group});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userName != null) data['id'] = userName;
    if (tokenId != null) data['tokenId'] = tokenId;
    if (group != null) data['Grp'] = group;
    return data;
  }
}
