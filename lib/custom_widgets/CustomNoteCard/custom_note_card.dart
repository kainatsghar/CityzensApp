import 'package:flutter/material.dart';
import 'package:tcs_app/utils/app_colors.dart';

/// A premium, high-fidelity card for displaying important information or notes.
/// Consistent design with a left accent bar, info icon, and geometric shadows.
class CustomNoteCard extends StatelessWidget {
  final String? title;
  final List<String> notes;
  final bool isSmall;
  final EdgeInsetsGeometry? margin;

  const CustomNoteCard({
    super.key,
    this.title = 'IMPORTANT NOTE',
    required this.notes,
    this.isSmall = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.08),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left Accent Bar
            Container(
              width: 6,
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.primaryBlue,
                            size: isSmall ? 14 : 16,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          title?.toUpperCase() ?? 'NOTE',
                          style: TextStyle(
                            fontSize: isSmall ? 10 : 12,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryDarkBlue,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Notes List
                    ...notes.asMap().entries.map((entry) {
                      final bool isLast = entry.key == notes.length - 1;
                      return Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0 : 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                entry.value,
                                style: TextStyle(
                                  fontSize: isSmall ? 12 : 13,
                                  color: AppColors.primaryDarkBlue,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
