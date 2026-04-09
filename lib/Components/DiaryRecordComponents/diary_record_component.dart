import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_message_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/Diary/diary_response.dart';
import '../../provider/Diary/diary_provider.dart';
import '../../provider/LocalData/local_data_provider.dart';
import '../../routes/app_navigation.dart';
import '../../routes/app_navigation_routes.dart';

class DiaryRecordComponent extends StatefulWidget {
  const DiaryRecordComponent({super.key});

  @override
  State<DiaryRecordComponent> createState() => _DiaryRecordComponentState();
}

class _DiaryRecordComponentState extends State<DiaryRecordComponent> {
  var localData = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  Future<void> _launchFile(String fileName) async {
    final Uri url = Uri.parse(
      '${AppConstants.baseUrl}/MobileAppAttachments/DailyDiary/$fileName',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    int id,
    DiaryProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Delete Homework',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to delete this homework diary entry? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () {
                Navigator.of(ctx).pop();
                provider.deleteDiary(id);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DiaryProvider>(
      builder: (context, value, _) {
        // Handle loading state (no data loaded yet)
        if (value.diaryResponse == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final diaryRecords = value.diaryResponse!.diaryRecords ?? [];

        // Handle empty state
        if (diaryRecords.isEmpty) {
          if (localData.userData!.userType == 'Teacher') {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 72,
                    color: AppColors.primaryColor.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Homework Entries',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add homework for your class',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                ],
              ),
            );
          }
          return const ShowMessageOnImage(message: 'No Homework Entries');
        }

        return GroupedListView<DiaryRecords, String>(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          elements: diaryRecords,
          groupBy: (element) => element.diaryDateOnly,
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
                color: AppColors.primaryBlue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.15),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: AppColors.primaryBlue,
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
          itemBuilder: (context, DiaryRecords element) => _DiaryCard(
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

class _DiaryCard extends StatelessWidget {
  final DiaryRecords element;
  final void Function(BuildContext, int, DiaryProvider) onDelete;
  final Future<void> Function(String) onLaunchFile;
  final bool isTeacher;

  const _DiaryCard({
    required this.element,
    required this.onDelete,
    required this.onLaunchFile,
    required this.isTeacher,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DiaryProvider>(
      builder: (context, provider, _) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primaryBlue.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
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
                  // Accent bar - Blue for Diary
                  Container(
                    width: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  // Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header row: Subject + Section chip
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  element.subject?.isNotEmpty == true
                                      ? element.subject!
                                      : 'No Subject',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryDarkColor,
                                    height: 1.2,
                                  ),
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
                                    color: AppColors.primaryBlue.withOpacity(
                                      0.12,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.primaryBlue.withOpacity(
                                        0.2,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    element.sectionName!,
                                    style: const TextStyle(
                                      color: AppColors.primaryBlue,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          // Description
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
                          // Attachment pill
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
                          // Divider + Actions
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
                                    AppNavRoutes.addDiaryRoute,
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
