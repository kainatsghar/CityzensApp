import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/custom_widgets/CustomStudentInfo/custom_student_info.dart';
import 'package:tcs_app/custom_widgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/custom_widgets/ParticleBackground/particle_background.dart';
import 'package:tcs_app/provider/SupportForm/support_form_provider.dart';
import 'package:tcs_app/provider/StudentDashboard/student_dashboard_provider.dart';
import 'package:tcs_app/provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/input_formatters.dart';
import 'package:tcs_app/utils/validators.dart';
import 'package:tcs_app/custom_widgets/CustomNoteCard/custom_note_card.dart';

class AppFeedbackScreen extends StatefulWidget {
  const AppFeedbackScreen({super.key});

  @override
  State<AppFeedbackScreen> createState() => AppFeedbackScreenState();
}

class AppFeedbackScreenState extends State<AppFeedbackScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _particleController;
  late SupportFormProvider _provider;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _provider = Provider.of<SupportFormProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );
    _provider.initializeData();
    if (_provider.userType.isNotEmpty) {
      _provider.clearFormState();
      _provider.initializeUserData();
    }
    _provider.loadDeviceInfo();
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'APP FEEDBACK'),
      body: Stack(
        children: [
          ParticleBackground(
            animation: _particleController,
            particleColor: AppColors.primaryBlue.withValues(alpha: 0.15),
          ),
          SafeArea(
            child: Consumer<SupportFormProvider>(
              builder: (context, provider, _) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Header Section
                    SliverToBoxAdapter(
                      child: Consumer<LocalDataProvider>(
                        builder: (context, localData, _) {
                          if (localData.userData?.userType == 'Parent') {
                            return _buildParentHeader(localData);
                          }
                          return _buildReusableHeader();
                        },
                      ),
                    ),

                    // Form Section
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverToBoxAdapter(
                        child: FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLightBlue.withValues(
                                    alpha: 0.8,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: AppColors.primaryBlue.withValues(
                                      alpha: 0.2,
                                    ),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Form(
                                  key: provider.formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildSectionTitle('SENDER INFORMATION'),
                                      const SizedBox(height: 16),
                                      CustomTextFormField(
                                        controller: provider.nameController,
                                        prefixIcon:
                                            Icons.person_outline_rounded,
                                        hintText: "Full Name",
                                        validator: (val) =>
                                            Validators.validator(val),
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextFormField(
                                              controller: provider.idController,
                                              prefixIcon: Icons.badge_outlined,
                                              hintText: "ID / CNIC",
                                              validator: (val) =>
                                                  Validators.validator(val),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: CustomTextFormField(
                                              hintText: provider.userType,
                                              prefixIcon:
                                                  Icons.account_circle_outlined,
                                              isEnable: false,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      CustomTextFormField(
                                        controller: provider.emailController,
                                        inputType: TextInputType.emailAddress,
                                        prefixIcon:
                                            Icons.alternate_email_rounded,
                                        hintText: "Contact Email",
                                        validator: Validators.validatorForEmail,
                                      ),
                                      const SizedBox(height: 16),
                                      CustomTextFormField(
                                        controller:
                                            provider.mobileContactController,
                                        inputType: TextInputType.phone,
                                        hintText: 'Mobile (03XX-XXXXXXX)',
                                        prefixIcon: Icons.phone_android_rounded,
                                        inputFormatter:
                                            InputFormatters.mobileNumberFormatter(),
                                        validator:
                                            Validators.validatorForMobileNo,
                                      ),
                                      const SizedBox(height: 24),
                                      const Divider(
                                        height: 32,
                                        thickness: 0.5,
                                        color: AppColors.primaryBlue,
                                      ),
                                      _buildSectionTitle('FEEDBACK DETAILS'),
                                      const SizedBox(height: 16),
                                      _buildFeedbackTypeDropdown(provider),
                                      const SizedBox(height: 16),
                                      CustomTextFormField(
                                        controller: provider.titleController,
                                        hintText: "Subject / Title",
                                        prefixIcon: Icons.title_rounded,
                                        inputAction: TextInputAction.next,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Title is required';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 16),
                                      CustomTextFormField(
                                        controller: provider.detailsController,
                                        hintText: "Tell us more...",
                                        maxLines: 5,
                                        inputType: TextInputType.multiline,
                                        inputAction: TextInputAction.newline,
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Details are required';
                                          }
                                          return null;
                                        },
                                      ),
                                      if (provider.userType == "Parent" &&
                                          provider.multiChildResponse?.children !=
                                              null &&
                                          provider.multiChildResponse!.children!
                                              .isNotEmpty) ...[
                                        const SizedBox(height: 24),
                                        _buildSectionTitle('LINKED CHILDREN'),
                                        const SizedBox(height: 12),
                                        ...provider
                                            .multiChildResponse!
                                            .children!
                                            .map((c) => _buildChildTile(c)),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),
                          child: CustomNoteCard(
                            title: 'Quick Notes',
                            notes: [
                              'You can attach screenshots in the generated email.',
                              'Ensure contact details are valid for our response.',
                              'Your feedback is strictly confidential.',
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Action Button
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                        child: FadeInUp(
                          delay: const Duration(milliseconds: 400),
                          child: CustomAppButton(
                            buttonTitle: 'GENERATE EMAIL',
                            onTap: () => provider.sendSupportEmail(),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: AppColors.primaryBlue,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildFeedbackTypeDropdown(SupportFormProvider provider) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Prefix Icon (Exact match to CustomTextFormField style)
          Container(
            width: 46,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
            ),
            child: const Icon(
              Icons.feedback_rounded,
              color: AppColors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Dropdown Content
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: provider.selectedFeedbackType,
                isExpanded: true,
                dropdownColor: AppColors.white,
                icon: const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primaryColor,
                    size: 20,
                  ),
                ),
                borderRadius: BorderRadius.circular(12),
                style: const TextStyle(
                  color: AppColors.primaryDarkBlue,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Roboto', // Ensuring consistent font
                ),
                items: provider.feedbackTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    provider.updateFeedbackType(value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildTile(dynamic c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          CustomUserImage(imageSize: 45, userId: '${c.studentId}'),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.studentName ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                    color: AppColors.primaryDarkBlue,
                  ),
                ),
                Text(
                  "${c.className} | ID: ${c.studentId}",
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.softGreyText.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParentHeader(LocalDataProvider localData) {
    return FadeInDown(
      duration: const Duration(milliseconds: 600),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryDarkBlue, AppColors.navyOverlay],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.rate_review_rounded,
                color: AppColors.secondaryColor,
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SHARE FEEDBACK',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: AppColors.secondaryColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    localData.userData?.name?.toUpperCase() ?? 'PARENT',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReusableHeader() {
    return Consumer2<StudentDashboardProvider, LocalDataProvider>(
      builder: (context, dashboardProvider, localData, _) {
        final profile =
            dashboardProvider.activeChildData?.profile?.profile?.firstOrNull;

        if (profile == null) {
          return CustomStudentInfo(info: localData.userData?.info);
        }

        final infoWrapper = {
          'rollNo': profile.studentId.toString(),
          'name': profile.name,
          'className': profile.className,
          'centerName': profile.center,
        };

        return CustomStudentInfo(info: StudentInfoWrapper(infoWrapper));
      },
    );
  }
}

