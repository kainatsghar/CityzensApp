import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:tcs_app/utils/app_colors.dart';

/// A premium, beautiful card that resembles a ruled diary or notebook page.
/// Adheres strictly to the [AppColors] design system, resolving any external
/// or legacy color values into canonical theme colors.
///
/// Features a clean unruled top header for metadata (badges & timestamps),
/// a realistic ruled background body for entry text, and a solid clean footer
/// toolbar for teacher actions.
class UnifiedAcademicCard extends StatelessWidget {
  final String title;
  final String? description;
  final String? fileName;

  // Badge Configuration
  final String? badgeText;

  // Theme Colors
  final Color accentColor;

  // Actions and Callbacks
  final bool isTeacher;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTapAttachment;
  final ValueChanged<String>? onTapLink;

  // Extra Subtitles (e.g. Circular timestamp/date details)
  final Widget? extraSubtitleRow;

  const UnifiedAcademicCard({
    super.key,
    required this.title,
    this.description,
    this.fileName,
    this.badgeText,
    required this.accentColor,
    required this.isTeacher,
    this.onEdit,
    this.onDelete,
    this.onTapAttachment,
    this.onTapLink,
    this.extraSubtitleRow,
  });

  @override
  Widget build(BuildContext context) {
    // ── Dynamic Color Mapper ──────────────────────────────────────────
    // Maps accentColor to clean canonical AppColors constants.
    final Color resolvedAccent;
    final Color resolvedBadgeBg;
    final Color resolvedBadgeText;

    if (accentColor == AppColors.goldenColors) {
      resolvedAccent = AppColors.goldenColors;
      resolvedBadgeBg = AppColors.goldenColors.withValues(alpha: 0.12);
      resolvedBadgeText = AppColors.goldenColors;
    } else if (accentColor == AppColors.lightRedColor) {
      resolvedAccent = AppColors.lightRedColor;
      resolvedBadgeBg = AppColors.lightRedColor.withValues(alpha: 0.12);
      resolvedBadgeText = AppColors.lightRedColor;
    } else {
      // Default / Homework (primaryBlue)
      resolvedAccent = AppColors.primaryBlue;
      resolvedBadgeBg = AppColors.primaryBlue.withValues(alpha: 0.12);
      resolvedBadgeText = AppColors.primaryBlue;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral300.withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.neutral100.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── 1. Clean Top Header Panel (Full Width, Unruled) ──
            if ((badgeText != null && badgeText!.isNotEmpty) ||
                (extraSubtitleRow != null))
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.neutral50,
                  border: Border(
                    bottom: BorderSide(color: AppColors.border, width: 1.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left: Badge Tag
                    if (badgeText != null && badgeText!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: resolvedBadgeBg,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: resolvedAccent.withValues(alpha: 0.12),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          badgeText!,
                          style: TextStyle(
                            color: resolvedBadgeText,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      )
                    else
                      const SizedBox.shrink(),

                    // Right: Date/Timestamp Subtitle
                    if (extraSubtitleRow != null)
                      extraSubtitleRow!
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ),

            // ── 2. Ruled Page Body Content (With Spine & Ruled lines) ──
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Premium Diary Binder Spine (Only alongside the body!)
                  Container(
                    width: 28,
                    decoration: BoxDecoration(
                      color: AppColors.neutral50,
                      border: Border(
                        right: BorderSide(
                          color: resolvedAccent.withValues(alpha: 0.25),
                          width: 1.2,
                        ),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Binder Punch Holes
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            4,
                            (index) => Center(
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: AppColors.neutral300,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Binder Coils/Rings overlapping to the right
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            4,
                            (index) => Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                width: 9,
                                height: 3.5,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.neutral300,
                                      AppColors.neutral500,
                                      AppColors.neutral300,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.neutral900.withValues(
                                        alpha: 0.08,
                                      ),
                                      blurRadius: 1,
                                      offset: const Offset(0, 0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Ruled Diary Page Content
                  Expanded(
                    child: CustomPaint(
                      painter: DiaryRuledLinesPainter(
                        lineColor: AppColors.border.withValues(alpha: 0.35),
                        lineSpacing: 26.0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 12, 16, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              title.isNotEmpty ? title : 'No Subject',
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                                height: 1.35,
                                letterSpacing: -0.1,
                              ),
                            ),
                            // Description
                            if (description != null &&
                                description!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                               SelectableLinkify(
                                 onOpen: onTapLink != null
                                     ? (link) => onTapLink!(link.url)
                                     : null,
                                 text: description!,
                                 style: const TextStyle(
                                   fontSize: 13.0,
                                   height: 1.5,
                                   color: AppColors.textSecondary,
                                   letterSpacing: 0.1,
                                 ),
                                 linkStyle: TextStyle(
                                   color: resolvedAccent,
                                   fontWeight: FontWeight.w700,
                                   decoration: TextDecoration.underline,
                                 ),
                               ),
                            ],
                            // Attachment Section
                            if (fileName != null && fileName!.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap: onTapAttachment,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.neutral50,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppColors.border,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.attach_file_rounded,
                                            size: 14,
                                            color: resolvedAccent,
                                          ),
                                          const SizedBox(width: 6),
                                          Flexible(
                                            child: Text(
                                              fileName!,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: AppColors.textSecondary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── 3. Clean Solid Footer (Unruled Toolbar) ──
            if (isTeacher)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.neutral50,
                  border: Border(
                    top: BorderSide(color: AppColors.border, width: 1.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onDelete != null)
                      _ActionButton(
                        icon: Icons.delete_outline_rounded,
                        label: 'Delete',
                        color: AppColors.error,
                        backgroundColor: AppColors.errorLight,
                        onTap: onDelete!,
                      ),
                    const SizedBox(width: 8),
                    if (onEdit != null)
                      _ActionButton(
                        icon: Icons.edit_outlined,
                        label: 'Edit',
                        color: resolvedAccent,
                        backgroundColor: resolvedAccent.withValues(alpha: 0.08),
                        onTap: onEdit!,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Custom painter to render realistic ruled lines representing diary notebook sheets.
class DiaryRuledLinesPainter extends CustomPainter {
  final Color lineColor;
  final double lineSpacing;

  const DiaryRuledLinesPainter({
    required this.lineColor,
    this.lineSpacing = 28.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 0.8;

    double y = 24.0; // Padding offset from top of page
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      y += lineSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant DiaryRuledLinesPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.lineSpacing != lineSpacing;
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const KeepAliveWrapper({super.key, required this.child});

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
