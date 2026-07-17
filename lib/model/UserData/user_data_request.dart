class UserDataRequest {
  String? tokenId;
  String? userName;
  String? group;
  bool? isDiary;

  UserDataRequest(
      {this.tokenId, this.userName, this.group, this.isDiary = false});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userName != null) data['id'] = userName;
    if (tokenId != null) data['tokenId'] = tokenId;
    if (group != null) data['Grp'] = group;
    if (isDiary != null) data['isDairy'] = isDiary ?? false;
    return data;
  }
}
