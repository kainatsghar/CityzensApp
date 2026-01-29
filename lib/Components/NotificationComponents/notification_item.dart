import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:tcs_app/custom_widgets/CustomExpansionTile/custom_expansion_tile.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:tcs_app/model/Notifications/notification_response.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationItem extends StatelessWidget {
  final Notifications notification;
  final ValueChanged<String> onTap;
  final int index;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
    required this.index,
  });

  Future<void> _launchFile(String fileName) async {
    final Uri url = Uri.parse(
      '${AppConstants.baseUrl}/MobileCircularAnnouncement/$fileName',
    );

    if (await launchUrl(url, mode: LaunchMode.externalApplication)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CustomExpansionTile(
        title: '${'$index'.padLeft(2, '0')} - ${notification.notifySubject}',
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Linkify(
                          onOpen: (v) => onTap,
                          text: notification.notifyMessage!,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      HelperFunction.dateFormatter(
                        '${notification.generatedOn}',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                (notification.fileName != null && notification.fileName != "")
                    ? GestureDetector(
                        onTap: () {
                          _launchFile(notification.fileName ?? '');
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.fileName ?? '',
                                  style: const TextStyle(
                                    color: AppColors.primaryDarkColor,
                                  ),
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ), // File name text
                              SizedBox(width: 8),
                              IconButton.filled(
                                style: IconButton.styleFrom(
                                  backgroundColor: AppColors.primaryDarkColor,
                                ),
                                onPressed: () {
                                  _launchFile(notification.fileName ?? '');
                                },
                                icon: const Icon(Icons.download),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
