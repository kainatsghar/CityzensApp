import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/StudentProfile/student_profile_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/app_constants.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/gen/assets.gen.dart';

class StudentProfileComponent extends StatefulWidget {
  final ScrollController scrollController;
  const StudentProfileComponent({super.key, required this.scrollController});

  @override
  State<StudentProfileComponent> createState() =>
      _StudentProfileComponentState();
}

class _StudentProfileComponentState extends State<StudentProfileComponent> {
  final ValueNotifier<double> _appBarOpacityNotifier = ValueNotifier(0.0);
  late final TextEditingController _addressController;
  late final TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);

    final provider = Provider.of<StudentProfileProvider>(
      context,
      listen: false,
    );
    final profile = provider.profileResponse?.profile?.first;
    _addressController = TextEditingController(text: profile?.address ?? '');
    _contactController = TextEditingController(text: profile?.contactNo ?? '');
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _appBarOpacityNotifier.dispose();
    _addressController.dispose();
    _contactController.dispose();
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
    final localProvider = Provider.of<LocalDataProvider>(
      context,
      listen: false,
    );
    final isStudent = localProvider.userData?.userType == 'Student';

    return Consumer<StudentProfileProvider>(
      builder: (context, value, _) {
        if (value.profileResponse?.profile == null ||
            value.profileResponse!.profile!.isEmpty) {
          return const Center(
            child: ShowError(errorText: AppConstants.noRecordFound),
          );
        }

        final profile = value.profileResponse!.profile!.first;

        return CustomScrollView(
          controller: widget.scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // 1. Premium Sliver App Bar (Unified Design)
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
                        profile.name,
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
                      color: Colors.transparent,
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
                              tag: 'student_profile_image_${profile.studentId}',
                              child: CustomUserImage(
                                userId: '${profile.studentId}',
                                disableUploadImage: false,
                                isMale:
                                    true, // Assuming default or add gender to model
                                imageSize: 110,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            HelperFunction.noNullStringText(
                              profile.name,
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
                              color: AppColors.tertiaryLight.withValues(
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
                              "ROLL NUMBER: ${profile.studentId}",
                              style: const TextStyle(
                                color: AppColors.tertiaryDark,
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

            // 2. Information Sections
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 60),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _ProfileSection(
                    title: 'Academic Details',
                    fields: [
                      _FieldData(
                        icon: Icons.school_rounded,
                        label: 'Class',
                        value: '${profile.className}',
                      ),
                      _FieldData(
                        icon: Icons.business_rounded,
                        label: 'Campus',
                        value: '${profile.center}',
                      ),
                      _FieldData(
                        icon: Icons.public_rounded,
                        label: 'Region',
                        value: '${profile.region}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _ProfileSection(
                    title: 'Personal Information',
                    fields: [
                      _FieldData(
                        icon: Icons.cake_rounded,
                        label: 'Date of Birth',
                        value: HelperFunction.dateFormatter(
                          '${profile.dateOfBirth}',
                        ),
                      ),
                      _FieldData(
                        icon: Icons.location_city_rounded,
                        label: 'City',
                        value: '${profile.city}',
                      ),
                      _FieldData(
                        icon: Icons.email_rounded,
                        label: 'Father Email',
                        value: '${profile.fatherEmail}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 3. Editable Section (Visible to Parents/Teachers, not Students)
                  _ProfileSection(
                    // title: isStudent
                    //     ? 'Contact Information'
                    //     : 'Contact Information (Editable)',
                    title: 'Contact Information',
                    // isEditable: !isStudent,
                    fields: [
                      _FieldData(
                        icon: Icons.home_work_rounded,
                        label: 'Address',
                        value: '${profile.address}',
                        controller: isStudent ? null : _addressController,
                        // isEditField: !isStudent,
                      ),
                      _FieldData(
                        icon: Icons.phone_android_rounded,
                        label: 'Contact Number',
                        value: '${profile.contactNo}',
                        controller: isStudent ? null : _contactController,
                        // isEditField: !isStudent,
                      ),
                    ],
                  ),

                  // if (!isStudent) ...[
                  //   const SizedBox(height: 32),

                  //   // Save Button (Disabled as requested)
                  //   SizedBox(
                  //     width: double.infinity,
                  //     height: 55,
                  //     child: ElevatedButton(
                  //       onPressed: null, // Disabled for now
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: AppColors.primaryBlue,
                  //         disabledBackgroundColor: AppColors.primaryBlue
                  //             .withValues(alpha: 0.3),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(15),
                  //         ),
                  //         elevation: 0,
                  //       ),
                  //       child: const Text(
                  //         'SAVE CHANGES',
                  //         style: TextStyle(
                  //           color: AppColors.white,
                  //           fontWeight: FontWeight.w900,
                  //           fontSize: 16,
                  //           letterSpacing: 1.0,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ],
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
  final TextEditingController? controller;
  final bool isEditField;

  _FieldData({
    required this.icon,
    required this.label,
    required this.value,
    this.controller,
  }) : isEditField = false;
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<_FieldData> fields;
  final bool isEditable;

  const _ProfileSection({
    required this.title,
    required this.fields,
  }) : isEditable = false;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Row(
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
                if (isEditable) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.edit_note_rounded,
                    color: AppColors.primaryBlue,
                    size: 16,
                  ),
                ],
              ],
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
        color: AppColors.white,
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
        crossAxisAlignment: data.isEditField
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: data.isEditField ? 12 : 0),
            child: Icon(data.icon, color: AppColors.primaryBlue, size: 18),
          ),
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
                if (data.isEditField && data.controller != null)
                  TextFormField(
                    controller: data.controller,
                    maxLines: data.label.contains('Address') ? 3 : 1,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primaryDarkBlue,
                      fontWeight: FontWeight.w800,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  )
                else
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
