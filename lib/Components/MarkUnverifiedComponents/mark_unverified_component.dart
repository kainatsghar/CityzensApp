import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomCard/custom_card.dart';
import 'package:tcs_app/model/UnverifiedReasons/unverified_reasons_response.dart';
import '../../custom_widgets/CustomAppButton/custom_app_button.dart';
import '../../custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import '../../custom_widgets/TabSelector/tab_selector.dart';
import '../../model/TeacherSection/teacher_section_response.dart';
import '../../provider/Dashboard/dashboard_provider.dart';
import '../../provider/MarkAttendance/mark_attendance_provider.dart';
import '../../provider/MarkUnverified/mark_unverified_provider.dart';
import '../../utils/app_colors.dart';

class MarkUnverifiedComponent extends StatefulWidget {
  const MarkUnverifiedComponent({super.key});

  @override
  State<MarkUnverifiedComponent> createState() =>
      _MarkUnverifiedComponentState();
}

class _MarkUnverifiedComponentState extends State<MarkUnverifiedComponent> {
  @override
  void initState() {
    super.initState();
    // Pre-select the section from the dashboard if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final attendanceProvider = Provider.of<MarkAttendanceProvider>(
        context,
        listen: false,
      );
      final unverifiedProvider = Provider.of<MarkUnverifiedProvider>(
        context,
        listen: false,
      );

      if (attendanceProvider.sectionId != null &&
          unverifiedProvider.sectionId == 0) {
        unverifiedProvider.setSectionId(attendanceProvider.sectionId!);
        unverifiedProvider.sectionController.text =
            attendanceProvider.sectionController.text;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<
      MarkUnverifiedProvider,
      DashboardProvider,
      MarkAttendanceProvider
    >(
      builder: (context, value, dashboardValue, attendanceValue, _) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomCard(
                    child: Form(
                      key: value.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Student Details'),
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            controller: value.studentIdController,
                            inputType: TextInputType.number,
                            inputAction: TextInputAction.next,
                            hintText: 'Roll Number (Optional)',
                          ),
                          const SizedBox(height: 16),
                          CustomTextFormField(
                            controller: value.studentNameController,
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.next,
                            hintText: 'Student Name',
                            validator: value.validator,
                          ),

                          const SizedBox(height: 24),
                          _buildSectionTitle('Class & Section'),
                          const SizedBox(height: 12),
                          TabSelector<Section>(
                            items: dashboardValue.getSectionsWithDiary(false),
                            getDisplayText: (section) => section.name ?? 'N/A',
                            onItemSelected: (section) {
                              value.sectionController.text = section.name ?? '';
                              value.setSectionId(section.classSectionId ?? 0);
                            },
                            initialItemName: value.sectionController.text,
                          ),

                          const SizedBox(height: 24),
                          _buildSectionTitle('Reason for Marking'),
                          const SizedBox(height: 12),
                          TabSelector<VerificationReason>(
                            items: dashboardValue.getUnverifiedReasons(),
                            getDisplayText: (reason) =>
                                reason.reasonDescription ?? 'N/A',
                            onItemSelected: (reason) {
                              value.reasonController.text =
                                  reason.reasonDescription ?? '';
                              value.setReasonId(reason.reasonId ?? 0);
                            },
                            initialItemName: value.reasonController.text,
                          ),

                          const SizedBox(height: 24),
                          _buildSectionTitle('Additional Remarks'),
                          const SizedBox(height: 12),
                          CustomTextFormField(
                            controller: value.remarksController,
                            inputType: TextInputType.text,
                            inputAction: TextInputAction.done,
                            maxLines: 4,
                            hintText: 'Enter any additional notes here...',
                            validator: value.validator,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Action Button
              FadeInUp(
                duration: const Duration(milliseconds: 500),
                delay: const Duration(milliseconds: 200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CustomAppButton(
                    buttonTitle: 'SUBMIT',
                    onTap: () => value.markUnverified(),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: AppColors.primaryBlue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primaryDarkColor,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
