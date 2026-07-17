import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/model/Results/all_pdf_results_response.dart';
import 'package:tcs_app/provider/Results/results_provider.dart';
import 'package:tcs_app/utils/helper_function.dart';
import '../../custom_widgets/ShowCustomMessage/show_custom_message.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';

class AllPDFResultsListComponent extends StatelessWidget {
  const AllPDFResultsListComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ResultsProvider>(
        builder: (context, value, _) {
          final allResults = List<PDFResultItem>.from(
            value.allPDFResultsResponse?.pdfResults ?? [],
          );

          // Sort in descending order based on SMSDate (latest at top, oldest at bottom)
          allResults.sort((a, b) {
            final aDate = a.smsDate ?? '';
            final bDate = b.smsDate ?? '';
            return bDate.compareTo(aDate);
          });

          if (allResults.isEmpty) {
            return const Center(
              child: ShowCustomMessage(message: AppConstants.noRecordFound),
            );
          }

          final uniqueClasses = allResults
              .map((e) => e.className ?? 'Unknown Class')
              .toSet()
              .toList();

          final String? activeClassName =
              value.selectedPDFClassName ??
              (uniqueClasses.isNotEmpty ? uniqueClasses.first : null);

          final resultsList = allResults
              .where((e) => (e.className ?? 'Unknown Class') == activeClassName)
              .toList();

          final displayClasses = uniqueClasses.take(3).toList();
          final hasMoreClasses = uniqueClasses.length > 3;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (uniqueClasses.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  child: Row(
                    children: [
                      ...displayClasses.map((className) {
                        final isSelected = className == activeClassName;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(className),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                value.setSelectedPDFClassName(className);
                              }
                            },
                            selectedColor: AppColors.primaryBlue,
                            backgroundColor: Colors.white,
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            side: BorderSide(
                              color: AppColors.primaryBlue.withValues(
                                alpha: isSelected ? 1.0 : 0.3,
                              ),
                              width: 1.5,
                            ),
                            elevation: isSelected ? 2 : 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        );
                      }),
                      if (hasMoreClasses)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ActionChip(
                            label: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('More Classes'),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_drop_down, size: 18),
                              ],
                            ),
                            onPressed: () =>
                                value.pdfClassBottomSheet(uniqueClasses),
                            backgroundColor: AppColors.primaryBlue.withValues(
                              alpha: 0.05,
                            ),
                            labelStyle: const TextStyle(
                              color: AppColors.primaryDarkBlue,
                              fontWeight: FontWeight.w600,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            side: BorderSide(
                              color: AppColors.borderGrey.withValues(
                                alpha: 0.5,
                              ),
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  itemCount: resultsList.length,
                  itemBuilder: (context, index) {
                    final item = resultsList[index];
                    final title = item.displayName;
                    final String url = item.url ?? '';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryBlue.withValues(
                              alpha: 0.06,
                            ),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.borderGrey.withValues(alpha: 0.5),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            // Side Accent Bar
                            Positioned(
                              left: 0,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                width: 6,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          title.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.primaryDarkBlue,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryBlue
                                              .withValues(alpha: 0.08),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          item.className?.toUpperCase() ?? '',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.primaryBlue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  if (item.fullname != null) ...[
                                    Text(
                                      item.fullname!.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.neutral700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                  if (item.centerName != null) ...[
                                    Text(
                                      item.centerName!.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.neutral500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                  const Divider(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: url.isNotEmpty
                                            ? () {
                                                HapticFeedback.lightImpact();
                                                HelperFunction.launchURL(url);
                                              }
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryBlue,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 10,
                                          ),
                                          elevation: 0,
                                        ),
                                        icon: const Icon(
                                          Icons.open_in_new_rounded,
                                          size: 16,
                                        ),
                                        label: const Text(
                                          'VIEW RESULT',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
