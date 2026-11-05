import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/ShowCustomMessage/show_message_image.dart';
import 'package:tcs_app/citizen/Model/FeeChallan/outstanding_challan_response.dart';
import 'package:tcs_app/citizen/Provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Routes/challan_args.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/gen/assets.gen.dart';

class OutstandingFeeComponent extends StatelessWidget {
  const OutstandingFeeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FeeChallanProvider>(
      builder: (context, value, _) {
        final List<OutstandingChallan>? responseData =
            value.outstandingChallans?.outstandingList;

        if (responseData != null && responseData.isNotEmpty) {
          responseData.sort(
            (a, b) => (b.issueDate ?? '').compareTo(a.issueDate ?? ''),
          );
        }

        if (responseData == null || responseData.isEmpty) {
          return Center(
            child: ShowMessageOnImage(
              message: 'No Pending Challan.\nCheck back later!',
              imagePath: Assets.images.bgCircularColored.path,
            ),
          );
        }

        final OutstandingChallan record = responseData.first;
        final List<OutstandingChallan>? arearMonths =
            responseData.length > 1 ? responseData.sublist(1) : null;

        final double arrearsTotal = arearMonths != null
            ? arearMonths.fold(
                0.0,
                (sum, item) => sum + (item.outstandingFee ?? 0.0),
              )
            : 0.0;

        final double totalPayable =
            (record.outstandingFee ?? 0.0) + arrearsTotal;

        final String dueDate = record.dueDate != null && record.dueDate!.isNotEmpty
            ? HelperFunction.dateFormatter(record.dueDate!)
            : '—';
        final String issueDate =
            record.issueDate != null && record.issueDate!.isNotEmpty
                ? HelperFunction.dateFormatter(record.issueDate!)
                : '—';
        final String validityDate =
            record.validityDate != null && record.validityDate!.isNotEmpty
                ? HelperFunction.dateFormatter(record.validityDate!)
                : '—';

        final StudentInfo? info = value.outstandingChallans?.info;

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            children: [
              // S9 Outstanding Due Card (.due)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.line),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(15, 52, 102, 0.06),
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Amount Header (.amt)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFFFF8C4), Color(0xFFFFFDF0)],
                        ),
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xFFF2EAB0), width: 1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL PAYABLE',
                            style: AppThemes.sora(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                              color: const Color(0xFF6B5900),
                            ),
                          ),
                          const SizedBox(height: 2),
                          RichText(
                            text: TextSpan(
                              text: 'PKR ',
                              style: AppThemes.sora(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.blue,
                              ),
                              children: [
                                TextSpan(
                                  text: HelperFunction()
                                      .formatCurrency(totalPayable)
                                      .replaceAll('PKR', '')
                                      .replaceAll('Rs', '')
                                      .trim(),
                                  style: AppThemes.sora(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE0A21A),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Due $dueDate',
                                style: AppThemes.roboto(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.ink,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Challan Details Rows (.rows)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            label: 'Billing month',
                            valueWidget: Text(
                              record.periodName ?? '—',
                              style: AppThemes.roboto(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                          _buildDetailRow(
                            label: 'Challan no.',
                            valueWidget: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SelectableText(
                                  record.challanNo ?? '—',
                                  style: AppThemes.roboto(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink,
                                  ),
                                ),
                                if (record.challanNo != null &&
                                    record.challanNo!.isNotEmpty) ...[
                                  const SizedBox(width: 6),
                                  _buildCopyButton(
                                    context: context,
                                    text: record.challanNo!,
                                    tooltip: 'Copy challan number',
                                  ),
                                ],
                              ],
                            ),
                          ),
                          _buildDetailRow(
                            label: 'Issue date',
                            valueWidget: Text(
                              issueDate,
                              style: AppThemes.roboto(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                          _buildDetailRow(
                            label: 'Due date',
                            valueWidget: Text(
                              dueDate,
                              style: AppThemes.roboto(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                          _buildDetailRow(
                            label: 'Valid until',
                            valueWidget: Text(
                              validityDate,
                              style: AppThemes.roboto(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                          _buildDetailRow(
                            label: '${record.periodName ?? 'Current'} fee',
                            valueWidget: Text(
                              HelperFunction().formatCurrency(
                                record.outstandingFee ?? 0.0,
                              ),
                              style: AppThemes.roboto(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                          if (arearMonths != null && arearMonths.isNotEmpty) ...[
                            for (final month in arearMonths)
                              _buildDetailRow(
                                label: 'Arrears ${month.periodName ?? ''}',
                                valueWidget: Text(
                                  HelperFunction().formatCurrency(
                                    month.outstandingFee ?? 0.0,
                                  ),
                                  style: AppThemes.roboto(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ),
                          ],
                          // Total Row (.row2.tot)
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: AppColors.line,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total payable',
                                  style: AppThemes.sora(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  ),
                                ),
                                Text(
                                  HelperFunction().formatCurrency(totalPayable),
                                  style: AppThemes.sora(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Quick Copy Options for Online Banking (1Link / 1Bill)
                    if (record.challanNo != null &&
                        record.challanNo!.isNotEmpty &&
                        info?.centerName != null &&
                        (!info!.centerName!.contains('C001'))) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: '100827${record.challanNo!}',
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('1Link prefix + Challan copied!'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.copy_rounded,
                                  size: 13,
                                  color: AppColors.blue,
                                ),
                                label: Text(
                                  'For 1Link',
                                  style: AppThemes.sora(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blue,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: AppColors.blueTint,
                                  ),
                                  backgroundColor: AppColors.blueTint
                                      .withValues(alpha: 0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  final prefix =
                                      info.centerName!.contains('C052')
                                          ? '1003330241'
                                          : '1003330195';
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: '$prefix${record.challanNo!}',
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('1Bill prefix + Challan copied!'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.copy_rounded,
                                  size: 13,
                                  color: AppColors.blue,
                                ),
                                label: Text(
                                  'For 1Bill',
                                  style: AppThemes.sora(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blue,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: AppColors.blueTint,
                                  ),
                                  backgroundColor: AppColors.blueTint
                                      .withValues(alpha: 0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Pay now Button (.pay)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                      child: SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton(
                          onPressed: () {
                            if (info == null) return;
                            AppNavigation.navigateTo(
                              AppNavRoutes.challanPaymentRoute,
                              arguments: ChallanArgs(
                                fatherCnic: info.fatherCnic ?? '',
                                studentId: info.rollNo?.toString() ?? '',
                                primaryContactNo: info.primaryContactNo ?? '',
                                isNewPaymentFlowEnabled:
                                    value.isNewPaymentFlowEnabled,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Pay now',
                                style: AppThemes.sora(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Surcharge Warning Info
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 15,
                      color: AppColors.muted,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Late payment surcharge @Rs 50/- per day (to be calculated and charged by the bank).',
                        style: AppThemes.roboto(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow({
    required String label,
    required Widget valueWidget,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEF1F5), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppThemes.roboto(
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              color: AppColors.muted,
            ),
          ),
          valueWidget,
        ],
      ),
    );
  }

  Widget _buildCopyButton({
    required BuildContext context,
    required String text,
    required String tooltip,
  }) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Copied to clipboard'),
            duration: Duration(seconds: 1),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.blueTint,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.copy_rounded,
          size: 14,
          color: AppColors.blue,
        ),
      ),
    );
  }
}
