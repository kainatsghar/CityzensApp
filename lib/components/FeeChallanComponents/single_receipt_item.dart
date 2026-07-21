// === REFACTORED FILE: single_receipt_item.dart ===
// Moved from ReceiptFeeComponents → FeeChallanComponents
// Modernized to match the design language in student_class_result_screen.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:tcs_app/custom_widgets/CustomTitleValue/custom_title_value.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:tcs_app/model/FeeChallan/challan_receipts_response.dart';
import 'package:tcs_app/utils/app_colors.dart';

class SingleReceiptItem extends StatelessWidget {
  final FeechallanHistory record;
  final int index;

  const SingleReceiptItem({super.key, required this.record, this.index = 0});

  @override
  Widget build(BuildContext context) {
    final bool hasOverpayment =
        record.overReceipt != null && record.overReceipt! > 0;

    return FadeInUp(
      delay: Duration(milliseconds: 50 * index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryBlue.withValues(alpha: 0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Green accent bar — paid / success
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.successGreen,
                        AppColors.successGreen.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        _buildHeader(),
                        const SizedBox(height: 16),
                        CustomTitleValue(
                          title: 'Receipt No',
                          value: record.receiptNo ?? '—',
                          isSelectionAllowed: true,
                        ),
                        CustomTitleValue(
                          title: 'Billing Period',
                          value: record.periodName ?? '—',
                        ),
                        CustomTitleValue(
                          title: 'Entry Type',
                          value: record.challanType ?? '—',
                        ),
                        CustomTitleValue(
                          title: 'Payment Date',
                          value: HelperFunction.dateFormatter(
                            record.receiptDate ?? '',
                          ),
                          showDivider: false,
                        ),
                        const SizedBox(height: 14),

                        // ── Amount summary ──
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.successGreen.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.successGreen.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'AMOUNT PAID',
                                    style: TextStyle(
                                      color: AppColors.successGreen,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 11,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  if (hasOverpayment)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        '+ ${HelperFunction().formatCurrency(record.overReceipt!)} Overpayment',
                                        style: TextStyle(
                                          color: AppColors.successGreen
                                              .withValues(alpha: 0.8),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Text(
                                HelperFunction().formatCurrency(
                                  record.amount ?? 0,
                                ),
                                style: const TextStyle(
                                  color: AppColors.primaryDarkBlue,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.successGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.successGreen,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PAYMENT RECEIPT',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 0.5,
                  color: AppColors.primaryDarkBlue,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Transaction Successful',
                style: TextStyle(
                  color: AppColors.grey500,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.successGreen.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'PAID',
            style: TextStyle(
              color: AppColors.successGreen,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );
  }
}
