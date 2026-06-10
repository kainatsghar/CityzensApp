import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../custom_widgets/CustomAppBar/custom_app_bar.dart';
import '../../../custom_widgets/CustomAppButton/custom_app_button.dart';
import '../../../custom_widgets/CustomCard/custom_card.dart';
import '../../../custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import '../../../custom_widgets/TabSelector/tab_selector.dart';
import '../../../model/Diary/diary_response.dart';
import '../../../model/SectionSubject/section_subject_response.dart';
import '../../../model/TeacherSection/teacher_section_response.dart';
import '../../../provider/Dashboard/dashboard_provider.dart';
import '../../../provider/Diary/diary_provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/helper_function.dart';

/// Screen for adding or editing a Homework Diary entry.
///
/// Data flow follows the ChallanPaymentScreen pattern:
///   1. Route generator casts `settings.arguments` → passes as constructor param
///   2. Screen receives [editRecord] directly — no ModalRoute lookups needed
///   3. `widget.editRecord` is available immediately in initState
class AddDiaryScreen extends StatefulWidget {
  const AddDiaryScreen({super.key, this.editRecord});

  /// The record to edit. Null means "Add New" mode.
  final DiaryRecords? editRecord;

  @override
  State<AddDiaryScreen> createState() => _AddDiaryScreenState();
}

class _AddDiaryScreenState extends State<AddDiaryScreen> {
  late final DiaryProvider _provider;
  late final DashboardProvider _dashboardProvider;

  bool get _isEdit => widget.editRecord != null;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<DiaryProvider>(context, listen: false);
    _dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);

    // Always start with a clean form
    _provider.clearFormState();

    if (_isEdit) {
      // Step 1: Populate controllers synchronously BEFORE first build
      _provider.initForEdit(widget.editRecord!);

      // Step 2: Resolve IDs after the first frame completes
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _resolveEditIds();
      });
    }
  }

  void _resolveEditIds() {
    final sections = _dashboardProvider.getSectionsWithDiary(true) ?? [];
    final matchedSection = sections.cast<Section?>().firstWhere(
      (s) => s?.name == _provider.sectionController.text,
      orElse: () => null,
    );
    final subjects = matchedSection != null
        ? _dashboardProvider.getSubjectsForSection(
                classSectionId: matchedSection.classSectionId ?? 0,
                isDiary: true,
              ) ??
              <SectionSubject>[]
        : <SectionSubject>[];

    _provider.resolveIds(sections, subjects);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onUploadAttachment() async {
    final result = await FilePicker.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx'],
    );
    if (result != null) {
      final file = File(result.files.single.path!);
      final base64 = base64Encode(await file.readAsBytes());
      _provider.setAttachment(result.files.single.name, base64);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: _isEdit ? 'EDIT HOMEWORK' : 'ADD HOMEWORK'),
      body: Consumer<DiaryProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Attachment ────────────────────────────────────────────
                if (provider.fileName != null && provider.fileName!.isNotEmpty)
                  _AttachmentPreview(
                    fileName: provider.fileName!,
                    onRemove: provider.removeAttachment,
                  )
                else
                  _AttachmentUploadButton(onTap: _onUploadAttachment),

                const SizedBox(height: 16),

                // ── Date Picker ──────────────────────────────────────────
                GestureDetector(
                  onTap: () async {
                    // final picked = await showDatePicker(
                    //   context: context,
                    //   initialDate:
                    //       DateTime.tryParse(provider.selectedDate ?? '') ??
                    //       DateTime.now(),
                    //   firstDate:
                    //       DateTime.tryParse(provider.selectedDate ?? '') ??
                    //       DateTime.now(),
                    //   lastDate:
                    //       DateTime.tryParse(provider.selectedDate ?? '') ??
                    //       DateTime.now(),
                    //   builder: (context, child) {
                    //     return Theme(
                    //       data: Theme.of(context).copyWith(
                    //         colorScheme: const ColorScheme.light(
                    //           primary: AppColors.primaryBlue,
                    //           onPrimary: Colors.white,
                    //           surface: Colors.white,
                    //           onSurface: AppColors.primaryDarkColor,
                    //         ),
                    //       ),
                    //       child: child!,
                    //     );
                    //   },
                    // );
                    // if (picked != null) {
                    //   provider.setSelectedDate(picked);
                    // }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primaryBlue.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.calendar_month_rounded,
                            color: AppColors.primaryBlue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'HOMEWORK DATE',
                              style: TextStyle(
                                fontSize: 10,
                                letterSpacing: 0.5,
                                color: AppColors.primaryBlue.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              HelperFunction.dateFormatter(
                                provider.selectedDate,
                              ),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryDarkColor,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.edit_calendar_rounded,
                          size: 18,
                          color: AppColors.primaryBlue,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Form card ─────────────────────────────────────────────
                CustomCard(
                  child: Form(
                    key: provider.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _FieldLabel('Select Section'),
                        Consumer<DashboardProvider>(
                          builder: (_, dashboard, child) {
                            return TabSelector<Section>(
                              key: const ValueKey('section_selector'),
                              items: dashboard.getSectionsWithDiary(true),
                              getDisplayText: (s) => s.name ?? 'N/A',
                              initialItemName: provider.sectionController.text,
                              isEnabled: !provider.isEdit,
                              onItemSelected: (section) {
                                if (provider.sectionId ==
                                    section.classSectionId) {
                                  return;
                                }
                                provider.sectionController.text =
                                    section.name ?? '';
                                provider.setSectionId(
                                  section.classSectionId ?? 0,
                                );
                                provider.subjectController.clear();
                                provider.setSubjectId(null, null);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        const _FieldLabel('Select Subject'),
                        Consumer<DashboardProvider>(
                          builder: (_, dashboard, child) {
                            return TabSelector<SectionSubject>(
                              key: ValueKey('subject_${provider.sectionId}'),
                              items: dashboard.getSubjectsForSection(
                                classSectionId: provider.sectionId ?? 0,
                                isDiary: true,
                              ),
                              getDisplayText: (s) => s.subjectName ?? 'N/A',
                              initialItemName: provider.subjectController.text,
                              onItemSelected: (subject) {
                                provider.setSubjectId(
                                  subject.subjectId,
                                  subject.subjectName,
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        CustomTextFormField(
                          controller: provider.descriptionController,
                          inputType: TextInputType.multiline,
                          inputAction: TextInputAction.newline,
                          maxLines: 4,
                          hintText: 'Description',
                          validator: HelperFunction.validator,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                CustomAppButton(
                  buttonTitle: _isEdit ? 'Update' : 'Save',
                  onTap: () {
                    if (_isEdit) {
                      provider.updateDiary(widget.editRecord!);
                    } else {
                      provider.submitDiary();
                    }
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── Reusable sub-widgets ───────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.primaryDarkColor,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _AttachmentPreview extends StatelessWidget {
  final String fileName;
  final VoidCallback onRemove;
  const _AttachmentPreview({required this.fileName, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.insert_drive_file, color: AppColors.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Attachment',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  fileName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDarkColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent),
            tooltip: 'Remove attachment',
          ),
        ],
      ),
    );
  }
}

class _AttachmentUploadButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AttachmentUploadButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Column(
          children: [
            Icon(Icons.cloud_upload_outlined, color: Colors.grey, size: 32),
            SizedBox(height: 8),
            Text(
              'Upload Attachment',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 2),
            Text(
              'PDF, DOC, PPT supported',
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
