import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/utils/app_colors.dart';

import '../../custom_widgets/CustomAppButton/custom_app_button.dart';
import '../../custom_widgets/CustomSnackbar/custom_snackbar.dart';
import '../../provider/EyeOnYourChild/eye_on_your_child_provider.dart';
import '../../utils/app_constants.dart';
import '../../model/EyeOnYourChild/eye_on_your_child_response.dart';

class EyeOnYourChildComponent extends StatefulWidget {
  const EyeOnYourChildComponent({super.key});

  @override
  State<EyeOnYourChildComponent> createState() =>
      _EyeOnYourChildComponentState();
}

class _EyeOnYourChildComponentState extends State<EyeOnYourChildComponent> {
  final ScrollController _studentScrollController = ScrollController();
  final ScrollController _updateScrollController = ScrollController();

  @override
  void dispose() {
    _studentScrollController.dispose();
    _updateScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EyeOnYourChildProvider>(
      builder: (context, value, _) {
        var responseData = value.eyeOnChildResponse;

        if (responseData == null) {
          return const ShowCustomMessage(message: AppConstants.noRecordFound);
        }

        final updates = responseData.studentUpdateDetails ?? [];
        final students = responseData.studentDetails ?? [];

        if (students.isEmpty) {
          return const ShowCustomMessage(
            message: 'No students found for this class.',
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: AppColors.primaryLightBlue.withValues(alpha: 0.01),
          ),
          child: Column(
            children: [
              // Header Summary Bar
              _buildHeaderSummary(value),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: value.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        // --- SIDE BY SIDE SELECTION HUB ---
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Column 1: Students
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSelectionHeader(
                                    'STUDENTS',
                                    Icons.group_rounded,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildStudentColumn(value, students),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Column 2: Updates
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSelectionHeader(
                                    'UPDATES',
                                    Icons.notifications_active_rounded,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildUpdateColumn(value, updates),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // --- PHOTO SECTION ---
                        _buildSelectionHeader(
                          'PHOTO EVIDENCE (MAX 3)',
                          Icons.camera_alt_rounded,
                        ),
                        const SizedBox(height: 8),
                        _buildUploadSection(value),

                        const SizedBox(height: 32),

                        // --- SUBMIT ACTION (Centered) ---
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: CustomAppButton(
                              buttonTitle: 'SEND UPDATE',
                              onTap: () {
                                if (value.selectedChild == null ||
                                    value.selectedChild!.isEmpty) {
                                  showSnackBar('Please select a student');
                                  return;
                                }
                                if (value.selectedUpdate == null ||
                                    value.selectedUpdate!.isEmpty) {
                                  showSnackBar('Please select an update');
                                  return;
                                }
                                value.submitEyeOnChildRecord();
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderSummary(EyeOnYourChildProvider value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue,
            AppColors.primaryBlue.withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SELECTION SUMMARY',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${value.selectedChild ?? "None"} • ${value.selectedUpdate ?? "None"}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
        ],
      ),
    );
  }

  Widget _buildSelectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 14),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primaryDarkColor,
            fontWeight: FontWeight.w900,
            fontSize: 10,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentColumn(
    EyeOnYourChildProvider value,
    List<StudentDetails> students,
  ) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: RawScrollbar(
          controller: _studentScrollController,
          thumbVisibility: true,
          thickness: 4,
          radius: const Radius.circular(10),
          thumbColor: AppColors.primaryBlue.withValues(alpha: 0.3),
          child: ListView.separated(
            controller: _studentScrollController,
            padding: const EdgeInsets.all(8),
            itemCount: students.length,
            separatorBuilder: (_, _) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              final student = students[index];
              final isSelected = value.selectedChild == student.studentName;

              return InkWell(
                onTap: () => value.setSelectedChild(
                  student.studentName ?? '',
                  student.studentId ?? 0,
                ),
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryBlue.withValues(alpha: 0.08)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryBlue.withValues(alpha: 0.3)
                          : Colors.grey.shade50,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.studentName ?? '',
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.primaryBlue
                              : AppColors.primaryDarkColor,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ID: ${student.studentId ?? "N/A"}',
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.primaryBlue.withValues(alpha: 0.7)
                              : Colors.grey.shade500,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateColumn(
    EyeOnYourChildProvider value,
    List<StudentUpdateDetails> updates,
  ) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: RawScrollbar(
          controller: _updateScrollController,
          thumbVisibility: true,
          thickness: 4,
          radius: const Radius.circular(10),
          thumbColor: AppColors.primaryDarkColor.withValues(alpha: 0.3),
          child: ListView.separated(
            controller: _updateScrollController,
            padding: const EdgeInsets.all(8),
            itemCount: updates.length,
            separatorBuilder: (_, _) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              final update = updates[index];
              final isSelected = value.selectedUpdate == update.updateName;

              return InkWell(
                onTap: () => value.setSelectedUpdate(
                  update.updateName ?? '',
                  update.id ?? 0,
                ),
                borderRadius: BorderRadius.circular(10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryDarkColor
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryDarkColor
                          : Colors.grey.shade50,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_off_rounded,
                        color: isSelected ? Colors.white : Colors.grey.shade200,
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          update.updateName ?? '',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : AppColors.primaryDarkColor,
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUploadSection(EyeOnYourChildProvider value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: value.files.length < 3
                ? () => value.uploadAttachment()
                : null,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: value.files.length < 3
                    ? AppColors.primaryBlue.withValues(alpha: 0.03)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: value.files.length < 3
                      ? AppColors.primaryBlue.withValues(alpha: 0.15)
                      : Colors.grey.shade200,
                  width: 1.2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.add_a_photo_rounded,
                    size: 24,
                    color: value.files.length < 3
                        ? AppColors.primaryBlue
                        : Colors.grey,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value.files.length < 3
                        ? 'Attach Evidence'
                        : 'Limit Reached',
                    style: TextStyle(
                      color: value.files.length < 3
                          ? AppColors.primaryDarkColor
                          : Colors.grey,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${value.files.length}/3 photos',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
          if (value.files.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 55,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: value.files.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final File? file = value.files[index];
                  if (file == null) return const SizedBox.shrink();

                  return Container(
                    width: 140,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.image,
                            size: 14,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            file.path.split('/').last,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDarkColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => value.removeAttachment(index),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
