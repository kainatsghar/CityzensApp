import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/citizen/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/citizen/Provider/StudentProfile/student_profile_provider.dart';
import 'package:tcs_app/citizen/Model/StudentProfile/student_profile_response.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_constants.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/cityzens_back_button.dart';
import 'package:tcs_app/CustomWidgets/CityzensIcons/cityzens_icons.dart';

class StudentProfileComponent extends StatelessWidget {
  const StudentProfileComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProfileProvider>(
      builder: (context, value, _) {
        final List<Profile>? profileList = value.profileResponse?.profile;
        if (profileList == null || profileList.isEmpty) {
          return const Center(
            child: ShowCustomMessage(message: AppConstants.noRecordFound),
          );
        }

        final Profile profile = profileList.first;
        final String studentName =
            (profile.name != null && profile.name!.trim().isNotEmpty)
                ? profile.name!.trim()
                : 'Student';
        final String rollNo = profile.studentId?.toString() ?? '—';

        // Parse class and section
        String classDisplay = profile.className ?? '—';
        String sectionDisplay = '—';
        if (profile.className != null && profile.className!.contains('-')) {
          final parts = profile.className!.split('-');
          if (parts.isNotEmpty) {
            classDisplay = parts[0].trim();
          }
          if (parts.length > 1) {
            sectionDisplay = parts.sublist(1).join('-').trim();
          }
        }

        return Column(
          children: [
            // S6 Blue Header with Hero Profile Photo, Name & Glance Block
            Container(
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                  child: Column(
                    children: [
                      // Top Bar Row (Circular Back button, Title)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CityzensBackButton(
                            size: 40,
                            onTap: () => Navigator.of(context).pop(),
                          ),
                          Text(
                            'Profile',
                            style: AppThemes.sora(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 40, height: 40),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Avatar with yellow & white double ring + yellow camera button
                      SizedBox(
                        width: 88,
                        height: 88,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.yellow,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withValues(alpha: 0.18),
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Consumer<LocalDataProvider>(
                                  builder: (context, localData, _) {
                                    return FutureBuilder(
                                      future: localData.loadImagePath(rollNo),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.data != null &&
                                            snapshot.data.toString().isNotEmpty) {
                                          return Image.file(
                                            File('${snapshot.data}'),
                                            fit: BoxFit.cover,
                                            width: 88,
                                            height: 88,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Image.asset(
                                              'assets/images/profile_avatar_yellow.png',
                                              fit: BoxFit.cover,
                                              width: 88,
                                              height: 88,
                                            ),
                                          );
                                        }
                                        return Image.asset(
                                          'assets/images/profile_avatar_yellow.png',
                                          fit: BoxFit.cover,
                                          width: 88,
                                          height: 88,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              right: -4,
                              bottom: -2,
                              child: GestureDetector(
                                onTap: () =>
                                    HelperFunction.imagePickerBottomSheet(),
                                child: Container(
                                  width: 34,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: AppColors.yellow,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.blue,
                                      width: 3,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromRGBO(15, 52, 102, 0.25),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: CityzensIcon(
                                      type: CityzensIconType.camera,
                                      size: 18,
                                      primaryColor: AppColors.blue,
                                      secondaryColor: Colors.white,
                                      accentColor: AppColors.yellow,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Student Name
                      Text(
                        studentName,
                        textAlign: TextAlign.center,
                        style: AppThemes.sora(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 3-Column Glance Block (Class, Section, Roll no.)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.13),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildGlanceCell('CLASS', classDisplay),
                            ),
                            Container(
                              width: 1,
                              height: 26,
                              color: Colors.white.withValues(alpha: 0.18),
                            ),
                            Expanded(
                              child:
                                  _buildGlanceCell('SECTION', sectionDisplay),
                            ),
                            Container(
                              width: 1,
                              height: 26,
                              color: Colors.white.withValues(alpha: 0.18),
                            ),
                            Expanded(
                              child: _buildGlanceCell('ROLL NO.', rollNo),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Scrollable Grouped Details (Academic, Personal, Contact)
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: Column(
                  children: [
                    // Academic Group
                    _buildGroup(
                      iconType: CityzensIconType.classIcon,
                      title: 'ACADEMIC',
                      fields: [
                        _ProfileField(
                          label: 'Campus',
                          value: profile.center ?? '—',
                        ),
                        _ProfileField(
                          label: 'Region',
                          value: profile.region ?? '—',
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Personal Group
                    _buildGroup(
                      iconType: CityzensIconType.user,
                      title: 'PERSONAL',
                      fields: [
                        _ProfileField(
                          label: 'Date of birth',
                          value: profile.dateOfBirth != null &&
                                  profile.dateOfBirth!.isNotEmpty
                              ? HelperFunction.dateFormatter(
                                  '${profile.dateOfBirth}',
                                )
                              : '—',
                        ),
                        _ProfileField(
                          label: 'City',
                          value: profile.city ?? '—',
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Contact Group
                    _buildGroup(
                      iconType: CityzensIconType.phone,
                      title: 'CONTACT',
                      fields: [
                        _ProfileField(
                          label: 'Father email',
                          value: profile.fatherEmail ?? '—',
                        ),
                        _ProfileField(
                          label: 'Contact number',
                          value: profile.contactNo ?? '—',
                        ),
                        _ProfileField(
                          label: 'Address',
                          value: profile.address ?? '—',
                        ),
                      ],
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

  Widget _buildGlanceCell(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: AppThemes.roboto(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
            color: Colors.white.withValues(alpha: 0.72),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppThemes.sora(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildGroup({
    required CityzensIconType iconType,
    required String title,
    required List<_ProfileField> fields,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 6),
          child: Row(
            children: [
              CityzensIcon(
                type: iconType,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppThemes.sora(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.blue,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(fields.length, (index) {
              final field = fields[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index > 0)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFEEF1F5),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          field.label,
                          style: AppThemes.roboto(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.muted,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          field.value.isNotEmpty ? field.value : '—',
                          style: AppThemes.roboto(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _ProfileField {
  final String label;
  final String value;

  const _ProfileField({required this.label, required this.value});
}
