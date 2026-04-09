import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:tcs_app/model/Notifications/notification_response.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationItem extends StatefulWidget {
  final Notifications notification;
  final ValueChanged<String> onTap;
  final int index;

  const NotificationItem({
    super.key,
    required this.notification,
    required this.onTap,
    required this.index,
  });

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool _isExpanded = false;

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
    String formattedDate = 'Unknown Date';
    try {
      if (widget.notification.generatedOn != null &&
          widget.notification.generatedOn!.isNotEmpty) {
        formattedDate = DateFormat(
          'MMMM dd, yyyy',
        ).format(DateTime.parse(widget.notification.generatedOn!));
      }
    } catch (e) {
      formattedDate = widget.notification.generatedOn ?? 'Unknown Date';
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.lightRedColor.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightRedColor.withOpacity(0.1), width: 1),
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
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Accent bar - Red for Circulars
              Container(
                width: 6,
                decoration: const BoxDecoration(color: AppColors.lightRedColor),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Index + Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lightRedColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '#${widget.index.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColors.lightRedColor,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 12,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Subject
                      Text(
                        widget.notification.notifySubject ?? 'No Subject',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryDarkColor,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Message
                      Linkify(
                        onOpen: (link) => widget.onTap(link.url),
                        text: widget.notification.notifyMessage ?? '',
                        maxLines: _isExpanded ? null : 3,
                        overflow: _isExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.grey.shade700,
                        ),
                        linkStyle: const TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),

                      // Read More Toggle
                      if (widget.notification.notifyMessage != null &&
                          widget.notification.notifyMessage!.length > 100)
                        GestureDetector(
                          onTap: () =>
                              setState(() => _isExpanded = !_isExpanded),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              _isExpanded ? 'Show Less' : 'Read More',
                              style: const TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      // Attachment Section
                      if (widget.notification.fileName != null &&
                          widget.notification.fileName!.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        InkWell(
                          onTap: () =>
                              _launchFile(widget.notification.fileName ?? ''),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primaryColor.withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.attach_file_rounded,
                                  size: 18,
                                  color: AppColors.primaryColor,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'ATTACHMENT',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primaryColor,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      Text(
                                        widget.notification.fileName!,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.primaryDarkColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.download_for_offline_rounded,
                                  color: AppColors.primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
