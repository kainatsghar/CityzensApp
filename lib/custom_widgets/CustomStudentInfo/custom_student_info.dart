import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:tcs_app/custom_widgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/utils/app_colors.dart';

/// A premium, modern redesign of the student information header.
/// Matches the design language of the new About Us and Teacher Results pages.
class CustomStudentInfo extends StatelessWidget {
  final dynamic info;

  const CustomStudentInfo({super.key, this.info});

  @override
  Widget build(BuildContext context) {
    if (info == null) return const SizedBox.shrink();

    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          // Modern Gradient Background matching premium screens
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryDarkColor,
              AppColors.primaryColor.withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryDarkColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Subtle background pattern or accent
              Positioned(
                right: -30,
                top: -30,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.white.withOpacity(0.05),
                ),
              ),

              // Side Accent Bar (Consistent with Diary/Homework cards)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 6,
                child: Container(color: AppColors.goldenYellow),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 24.0,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Enhanced Avatar Section with white ring
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white24,
                              width: 1.5,
                            ),
                          ),
                          child: CustomUserImage(
                            userId: '${info.rollNo}',
                            imageSize: 75,
                          ),
                        ),
                        const SizedBox(width: 18),

                        // Main Name and ID Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                info.name?.toString().toUpperCase() ??
                                    'NAME N/A',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                  fontFamily: 'Axiforma',
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              _buildGlassChip(
                                icon: Icons.badge_outlined,
                                label: 'ID: ${info.rollNo}',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Detail Grid for Class and Branch
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          children: [
                            Expanded(
                              child: _DetailItem(
                                title: 'CLASS',
                                value: info.className?.toString() ?? 'N/A',
                                icon: Icons.school_rounded,
                              ),
                            ),
                            VerticalDivider(
                              color: Colors.white.withValues(alpha: 0.2),
                              thickness: 1,
                              indent: 5,
                              endIndent: 5,
                            ),
                            Expanded(
                              child: _DetailItem(
                                title: 'BRANCH',
                                value: info.centerName?.toString() ?? 'N/A',
                                icon: Icons.location_on_rounded,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.goldenYellow),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String title;
  final String? value;
  final IconData icon;

  const _DetailItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = (value == null || value == 'null' || value!.isEmpty)
        ? 'N/A'
        : value!;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12, color: AppColors.goldenYellow),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          displayValue,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
