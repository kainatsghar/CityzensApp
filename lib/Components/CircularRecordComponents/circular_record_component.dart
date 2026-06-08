import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../custom_widgets/CustomDialogBoxes/delete_confirm_dialog.dart';
import '../../custom_widgets/UnifiedAcademicCard/unified_academic_card.dart';
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
                  color: AppColors.primaryColor.withValues(alpha: 0.3),
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

        // Group circulars by date
        final Map<String, List<CircularAnnouncementRecords>> groupedCirculars =
            {};
        for (var record in records) {
          final date = record.circularDateOnly;
          if (date.isNotEmpty) {
            groupedCirculars.putIfAbsent(date, () => []).add(record);
          }
        }

        final sortedDates = groupedCirculars.keys.toList()
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
              final List<CircularAnnouncementRecords> circulars =
                  groupedCirculars[dateStr]!;

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
                        color: AppColors.lightRedColor.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.lightRedColor.withValues(alpha: 0.08),
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
                          color: AppColors.lightRedColor.withValues(
                            alpha: 0.08,
                          ),
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

                      // Inner list of Circulars
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: List.generate(circulars.length, (idx) {
                            final circular = circulars[idx];

                            return UnifiedAcademicCard(
                              key: ValueKey('${circular.id}_$idx'),
                              title: circular.title ?? 'No Title',
                              description: circular.description,
                              fileName: circular.fileName,
                              badgeText: circular.sectionName,
                              accentColor: AppColors.lightRedColor,
                              isTeacher:
                                  localData.userData!.userType == 'Teacher',
                              onEdit: () => AppNavigation.navigateTo(
                                AppNavRoutes.addCircularRoute,
                                arguments: circular,
                              ),
                              onDelete: () => _showDeleteConfirmDialog(
                                context,
                                circular.id!,
                                value,
                              ),
                              onTapAttachment: () =>
                                  _launchFile(circular.fileName!),
                              onTapLink: (url) async {
                                final Uri uri = Uri.parse(url);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(
                                    uri,
                                    mode: LaunchMode.externalApplication,
                                  );
                                }
                              },
                              extraSubtitleRow: null,
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
