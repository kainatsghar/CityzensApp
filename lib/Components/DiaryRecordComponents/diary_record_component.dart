import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_message_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../custom_widgets/CustomDialogBoxes/delete_confirm_dialog.dart';
import '../../custom_widgets/UnifiedAcademicCard/unified_academic_card.dart';
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
        return DeleteConfirmDialog(
          title: 'Delete Homework',
          description:
              'Are you sure you want to delete this homework diary entry? This action cannot be undone.',
          onDelete: () => provider.deleteDiary(id),
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

        // Group diaries by date
        final Map<String, List<DiaryRecords>> groupedDiaries = {};
        for (var record in diaryRecords) {
          final date = record.diaryDateOnly;
          if (date.isNotEmpty) {
            groupedDiaries.putIfAbsent(date, () => []).add(record);
          }
        }

        final sortedDates = groupedDiaries.keys.toList()
          ..sort((a, b) => b.compareTo(a));

        return Scrollbar(
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
              final List<DiaryRecords> diaries = groupedDiaries[dateStr]!;

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
                        color: AppColors.primaryBlue.withOpacity(0.04),
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
                      color: AppColors.primaryBlue.withOpacity(0.08),
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
                          color: AppColors.primaryBlue.withOpacity(0.08),
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
                              color: AppColors.primaryBlue,
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
        
                      // Inner list of Diaries
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: List.generate(diaries.length, (idx) {
                            final diary = diaries[idx];
                            return UnifiedAcademicCard(
                              key: ValueKey('${diary.id}_$idx'),
                              title: diary.subject ?? 'No Subject',
                              description: diary.description,
                              fileName: diary.fileName,
                              badgeText: diary.sectionName,
                              accentColor: AppColors.primaryBlue,
                              isTeacher: localData.userData!.userType == 'Teacher',
                              onEdit: () => AppNavigation.navigateTo(
                                AppNavRoutes.addDiaryRoute,
                                arguments: diary,
                              ),
                              onDelete: () => _showDeleteConfirmDialog(
                                context,
                                diary.id!,
                                value,
                              ),
                              onTapAttachment: () => _launchFile(diary.fileName!),
                              onTapLink: (url) async {
                                final Uri uri = Uri.parse(url);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                }
                              },
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
        );
      },
    );
  }
}
