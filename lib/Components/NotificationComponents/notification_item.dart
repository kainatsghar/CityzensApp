import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:tcs_app/model/Notifications/notification_response.dart';

class NotificationItem extends StatelessWidget {
  final Notifications notification;
  final ValueChanged<String> onTap;

  const NotificationItem({Key key, this.notification, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
            padding: EdgeInsets.all(5.0),
            child: ListTile(
                title: Text(notification.notifySubject,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Linkify(
                    onOpen: (v) => onTap,
                    text: notification.notifyMessage,
                    style: TextStyle(fontSize: 13, color: Colors.black87)))));
  }
}
