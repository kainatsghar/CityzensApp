import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../custom_widgets/CustomDialogBoxes/delete_confirm_dialog.dart';
import '../../model/CircularAnnouncement/circular_announcement_response.dart';
import '../../provider/Circular/circular_provider.dart';
import '../../provider/LocalData/local_data_provider.dart';
import '../../routes/app_navigation.dart';
import '../../routes/app_navigation_routes.dart';

class CircularRecordComponent extends StatefulWidget {
  const CircularRecordComponent({super.key});

  @override
  State<CircularRecordComponent> createState() =>
      _CircularRecordComponentState();
}

class _CircularRecordComponentState extends State<CircularRecordComponent> {
  var localData = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  Future<void> _launchFile(String fileName) async {
    final Uri url = Uri.parse(
      '${AppConstants.baseUrl}/MobileCircularAnnouncement/$fileName',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    int id,
    CircularProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return DeleteConfirmDialog(
          title: 'Delete Circular',
          description:
              'Are you sure you want to delete this circular? This action cannot be undone.',
          onDelete: () => provider.deleteCircular(id),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CircularProvider>(
      builder: (context, value, _) {
        // Handle loading state
        if (value.circularResponse == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final records = value.circularResponse!.circularRecords ?? [];

        // Handle empty state
        if (records.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.campaign_outlined,
                  size: 72,
                  color: AppColors.primaryColor.withOpacity(0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'No Circulars Yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + to send a new circular announcement',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                ),
              ],
            ),
          );
        }

        return GroupedListView<CircularAnnouncementRecords, String>(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          elements: records,
          groupBy: (element) => element.circularDateOnly,
          groupSeparatorBuilder: (String groupByValue) {
            String formattedDate = 'Unknown Date';
            try {
              if (groupByValue.isNotEmpty) {
                formattedDate = DateFormat(
                  'MMMM dd, yyyy',
                ).format(DateTime.parse(groupByValue));
              }
            } catch (e) {
              formattedDate = groupByValue;
            }

            if (groupByValue.isEmpty) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.only(top: 24, bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.lightRedColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.lightRedColor.withOpacity(0.15),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
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
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            );
          },
          itemBuilder: (context, CircularAnnouncementRecords element) =>
              _CircularCard(
                element: element,
                onDelete: _showDeleteConfirmDialog,
                onLaunchFile: _launchFile,
                isTeacher: localData.userData!.userType == 'Teacher',
              ),
          order: GroupedListOrder.DESC,
        );
      },
    );
  }
}

class _CircularCard extends StatelessWidget {
  final CircularAnnouncementRecords element;
  final void Function(BuildContext, int, CircularProvider) onDelete;
  final Future<void> Function(String) onLaunchFile;
  final bool isTeacher;

  const _CircularCard({
    required this.element,
    required this.onDelete,
    required this.onLaunchFile,
    required this.isTeacher,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CircularProvider>(
      builder: (context, provider, _) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          decoration: BoxDecoration(
            color: AppColors.lightRedColor.withOpacity(0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.lightRedColor.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.lightRedColor.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
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
                    decoration: const BoxDecoration(
                      color: AppColors.lightRedColor,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title row + Section chip
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      element.title?.isNotEmpty == true
                                          ? element.title!
                                          : 'No Title',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryDarkColor,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time_rounded,
                                          size: 12,
                                          color: Colors.grey.shade500,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          DateFormat('MMM dd, yyyy').format(
                                            DateTime.parse(
                                              element.announcementDate!,
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (element.sectionName?.isNotEmpty == true) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightRedColor.withOpacity(
                                      0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.lightRedColor
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                  child: Text(
                                    element.sectionName!,
                                    style: const TextStyle(
                                      color: AppColors.lightRedColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (element.description?.isNotEmpty == true) ...[
                            const SizedBox(height: 10),
                            Text(
                              element.description!,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                          if (element.fileName?.isNotEmpty == true) ...[
                            const SizedBox(height: 12),
                            InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () => onLaunchFile(element.fileName!),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor.withOpacity(
                                    0.06,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.2,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.attach_file_rounded,
                                      size: 15,
                                      color: AppColors.primaryColor,
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(
                                        element.fileName!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          // Actions
                          if (isTeacher) ...[
                            const Padding(
                              padding: EdgeInsets.only(top: 14, bottom: 6),
                              child: Divider(height: 1, thickness: 0.5),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _ActionButton(
                                  icon: Icons.delete_outline_rounded,
                                  label: 'Delete',
                                  color: Colors.redAccent,
                                  onTap: () =>
                                      onDelete(context, element.id!, provider),
                                ),
                                const SizedBox(width: 4),
                                _ActionButton(
                                  icon: Icons.edit_outlined,
                                  label: 'Edit',
                                  color: AppColors.primaryColor,
                                  onTap: () => AppNavigation.navigateTo(
                                    AppNavRoutes.addCircularRoute,
                                    arguments: element,
                                  ),
                                ),
                              ],
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
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 17, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
