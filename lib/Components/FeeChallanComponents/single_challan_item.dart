// === REFACTORED FILE: single_challan_item.dart ===
// Moved from OutstandingFeeComponents → FeeChallanComponents
// Fixes: Shows current month + arrears separately, dates labeled clearly,
// modern card design matching student_class_result_screen.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:tcs_app/custom_widgets/CustomTitleValue/custom_title_value.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:tcs_app/model/FeeChallan/outstanding_challan_response.dart';
import 'package:tcs_app/utils/app_colors.dart';

class SingleChallanItem extends StatelessWidget {
  final OutstandingChallan record;
  final List<OutstandingChallan>? arrearMonths;
  final StudentInfo studentInfo;
  final int index;

  const SingleChallanItem({
    super.key,
    required this.record,
    this.arrearMonths,
    required this.studentInfo,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    // Determine 1LINK / 1BILL prefixes based on center
    final bool isC052 = studentInfo.centerName?.contains('C052') ?? false;
    const String oneLinkPrefix = '100827';
    final String oneBillPrefix = isC052 ? '1003330241' : '1003330195';

    // Calculate totals
    final double currentMonthFee = record.outstandingFee ?? 0;
    final double totalArrears = arrearMonths != null
        ? arrearMonths!.fold(
            0.0,
            (sum, item) => sum + (item.outstandingFee ?? 0),
          )
        : 0;
    final double totalPayable = currentMonthFee + totalArrears;

    // Check if validity has expired
    final bool isOverdue =
        record.validityDate != null &&
        DateTime.tryParse(record.validityDate!)?.isBefore(DateTime.now()) ==
            true;

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
              color: Colors.black.withValues(alpha: 0.03),
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
                // Left accent bar — golden for pending challans
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: isOverdue
                          ? [
                              AppColors.errorRed,
                              AppColors.errorRed.withValues(alpha: 0.7),
                            ]
                          : [AppColors.goldenYellow, AppColors.warningOrange],
                    ),
                  ),
                ),

                // Main content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Header row ──
                        _buildHeader(isOverdue),
                        const SizedBox(height: 16),

                        // ── Payment IDs section ──
                        CustomTitleValue(
                          title: 'Challan No',
                          value: record.challanNo ?? '—',
                          isSelectionAllowed: true,
                          isCopyAllowed: true,
                        ),
                        CustomTitleValue(
                          title: '1LINK Payment ID',
                          value: '$oneLinkPrefix${record.challanNo ?? ''}',
                          isSelectionAllowed: true,
                          isCopyAllowed: true,
                        ),
                        CustomTitleValue(
                          title: '1BILL Payment ID',
                          value: '$oneBillPrefix${record.challanNo ?? ''}',
                          isSelectionAllowed: true,
                          isCopyAllowed: true,
                        ),

                        // ── Billing period ──
                        CustomTitleValue(
                          title: 'Billing Period',
                          value: record.periodName ?? '—',
                        ),

                        // ── Dates — each clearly labeled ──
                        CustomTitleValue(
                          title: 'Issue Date',
                          value: HelperFunction.dateFormatter(
                            record.issueDate ?? '',
                          ),
                        ),
                        CustomTitleValue(
                          title: 'Due Date',
                          value: HelperFunction.dateFormatter(
                            record.dueDate ?? '',
                          ),
                        ),
                        if (record.validityDate != null)
                          CustomTitleValue(
                            title: 'Valid Until',
                            value: HelperFunction.dateFormatter(
                              record.validityDate!,
                            ),
                            showDivider: false,
                          ),

                        const SizedBox(height: 14),

                        // ── Fee Breakdown ──
                        _buildFeeBreakdown(
                          currentMonthFee,
                          totalArrears,
                          totalPayable,
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

  // ═══════════════════════════════════════════════════════════
  // HEADER — icon, title, and status badge
  // ═══════════════════════════════════════════════════════════
  Widget _buildHeader(bool isOverdue) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isOverdue
                ? AppColors.errorRed.withValues(alpha: 0.1)
                : AppColors.goldenYellow.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.receipt_long_rounded,
            color: isOverdue ? AppColors.errorRed : AppColors.goldenYellow,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                record.challanType?.toUpperCase() ?? 'CHALLAN',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 0.5,
                  color: AppColors.primaryDarkColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Fee Challan Entry',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Status badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isOverdue
                ? AppColors.errorRed.withValues(alpha: 0.1)
                : Colors.redAccent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            isOverdue ? 'OVERDUE' : 'PENDING',
            style: TextStyle(
              color: isOverdue ? AppColors.errorRed : Colors.redAccent,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════
  // FEE BREAKDOWN — current month, arrears, total payable
  // ═══════════════════════════════════════════════════════════
  Widget _buildFeeBreakdown(
    double currentMonthFee,
    double totalArrears,
    double totalPayable,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          // Current month amount
          _feeRow(
            label: 'Current Month',
            amount: currentMonthFee,
            color: AppColors.primaryDarkColor,
            isBold: false,
          ),

          // Arrears breakdown (if any)
          if (arrearMonths != null && arrearMonths!.isNotEmpty) ...[
            const SizedBox(height: 6),
            ...arrearMonths!.map(
              (month) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: _feeRow(
                  label: 'Arrears (${month.periodName ?? '—'})',
                  amount: month.outstandingFee ?? 0,
                  color: AppColors.warningOrange,
                  isBold: false,
                  fontSize: 12,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Divider(
                height: 1,
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
              ),
            ),
          ] else
            const SizedBox(height: 10),

          // Total payable
          _feeRow(
            label: 'TOTAL PAYABLE',
            amount: totalPayable,
            color: AppColors.primaryDarkColor,
            isBold: true,
            fontSize: 15,
          ),
        ],
      ),
    );
  }

  Widget _feeRow({
    required String label,
    required double amount,
    required Color color,
    required bool isBold,
    double fontSize = 13,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
            fontSize: isBold ? 13 : 12,
            letterSpacing: isBold ? 0.5 : 0.2,
            color: isBold ? color : Colors.grey.shade600,
          ),
        ),
        Text(
          HelperFunction().formatCurrency(amount),
          style: TextStyle(
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
            fontSize: fontSize,
            color: color,
          ),
        ),
      ],
    );
  }
}
