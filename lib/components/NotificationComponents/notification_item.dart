import 'package:flutter/material.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:tcs_app/model/Notifications/notification_response.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../custom_widgets/UnifiedAcademicCard/unified_academic_card.dart';

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

    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return UnifiedAcademicCard(
      key: ValueKey(
        '${notification.notifySubject}_${notification.generatedOn}_$index',
      ),
      title: notification.notifySubject ?? 'No Subject',
      description: notification.notifyMessage,
      fileName: notification.fileName,
      accentColor: AppColors.lightRed,
      isTeacher: false,
      onTapAttachment: () => _launchFile(notification.fileName ?? ''),
      onTapLink: onTap,
    );
  }
}
