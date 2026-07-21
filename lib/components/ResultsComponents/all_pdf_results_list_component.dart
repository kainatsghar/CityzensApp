import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/model/Results/all_pdf_results_response.dart';
import 'package:tcs_app/provider/Results/results_provider.dart';
import 'package:tcs_app/screens/Results/result_pdf_viewer_screen.dart';
import 'package:tcs_app/services/Results/result_pdf_download_service.dart';
import '../../custom_widgets/ShowCustomMessage/show_custom_message.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';

class AllPDFResultsListComponent extends StatelessWidget {
  const AllPDFResultsListComponent({super.key});

  /// Downloads the backend PDF (cache-first) and opens it. Falls back to the
  /// system print sheet (via the viewer) when the backend has no PDF.
  Future<void> _handleSaveOrOpen(
    BuildContext context,
    ResultsProvider provider,
    PDFResultItem item,
  ) async {
    HapticFeedback.lightImpact();
    if ((item.url ?? '').isEmpty) return;

    final messenger = ScaffoldMessenger.of(context);

    if (provider.isPdfDownloaded(item)) {
      try {
        await provider.openCachedResultPdf(item);
      } catch (_) {
        _showError(messenger);
      }
      return;
    }

    try {
      await provider.downloadResultPdf(item);
    } on NoServerPdfException {
      // Backend has no PDF → use the system print fallback in the viewer.
      if (context.mounted) _openViewer(context, item, autoPrint: true);
    } catch (_) {
      _showError(messenger);
    }
  }

  void _openViewer(
    BuildContext context,
    PDFResultItem item, {
    bool autoPrint = false,
  }) {
    HapticFeedback.lightImpact();
    final url = item.url ?? '';
    if (url.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPDFViewerScreen(
          url: url,
          title: item.displayName,
          autoPrint: autoPrint,
        ),
      ),
    );
  }

  void _showError(ScaffoldMessengerState messenger) {
    messenger.removeCurrentSnackBar();
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Could not open the PDF. Please try again.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ResultsProvider>(
        builder: (context, value, _) {
          final allResults = List<PDFResultItem>.from(
            value.allPDFResultsResponse?.pdfResults ?? [],
          );

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
                            backgroundColor: AppColors.white,
                            checkmarkColor: AppColors.white,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? AppColors.white
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
                    final hasUrl = url.isNotEmpty;
                    final downloaded = value.isPdfDownloaded(item);
                    final downloading = value.isPdfDownloading(item);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        color: AppColors.white,
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
                                      if (downloaded)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          margin: const EdgeInsets.only(
                                            right: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.successGreen
                                                .withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Text(
                                            'SAVED',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.successGreen,
                                            ),
                                          ),
                                        ),
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
                                      OutlinedButton.icon(
                                        onPressed: (hasUrl && !downloading)
                                            ? () => _handleSaveOrOpen(
                                                context,
                                                value,
                                                item,
                                              )
                                            : null,
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: hasUrl
                                                ? AppColors.primaryBlue
                                                : AppColors.softGreyText,
                                            width: 1.5,
                                          ),
                                          foregroundColor:
                                              AppColors.primaryBlue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 10,
                                          ),
                                          elevation: 0,
                                        ),
                                        icon: downloading
                                            ? const SizedBox(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color:
                                                          AppColors.primaryBlue,
                                                    ),
                                              )
                                            : Icon(
                                                downloaded
                                                    ? Icons.folder_open_rounded
                                                    : Icons
                                                          .picture_as_pdf_rounded,
                                                size: 16,
                                              ),
                                        label: Text(
                                          downloading
                                              ? 'PREPARING…'
                                              : (downloaded
                                                    ? 'OPEN PDF'
                                                    : 'SAVE AS PDF'),
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      ElevatedButton.icon(
                                        onPressed: hasUrl
                                            ? () => _openViewer(context, item)
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              AppColors.primaryBlue,
                                          foregroundColor: AppColors.white,
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
                                          Icons.visibility_rounded,
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
