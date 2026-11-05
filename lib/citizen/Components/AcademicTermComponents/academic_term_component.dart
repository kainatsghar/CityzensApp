import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/citizen/Model/AcademicTerm/academic_term_response.dart';
import 'package:tcs_app/citizen/Provider/Results/results_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/Utils/helper_function.dart';

class AcademicTermComponent extends StatefulWidget {
  final VoidCallback onRefresh;

  const AcademicTermComponent({
    super.key,
    required this.onRefresh,
  });

  @override
  State<AcademicTermComponent> createState() => _AcademicTermComponentState();
}

class _AcademicTermComponentState extends State<AcademicTermComponent> {
  int _selectedSessionIndex = 0;
  bool _isLoadingPdf = false;
  int? _loadingPdfTermId;

  @override
  Widget build(BuildContext context) {
    return Consumer<ResultsProvider>(
      builder: (context, provider, _) {
        final List<AcademicTerm> sessions = provider.academicYears;
        final List<AcademicTerm> terms = provider.terms;

        if (sessions.isEmpty) {
          return Column(
            children: [
              _buildTopHeader(context, null, 0),
              const Expanded(
                child: Center(
                  child: ShowCustomMessage(message: AppConstants.noRecordFound),
                ),
              ),
            ],
          );
        }

        final int safeIndex =
            _selectedSessionIndex.clamp(0, sessions.length - 1);
        final AcademicTerm selectedSession = sessions[safeIndex];

        return Column(
          children: [
            // S7 Blue Header with Class / Session chips
            _buildTopHeader(context, sessions, safeIndex),

            // S7 Body with Reports
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Header (Class / Session name + count)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            selectedSession.name ?? 'Academic Reports',
                            style: AppThemes.sora(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          Text(
                            terms.isNotEmpty
                                ? '${terms.length} ${terms.length == 1 ? 'report' : 'reports'}'
                                : '0 reports',
                            style: AppThemes.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Reports List or Empty
                    if (terms.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(
                          child: ShowCustomMessage(
                            message: AppConstants.noRecordFound,
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: terms.length,
                        separatorBuilder: (_, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final AcademicTerm term = terms[index];
                          final bool isLatest =
                              (safeIndex == 0 && index == 0);

                          return _buildReportCard(
                            context: context,
                            provider: provider,
                            session: selectedSession,
                            term: term,
                            isLatest: isLatest,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopHeader(
    BuildContext context,
    List<AcademicTerm>? sessions,
    int activeIndex,
  ) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Bar Row
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    'Term results',
                    style: AppThemes.sora(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.13),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: widget.onRefresh,
                    ),
                  ),
                ],
              ),
            ),

            // Horizontal Segmented Chips
            if (sessions != null && sessions.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: List.generate(sessions.length, (i) {
                      final bool isSelected = (i == activeIndex);
                      final session = sessions[i];

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedSessionIndex = i;
                            });
                          },
                          borderRadius: BorderRadius.circular(999),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.yellow
                                  : Colors.white.withValues(alpha: 0.13),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected) ...[
                                  const Icon(
                                    Icons.check_rounded,
                                    size: 15,
                                    color: AppColors.blue,
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  session.name ?? '',
                                  style: AppThemes.sora(
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: isSelected
                                        ? AppColors.blue
                                        : Colors.white.withValues(alpha: 0.92),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard({
    required BuildContext context,
    required ResultsProvider provider,
    required AcademicTerm session,
    required AcademicTerm term,
    required bool isLatest,
  }) {
    final String reportTitle =
        '${term.name ?? ''} Exam Report Card ${session.name ?? ''}'.trim();
    final bool isPdfLoadingThis =
        _isLoadingPdf && (_loadingPdfTermId == term.id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(15, 52, 102, 0.06),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Icon + Badge + Title
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8C4),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  color: AppColors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isLatest) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: AppColors.yellow,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'LATEST',
                          style: AppThemes.sora(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                    ],
                    Text(
                      reportTitle,
                      style: AppThemes.sora(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Action Buttons: View result + PDF
          Row(
            children: [
              // View result Button
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    onPressed: () {
                      provider.selectAcademicYear = session.id ?? 0;
                      provider.selectedTerm = term.id ?? 0;
                      provider.academicYearController.text =
                          session.name ?? '';
                      provider.termController.text = term.name ?? '';
                      AppNavigation.navigateTo(AppNavRoutes.resultsRoute);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.visibility_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'View result',
                          style: AppThemes.sora(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // PDF Button
              SizedBox(
                height: 42,
                width: 90,
                child: ElevatedButton(
                  onPressed: isPdfLoadingThis
                      ? null
                      : () async {
                          setState(() {
                            _isLoadingPdf = true;
                            _loadingPdfTermId = term.id;
                          });

                          try {
                            final String? url =
                                await provider.getPdfUrlFor(
                              academicYearId: session.id ?? 0,
                              termId: term.id ?? 0,
                            );

                            if (url != null && url.trim().isNotEmpty) {
                              HelperFunction.launchURL(url.trim());
                            } else {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'PDF report is not available for this term.',
                                    ),
                                  ),
                                );
                              }
                            }
                          } finally {
                            if (mounted) {
                              setState(() {
                                _isLoadingPdf = false;
                                _loadingPdfTermId = null;
                              });
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blueTint,
                    foregroundColor: AppColors.blue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  child: isPdfLoadingThis
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.blue,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.file_download_outlined,
                              size: 16,
                              color: AppColors.blue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'PDF',
                              style: AppThemes.sora(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blue,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
