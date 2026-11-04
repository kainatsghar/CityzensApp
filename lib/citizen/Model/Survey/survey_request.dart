class SurveyRequest {
  String? userId;

  SurveyRequest({this.userId});

  SurveyRequest.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userId != null) data['UserId'] = userId;
    return data;
  }
}
