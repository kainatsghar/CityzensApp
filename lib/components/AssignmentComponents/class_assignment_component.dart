import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/model/Assignment/assignment_response.dart';
import 'package:tcs_app/provider/Assignment/assignment_provider.dart';
import '../../custom_widgets/CustomDialogBoxes/delete_confirm_dialog.dart';
import '../../custom_widgets/UnifiedAcademicCard/unified_academic_card.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_message_image.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../routes/app_navigation_routes.dart';
import '../../routes/app_navigation.dart';

class AssignmentRecordComponent extends StatefulWidget {
  const AssignmentRecordComponent({super.key});

  @override
  State<AssignmentRecordComponent> createState() =>
      _AssignmentRecordComponentState();
}

class _AssignmentRecordComponentState extends State<AssignmentRecordComponent> {
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
      '${AppConstants.baseUrl}/MobileAppAttachments/$fileName',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    int id,
    AssignmentProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return DeleteConfirmDialog(
          title: 'Delete Classwork',
          description:
              'Are you sure you want to delete this classwork entry? This action cannot be undone.',
          onDelete: () => provider.deleteAssignment(id),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssignmentProvider>(
      builder: (context, value, _) {
        // Handle loading state
        if (value.assignmentResponse == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final records = value.assignmentResponse!.assignmentRecords ?? [];

        // Handle empty state
        if (records.isEmpty) {
          if (localData.userData!.userType == 'Teacher') {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 72,
                    color: AppColors.primaryColor.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Classwork Entries',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + to add classwork for your class',
                    style: TextStyle(fontSize: 14, color: AppColors.grey400),
                  ),
                ],
              ),
            );
          }
          return const ShowMessageOnImage(message: 'No Classwork Entries');
        }

        // Group assignments by date
        final Map<String, List<AssignmentRecords>> groupedAssignments = {};
        for (var record in records) {
          final date = record.classWorkDateOnly;
          if (date.isNotEmpty) {
            groupedAssignments.putIfAbsent(date, () => []).add(record);
          }
        }

        final sortedDates = groupedAssignments.keys.toList()
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
              final List<AssignmentRecords> assignments =
                  groupedAssignments[dateStr]!;

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
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.warningOrange.withValues(alpha: 0.04),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.warningOrange.withValues(alpha: 0.12),
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
                          color: AppColors.warningOrange.withValues(alpha: 0.12),
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
                              color: AppColors.warningOrange,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                color: AppColors.primaryDarkBlue,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Inner list of Assignments
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: List.generate(assignments.length, (idx) {
                            final assignment = assignments[idx];
                            return UnifiedAcademicCard(
                              key: ValueKey('${assignment.id}_$idx'),
                              title: assignment.subject ?? 'No Subject',
                              description: assignment.description,
                              fileName: assignment.fileName,
                              badgeText: assignment.sectionName,
                              accentColor: AppColors.warningOrange,
                              isTeacher:
                                  localData.userData!.userType == 'Teacher',
                              onEdit: () => AppNavigation.navigateTo(
                                AppNavRoutes.addAssignmentRoute,
                                arguments: assignment,
                              ),
                              onDelete: () => _showDeleteConfirmDialog(
                                context,
                                assignment.id!,
                                value,
                              ),
                              onTapAttachment: () =>
                                  _launchFile(assignment.fileName!),
                              onTapLink: (url) => HelperFunction.launchURL(url),
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
