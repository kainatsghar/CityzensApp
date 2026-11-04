class PushNotificationResponse {
  String? title;
  String? body;

  PushNotificationResponse({this.title, this.body});

  PushNotificationResponse.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
  }
}
