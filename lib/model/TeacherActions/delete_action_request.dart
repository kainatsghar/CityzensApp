class DeleteActionRequest {
  String? tokenId;
  int? id;

  DeleteActionRequest({
    this.tokenId,
    this.id,
  });

  DeleteActionRequest.fromJson(Map<String, dynamic> json) {
    tokenId = json['tokenId'];
    id = json['Id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tokenId'] = tokenId;
    data['Id'] = id;
    return data;
  }
}
