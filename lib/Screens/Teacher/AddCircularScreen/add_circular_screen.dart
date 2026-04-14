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
import '../../../model/CircularAnnouncement/circular_announcement_response.dart';
import '../../../model/TeacherSection/teacher_section_response.dart';
import '../../../provider/Circular/circular_provider.dart';
import '../../../provider/Dashboard/dashboard_provider.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/helper_function.dart';

/// Screen for adding or editing a Circular Announcement.
///
/// Data flow follows the ChallanPaymentScreen pattern:
///   Route generator casts `settings.arguments` → passes as constructor param.
class AddCircularScreen extends StatefulWidget {
  const AddCircularScreen({super.key, this.editRecord});

  /// The record to edit. Null means "Add New" mode.
  final CircularAnnouncementRecords? editRecord;

  @override
  State<AddCircularScreen> createState() => _AddCircularScreenState();
}

class _AddCircularScreenState extends State<AddCircularScreen> {
  late final CircularProvider _provider;
  late final DashboardProvider _dashboardProvider;

  bool get _isEdit => widget.editRecord != null;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<CircularProvider>(context, listen: false);
    _dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);

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
    _provider.resolveIds(sections);
  }

  @override
  void dispose() {
    _provider.clearData();
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
      appBar: CustomAppBar(title: _isEdit ? 'EDIT CIRCULAR' : 'ADD CIRCULAR'),
      body: Consumer<CircularProvider>(
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
                    final picked = await showDatePicker(
                      context: context,
                      initialDate:
                          DateTime.tryParse(provider.selectedDate ?? '') ??
                          DateTime.now(),
                      firstDate:
                          DateTime.tryParse(provider.selectedDate ?? '') ??
                          DateTime.now(),
                      lastDate:
                          DateTime.tryParse(provider.selectedDate ?? '') ??
                          DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: AppColors.lightRedColor,
                              onPrimary: Colors.white,
                              surface: Colors.white,
                              onSurface: AppColors.primaryDarkColor,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      provider.setSelectedDate(picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightRedColor.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.lightRedColor.withOpacity(0.12),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.lightRedColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.calendar_month_rounded,
                            color: AppColors.lightRedColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ANNOUNCEMENT DATE',
                              style: TextStyle(
                                fontSize: 10,
                                letterSpacing: 0.5,
                                color: AppColors.lightRedColor.withOpacity(0.7),
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
                          color: AppColors.lightRedColor,
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
                                    section.classSectionId)
                                  return;
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

                        const _FieldLabel('Title'),
                        CustomTextFormField(
                          controller: provider.titleController,
                          inputType: TextInputType.text,
                          inputAction: TextInputAction.next,
                          maxLines: 1,
                          hintText: 'Enter circular title',
                          validator: HelperFunction.validator,
                        ),
                        const SizedBox(height: 16),

                        const _FieldLabel('Description'),
                        CustomTextFormField(
                          controller: provider.descriptionController,
                          inputType: TextInputType.multiline,
                          inputAction: TextInputAction.newline,
                          maxLines: 4,
                          hintText: 'Enter circular description',
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
                      provider.updateCircular(widget.editRecord!);
                    } else {
                      provider.submitCircular();
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
        color: AppColors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryColor.withOpacity(0.2)),
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
            tooltip: 'Remove',
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
