import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/TeacherProfile/teacher_profile_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:tcs_app/utils/helper_function.dart';

import 'package:tcs_app/gen/assets.gen.dart';

class TeacherProfileComponent extends StatefulWidget {
  final ScrollController scrollController;
  const TeacherProfileComponent({super.key, required this.scrollController});

  @override
  State<TeacherProfileComponent> createState() =>
      _TeacherProfileComponentState();
}

class _TeacherProfileComponentState extends State<TeacherProfileComponent> {
  final ValueNotifier<double> _appBarOpacityNotifier = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _appBarOpacityNotifier.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted) return;
    double offset = widget.scrollController.offset;
    double newOpacity = (offset / 150).clamp(0.0, 1.0);
    if (newOpacity != _appBarOpacityNotifier.value) {
      _appBarOpacityNotifier.value = newOpacity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherProfileProvider>(
      builder: (context, value, _) {
        if (value.profileResponse == null) {
          return const Center(
            child: ShowError(errorText: AppConstants.noRecordFound),
          );
        }

        final profile = value.profileResponse!;

        return CustomScrollView(
          controller: widget.scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // 1. Unified Premium Sliver App Bar (Linked to Dashboard Design)
            ValueListenableBuilder<double>(
              valueListenable: _appBarOpacityNotifier,
              builder: (context, opacity, _) {
                return SliverAppBar(
                  expandedHeight: 320,
                  backgroundColor: AppColors.white.withValues(
                    alpha: opacity.clamp(0.0, 0.98),
                  ),
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  pinned: true,
                  stretch: true,
                  centerTitle: false,
                  systemOverlayStyle: SystemUiOverlayStyle.dark,
                  leading: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.primaryBlue,
                        size: 18,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: Opacity(
                    opacity: opacity > 0.8 ? (opacity - 0.8) * 5 : 0,
                    child: Text(
                      HelperFunction.noNullStringText(
                        profile.teacherName,
                      ).toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.primaryDarkBlue,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [StretchMode.zoomBackground],
                    background: Container(
                      color: Colors
                          .transparent, // Ensures particles are visible through flex space
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primaryBlue.withValues(
                                    alpha: 0.15,
                                  ),
                                  blurRadius: 30,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Hero(
                              tag: 'teacher_profile_image',
                              child: CustomUserImage(
                                userId: '${profile.employeeCode}',
                                disableUploadImage: false,
                                isMale: profile.gender == 'Male',
                                imageSize: 110,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            HelperFunction.noNullStringText(
                              profile.teacherName,
                            ).toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primaryDarkBlue,
                              fontWeight: FontWeight.w900,
                              fontSize: 22.0,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warningOrange.withValues(
                                alpha: 0.15,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.warningOrange.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Text(
                              HelperFunction.noNullStringText(
                                profile.designation,
                              ).toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.warningOrange,
                                fontWeight: FontWeight.w900,
                                fontSize: 11.0,
                                letterSpacing: 1.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // 2. Subtle & Professional Information Sections
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 60),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _ProfileSection(
                    title: 'Work Information',
                    fields: [
                      _FieldData(
                        icon: Icons.badge_rounded,
                        label: 'Employee ID',
                        value: '${profile.employeeCode}',
                      ),
                      _FieldData(
                        icon: Icons.business_rounded,
                        label: 'Branch',
                        value: '${profile.branch}',
                      ),
                      _FieldData(
                        icon: Icons.public_rounded,
                        label: 'Region & City',
                        value: '${profile.region}, ${profile.city}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _ProfileSection(
                    title: 'Contact Details',
                    fields: [
                      _FieldData(
                        icon: Icons.phone_android_rounded,
                        label: 'Cell Number',
                        value: '${profile.employeeCell}',
                      ),
                      _FieldData(
                        icon: Icons.alternate_email_rounded,
                        label: 'Email Address',
                        value: '${profile.email}',
                      ),
                      _FieldData(
                        icon: Icons.home_work_rounded,
                        label: 'Resident Address',
                        value: '${profile.address}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _ProfileSection(
                    title: 'Personal Details',
                    fields: [
                      _FieldData(
                        icon: Icons.fingerprint_rounded,
                        label: 'CNIC Number',
                        value: '${profile.cnicNumber}',
                      ),
                      _FieldData(
                        icon: Icons.favorite_rounded,
                        label: 'Marital Status',
                        value: profile.maritalStatus == 'M'
                            ? 'Married'
                            : 'Single',
                      ),
                      _FieldData(
                        icon: Icons.auto_awesome_rounded,
                        label: 'Religion',
                        value: '${profile.religion}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Opacity(
                    opacity: 0.4,
                    child: Center(
                      child: Image.asset(
                        Assets.images.tcsLogo.path,
                        height: 35,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FieldData {
  final IconData icon;
  final String label;
  final String value;
  _FieldData({required this.icon, required this.label, required this.value});
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<_FieldData> fields;

  const _ProfileSection({required this.title, required this.fields});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryLightBlue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: fields.map((data) => _FieldItem(data: data)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldItem extends StatelessWidget {
  final _FieldData data;

  const _FieldItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.ultraLightGrey,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(data.icon, color: AppColors.primaryBlue, size: 18),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 8,
                    color: AppColors.softGreyText,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  HelperFunction.noNullStringText(data.value).isEmpty
                      ? 'N/A'
                      : HelperFunction.noNullStringText(data.value),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primaryDarkBlue,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
