import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:tcs_app/CustomWidgets/CustomExpansionTile/custom_expansion_tile.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/model/Notifications/notification_response.dart';

class NotificationItem extends StatelessWidget {
  final Notifications notification;
  final ValueChanged<String> onTap;
  final int index;

  const NotificationItem(
      {super.key,
      required this.notification,
      required this.onTap,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CustomExpansionTile(
        title: '${'$index'.padLeft(2, '0')} - ${notification.notifySubject}',
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Linkify(
                        onOpen: (v) => onTap,
                        text: notification.notifyMessage!,
                        style: const TextStyle(
                            fontSize: 15, color: AppColors.blackColor)),
                  ),
                ),
                Text(
                  HelperFunction.dateFormatter('${notification.generatedOn}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
