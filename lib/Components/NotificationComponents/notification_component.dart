import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/NotificationComponents/notification_item.dart';
import 'package:tcs_app/CustomWidgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/Provider/Notifications/notification_provider.dart';
import 'package:tcs_app/Utils/app_constants.dart';

class NotificationComponent extends StatelessWidget {
  const NotificationComponent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(builder: (context, value, _) {
      return value.notifications.isEmpty
          ? ShowCustomMessage(message: AppConstants.noRecordFound)
          : ListView.builder(
              padding: const EdgeInsets.all(0.0),
              itemCount: value.notifications.length,
              itemBuilder: (BuildContext context, int index) =>
                  NotificationItem(
                      notification: value.notifications[index],
                      onTap: (url) => value.loadURL(url)));
    });
  }
}
