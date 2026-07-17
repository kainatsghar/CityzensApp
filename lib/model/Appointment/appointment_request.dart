class AppointmentRequest {
  int? id;
  bool? isStudent;
  String? tokenId;

  AppointmentRequest({
    this.id,
    this.isStudent,
    this.tokenId,
  });
  AppointmentRequest.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    isStudent = json['IsStudent'];
    tokenId = json['tokenId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['Id'] = id;
    if (isStudent != null) data['IsStudent'] = isStudent;
    if (tokenId != null) data['tokenId'] = tokenId;
    return data;
  }
}
