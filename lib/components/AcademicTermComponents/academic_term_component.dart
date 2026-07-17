import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomTextFormField/custom_text_form_field_v2.dart';
import 'package:tcs_app/model/Results/all_pdf_results_response.dart';
import 'package:tcs_app/provider/Results/results_provider.dart';
import 'package:tcs_app/screens/Results/result_pdf_viewer_screen.dart';
import 'package:tcs_app/services/Results/result_pdf_download_service.dart';
import 'package:tcs_app/utils/helper_function.dart';

import '../../custom_widgets/CustomCoverImage/custom_cover_image.dart';
import '../../custom_widgets/ShowCustomMessage/show_custom_message.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';

class AcademicTermComponent extends StatelessWidget {
  const AcademicTermComponent({super.key});

  PDFResultItem? _toPdfResultItem(ResultsProvider value) {
    final list = value.resultsResponse.pdfResultslist;
    if (list == null || list.isEmpty || list[0].url == null) return null;
    final pdf = list[0];
    return PDFResultItem(
      studentId: pdf.studentId,
      classId: pdf.classId,
      sessionId: pdf.sessionId,
      sectionId: pdf.sectionId,
      termGroupId: pdf.termGroupId,
      url: pdf.url,
      pdfUrl: pdf.pdfUrl,
      documentId: pdf.documentId,
      className: value.resultsResponse.info?.className,
      fullname: value.resultsResponse.info?.name,
      centerName: value.resultsResponse.info?.centerName,
    );
  }

  void _openViewer(
    BuildContext context,
    PDFResultItem item, {
    bool autoPrint = false,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultPDFViewerScreen(
          url: item.url!,
          title: item.displayName,
          autoPrint: autoPrint,
        ),
      ),
    );
  }

  /// Downloads the backend PDF (cache-first) and opens it. Falls back to the
  /// system print sheet (via the viewer) when the backend has no PDF.
  Future<void> _handleSaveOrOpen(
    BuildContext context,
    ResultsProvider provider,
    PDFResultItem item,
  ) async {
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
      if (context.mounted) _openViewer(context, item, autoPrint: true);
    } catch (_) {
      _showError(messenger);
    }
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
    Size size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Consumer<ResultsProvider>(
        builder: (context, value, _) {
          final item = _toPdfResultItem(value);
          final hasResult = value.termSelected && item != null;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Form(
              key: value.formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const CustomCoverImage(
                      title: 'RESULTS',
                      imagePath: 'class_result_c.png',
                    ),
                    SizedBox(height: size.height * 0.02),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 8.0,
                      ),
                      child: Column(
                        children: [
                          CustomTextFormFieldV2(
                            hintText: 'Academic Year'.toUpperCase(),
                            controller: value.academicYearController,
                            onTap: () => value.academicYearBottomSheet(),
                            readOnly: true,
                            validator: HelperFunction.validator,
                            suffixWidget: const ImageIcon(
                              AssetImage('assets/images/dropdown_icon.png'),
                              color: AppColors.primaryDarkColor,
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          CustomTextFormFieldV2(
                            hintText: 'Term'.toUpperCase(),
                            controller: value.termController,
                            onTap: () => value.termBottomSheet(),
                            readOnly: true,
                            validator: HelperFunction.validator,
                            suffixWidget: const ImageIcon(
                              AssetImage('assets/images/dropdown_icon.png'),
                              color: AppColors.primaryDarkColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.08),
                    if (hasResult)
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => _openViewer(context, item),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/pdf_download_icon.png',
                                  width: 100,
                                  height: 100,
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'CLICK TO VIEW RESULT',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Builder(
                            builder: (_) {
                              final isDownloaded = value.isPdfDownloaded(item);
                              final isDownloading = value.isPdfDownloading(
                                item,
                              );
                              return OutlinedButton.icon(
                                onPressed: isDownloading
                                    ? null
                                    : () => _handleSaveOrOpen(
                                        context,
                                        value,
                                        item,
                                      ),
                                icon: isDownloading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Icon(
                                        isDownloaded
                                            ? Icons.folder_open_rounded
                                            : Icons.picture_as_pdf_rounded,
                                      ),
                                label: Text(
                                  isDownloading
                                      ? 'PREPARING…'
                                      : (isDownloaded
                                            ? 'OPEN PDF'
                                            : 'SAVE AS PDF'),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    else
                      const ShowCustomMessage(
                        message: AppConstants.noRecordFound,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
