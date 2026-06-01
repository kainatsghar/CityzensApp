import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/NotificationComponents/notification_item.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_message_image.dart';
import 'package:tcs_app/model/Notifications/notification_response.dart';
import 'package:tcs_app/provider/Notifications/notification_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';
import '../../custom_widgets/UnifiedAcademicCard/unified_academic_card.dart';

class NotificationComponent extends StatefulWidget {
  const NotificationComponent({super.key});

  @override
  State<NotificationComponent> createState() => _NotificationComponentState();
}

class _NotificationComponentState extends State<NotificationComponent> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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

        // Group notifications by date part of generatedOn
        final Map<String, List<Notifications>> groupedNotifications = {};
        for (var record in value.notifications!) {
          final date = (record.generatedOn ?? '').split('T')[0];
          if (date.isNotEmpty) {
            groupedNotifications.putIfAbsent(date, () => []).add(record);
          }
        }

        final sortedDates = groupedNotifications.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return Container(
          color: AppColors.white,
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            thickness: 6.0,
            radius: const Radius.circular(8),
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: sortedDates.length,
              itemBuilder: (context, index) {
                final String dateStr = sortedDates[index];
                final List<Notifications> notifications =
                    groupedNotifications[dateStr]!;

                String formattedDate = 'Unknown Date';
                try {
                  formattedDate = DateFormat(
                    'MMMM dd, yyyy',
                  ).format(DateTime.parse(dateStr));
                } catch (e) {
                  formattedDate = dateStr;
                }

                return KeepAliveWrapper(
                  key: ValueKey(dateStr),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.lightRedColor.withOpacity(0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.lightRedColor.withOpacity(0.08),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Highlighted Date Header
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lightRedColor.withOpacity(0.08),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(19),
                              topRight: Radius.circular(19),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 16,
                                color: AppColors.lightRedColor,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  color: AppColors.primaryDarkColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Inner list of Notifications
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: List.generate(notifications.length, (
                              idx,
                            ) {
                              final notification = notifications[idx];
                              return NotificationItem(
                                key: ValueKey(
                                  '${notification.notifySubject}_${notification.generatedOn}_$idx',
                                ),
                                index: idx + 1,
                                notification: notification,
                                onTap: (url) => value.loadURL(url),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
