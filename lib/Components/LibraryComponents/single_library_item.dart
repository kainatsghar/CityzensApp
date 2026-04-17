import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:tcs_app/custom_widgets/CustomTitleValue/custom_title_value.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:tcs_app/model/Library/library_response.dart';

class SingleLibraryItem extends StatelessWidget {
  final LibraryRecords record;
  final int index;

  const SingleLibraryItem({super.key, required this.record, this.index = 0});

  @override
  Widget build(BuildContext context) {
    final bool isReturned =
        record.returnDate != null && record.returnDate!.isNotEmpty;
    final bool isOverdue =
        !isReturned &&
        record.dueDate != null &&
        DateTime.tryParse(record.dueDate!)?.isBefore(DateTime.now()) == true;
    final bool hasFine =
        record.fine != null &&
        (double.tryParse(record.fine!.toString()) ?? 0) > 0;

    // Accent bar color logic
    Color accentColor;
    if (isReturned) {
      accentColor = AppColors.successGreen;
    } else if (isOverdue) {
      accentColor = AppColors.errorRed;
    } else {
      accentColor = AppColors.primaryColor;
    }

    return FadeInUp(
      delay: Duration(milliseconds: 50 * index),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.02),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryBlue.withOpacity(0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
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
                // Left accent bar with gradient
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [accentColor, accentColor.withOpacity(0.6)],
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: <Widget>[
                        _buildHeader(isReturned, isOverdue),
                        const SizedBox(height: 16),

                        CustomTitleValue(
                          title: 'Book Title',
                          value: record.bookTitle ?? '—',
                          boldValue: true,
                        ),
                        CustomTitleValue(
                          title: 'Author',
                          value: record.authorName ?? '—',
                        ),

                        // ── Dates — each clearly labeled ──
                        CustomTitleValue(
                          title: 'Issue Date',
                          value: HelperFunction.dateFormatter(record.issueDate),
                        ),
                        CustomTitleValue(
                          title: 'Due Date',
                          value: HelperFunction.dateFormatter(record.dueDate),
                        ),
                        if (isReturned)
                          CustomTitleValue(
                            title: 'Returned On',
                            value: HelperFunction.dateFormatter(
                              record.returnDate,
                            ),
                            showDivider: false,
                          ),

                        const SizedBox(height: 12),
                        _buildFineSection(hasFine),
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

  Widget _buildHeader(bool isReturned, bool isOverdue) {
    // Status text & color
    final String statusText;
    final Color statusColor;
    final String subtitle;

    if (isReturned) {
      statusText = 'RETURNED';
      statusColor = AppColors.successGreen;
      subtitle = 'Return Completed';
    } else if (isOverdue) {
      statusText = 'OVERDUE';
      statusColor = AppColors.errorRed;
      subtitle = 'Past Due Date';
    } else {
      statusText = 'ISSUED';
      statusColor = AppColors.warningOrange;
      subtitle = 'Currently Issued';
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.auto_stories_rounded, color: statusColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'LIBRARY RECORD',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 0.5,
                  color: AppColors.primaryDarkColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        // Status badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFineSection(bool hasFine) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: hasFine
            ? AppColors.errorRed.withOpacity(0.05)
            : Colors.grey.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasFine
              ? AppColors.errorRed.withOpacity(0.1)
              : Colors.grey.withOpacity(0.08),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                size: 14,
                color: hasFine ? AppColors.errorRed : Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Text(
                'FINE AMOUNT',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 0.5,
                  color: hasFine ? AppColors.errorRed : Colors.grey.shade700,
                ),
              ),
            ],
          ),
          Text(
            hasFine ? 'PKR ${record.fine}' : 'None',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: hasFine ? AppColors.errorRed : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
