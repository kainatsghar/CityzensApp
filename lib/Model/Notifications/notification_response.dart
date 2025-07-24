class NotificationResponse {
  bool? isSuccessful;
  String? message;
  bool? isException;
  List<Notifications>? notifications;

  NotificationResponse(
      {this.isSuccessful, this.message, this.isException, this.notifications});

  factory NotificationResponse.fromJson(Map json) {
    var list = json['notifications'] as List;
    List<Notifications> notificationList =
        list.map((i) => Notifications.fromJson(i)).toList();
    return NotificationResponse(
      isSuccessful: json['IsSuccessful'],
      message: json['Message'],
      isException: json['IsServerException'],
      notifications: notificationList,
    );
  }
}

class Notifications {
  const Notifications({
    this.notifySubject,
    this.notifyMessage,
    this.generatedOn,
  });
  final String? notifySubject;
  final String? notifyMessage;
  final String? generatedOn;

  factory Notifications.fromJson(Map json) {
    return Notifications(
      notifySubject: json['Notif_Subject'] as String,
      notifyMessage: json['Notif_Message'] as String,
      generatedOn: json['GeneratedOn'] as String,
    );
  }
}
