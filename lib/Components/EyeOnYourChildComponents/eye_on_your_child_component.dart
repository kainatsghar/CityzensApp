import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/utils/app_colors.dart';

import '../../custom_widgets/CustomAppButton/custom_app_button.dart';
import '../../provider/EyeOnYourChild/eye_on_your_child_provider.dart';
import '../../utils/app_constants.dart';

class EyeOnYourChildComponent extends StatefulWidget {
  const EyeOnYourChildComponent({super.key});

  @override
  State<EyeOnYourChildComponent> createState() =>
      _EyeOnYourChildComponentState();
}

class _EyeOnYourChildComponentState extends State<EyeOnYourChildComponent> {
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

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Form(
              key: value.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Select Student
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    child: _buildSectionTitle(
                      '1. Select Student',
                      Icons.face_retouching_natural_rounded,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 100),
                    child: SizedBox(
                      height: 50,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: students.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final child = students[index];
                          final isSelected =
                              value.selectedChild == child.studentName;

                          return GestureDetector(
                            onTap: () {
                              value.setSelectedChild(
                                child.studentName ?? '',
                                child.studentId ?? 0,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primaryBlue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primaryBlue
                                      : Colors.grey.shade300,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primaryBlue
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  child.studentName.toString().trim(),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.primaryDarkColor,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 2. Select Update
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 200),
                    child: _buildSectionTitle(
                      '2. Select Update',
                      Icons.message_rounded,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 300),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: updates.map((update) {
                        final isSelected =
                            value.selectedUpdate == update.updateName;
                        return GestureDetector(
                          onTap: () {
                            value.setSelectedUpdate(
                              update.updateName ?? '',
                              update.id ?? 0,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryDarkColor
                                  : AppColors.primaryBlue.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryDarkColor
                                    : AppColors.primaryBlue.withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected) ...[
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  update.updateName ?? '',
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.primaryDarkColor,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // 3. Attach Photos
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 400),
                    child: _buildSectionTitle(
                      '3. Attach Photos (Max 3)',
                      Icons.camera_alt_rounded,
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 500),
                    child: _buildUploadSection(value),
                  ),

                  const SizedBox(height: 40),

                  // Action Button
                  FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 600),
                    child: CustomAppButton(
                      buttonTitle: 'SEND UPDATE',
                      onTap: () {
                        if (value.selectedChild != null &&
                            value.selectedChild!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a student'),
                            ),
                          );
                          return;
                        }
                        if (value.selectedUpdate != null &&
                            value.selectedUpdate!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select an update'),
                            ),
                          );
                          return;
                        }
                        value.submitEyeOnChildRecord();
                      },
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryBlue, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primaryDarkColor,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadSection(EyeOnYourChildProvider value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Upload Button Zone
        GestureDetector(
          onTap: value.files.length < 3 ? () => value.uploadAttachment() : null,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: value.files.length < 3
                  ? AppColors.primaryBlue.withOpacity(0.04)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: value.files.length < 3
                    ? AppColors.primaryBlue.withOpacity(0.3)
                    : Colors.grey.shade300,
                width: 1.5,
              ), // Note: Cannot easily do dashed border without external package, solid is fine and modern.
            ),
            child: Column(
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 32,
                  color: value.files.length < 3
                      ? AppColors.primaryBlue
                      : Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  value.files.length < 3
                      ? 'Tap to upload photos'
                      : 'Maximum photos reached',
                  style: TextStyle(
                    color: value.files.length < 3
                        ? AppColors.primaryDarkColor
                        : Colors.grey,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${value.files.length}/3 photos selected',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
              ],
            ),
          ),
        ),

        // Display Selected Files
        if (value.files.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 60,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: value.files.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final File? file = value.files[index];
                if (file == null) return const SizedBox.shrink();

                return Container(
                  width: 160,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLightBlue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.image_outlined,
                          size: 16,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          file.path.split('/').last,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDarkColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Ideally there should be a remove button, but provider doesn't have a removeAttachment method
                      // If it did: GestureDetector(onTap: () => value.removeFile(index), child: Icon(Icons.close, size: 16))
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
