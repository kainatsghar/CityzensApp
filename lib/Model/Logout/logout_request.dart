class LogoutRequest{
  String? tokenId;
  LogoutRequest({this.tokenId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tokenId'] = tokenId;
    return data;
  }
}