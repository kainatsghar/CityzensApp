import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/NotificationComponents/notification_item.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_message_image.dart';
import 'package:tcs_app/provider/Notifications/notification_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';

class NotificationComponent extends StatelessWidget {
  const NotificationComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, value, _) {
        if (value.notifications == null || value.notifications!.isEmpty) {
          return ShowMessageOnImage(
            message:
                value.currentNotificationGroup == NotificationGroup.circulars
                ? 'No recent Circulars\nuploaded'
                : 'No ${value.currentNotificationGroup.name}\n notifications available',
          );
        }

        return Column(
          children: [
            Expanded(
              child: Container(
                color: AppColors.ultraLightGrey,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 32),
                  itemCount: value.notifications!.length,
                  itemBuilder: (BuildContext context, int index) =>
                      NotificationItem(
                        index: index + 1,
                        notification: value.notifications![index],
                        onTap: (url) => value.loadURL(url),
                      ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
