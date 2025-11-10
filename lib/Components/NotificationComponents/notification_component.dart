import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/NotificationComponents/notification_item.dart';
import 'package:tcs_app/CustomWidgets/ShowCustomMessage/show_message_image.dart';
import 'package:tcs_app/Provider/Notifications/notification_provider.dart';

import '../../CustomWidgets/CustomCoverImage/custom_cover_image.dart';

class NotificationComponent extends StatelessWidget {
  const NotificationComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Consumer<NotificationProvider>(
        builder: (context, value, _) {
          return Container(
            margin: EdgeInsets.only(top: size.height * 0.03),
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8.0),
            child: value.notifications!.isEmpty
                ? ShowMessageOnImage(
                    message:
                        value.currentNotificationGroup ==
                            NotificationGroup.circulars
                        ? 'No recent Circulars\nuploaded'
                        : 'No ${value.currentNotificationGroup.name}\n notifications available',
                  )
                : Column(
                    children: [
                      const CustomCoverImage(
                        title: 'CIRCULARS',
                        imagePath: 'notification_icon.png',
                      ),
                      Flexible(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          itemCount: value.notifications!.length,
                          itemBuilder: (BuildContext context, int index) =>
                              NotificationItem(
                                index: index + 1,
                                notification: value.notifications![index],
                                onTap: (url) => value.loadURL(url),
                              ),
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
