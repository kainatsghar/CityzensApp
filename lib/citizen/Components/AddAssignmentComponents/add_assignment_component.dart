import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CityzensIcons/cityzens_icons.dart';
import 'package:tcs_app/CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/CustomWidgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/citizen/Model/Options/options.dart';
import 'package:tcs_app/citizen/Provider/Assignment/assignment_provider.dart';

class AddAssignmentComponent extends StatefulWidget {
  const AddAssignmentComponent({super.key});

  @override
  State<AddAssignmentComponent> createState() => _AddAssignmentComponentState();
}

class _AddAssignmentComponentState extends State<AddAssignmentComponent> {
  final GlobalKey<FormFieldState<String>> _sectionFieldKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> _subjectFieldKey =
      GlobalKey<FormFieldState<String>>();

  DateTime _selectedDate = DateTime.now();
  String? _fileSizeLabel;
  bool _loadingSubjects = false;
  bool _didInitDefaults = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initDefaults());
  }

  Future<void> _initDefaults() async {
    if (_didInitDefaults || !mounted) return;
    _didInitDefaults = true;
    final value = Provider.of<AssignmentProvider>(context, listen: false);
    value.fileName = '';
    value.base64String = '';

    if (value.formattedDate.isNotEmpty) {
      final parsed = DateTime.tryParse(value.formattedDate);
      if (parsed != null) {
        _selectedDate = parsed;
      }
    }
    if (value.sections.isNotEmpty && value.sectionId == null) {
      final firstSection = value.sections.first;
      value.sectionId = firstSection.value;
      value.sectionController.text = firstSection.title ?? '';
      _sectionFieldKey.currentState?.didChange(value.sectionController.text);
      await _loadSubjectsQuietly(value);
    } else if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadSubjectsQuietly(AssignmentProvider value) async {
    if (!mounted) return;
    setState(() => _loadingSubjects = true);
    try {
      await value.loadSubjects();
      if (mounted &&
          value.subjectController.text.isEmpty &&
          value.subjects.isNotEmpty) {
        value.subjectController.text = value.subjects.first.title ?? '';
        _subjectFieldKey.currentState?.didChange(value.subjectController.text);
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _loadingSubjects = false);
      }
    }
  }

  Future<void> _selectSection(
    AssignmentProvider value,
    Options option,
  ) async {
    final String title = option.title ?? '';
    if (value.sectionId == option.value &&
        value.sectionController.text == title) {
      return;
    }
    value.sectionId = option.value;
    value.sectionController.text = title;
    value.subjectController.clear();
    _sectionFieldKey.currentState?.didChange(title);
    _subjectFieldKey.currentState?.didChange('');

    DialogBuilder.showLoadingIndicator();
    try {
      await value.loadSubjects();
      if (mounted && value.subjects.isNotEmpty) {
        value.subjectController.text = value.subjects.first.title ?? '';
        _subjectFieldKey.currentState?.didChange(value.subjectController.text);
      }
    } catch (e) {
      showSnackBar(e.toString());
    } finally {
      DialogBuilder.hideOpenDialog();
    }
    if (mounted) setState(() {});
  }

  void _selectSubject(AssignmentProvider value, Options option) {
    final String title = option.title ?? '';
    value.subjectController.text = title;
    _subjectFieldKey.currentState?.didChange(title);
    setState(() {});
  }

  Future<void> _pickDate(AssignmentProvider value) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.blue,
              onPrimary: Colors.white,
              onSurface: AppColors.ink,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
        value.formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  String _relativeDateLabel(DateTime date) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime target = DateTime(date.year, date.month, date.day);
    final int diff = target.difference(today).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff == -1) return 'Yesterday';
    return DateFormat('EEE').format(date);
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(0)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _pickFile(AssignmentProvider value) async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx'],
    );
    if (result != null && result.files.isNotEmpty) {
      final PlatformFile picked = result.files.single;
      final String? path = picked.path;
      List<int>? bytes = picked.bytes;
      if (bytes == null && path != null) {
        bytes = await File(path).readAsBytes();
      }
      if (bytes == null) return;

      final String rawName = picked.name.isNotEmpty
          ? picked.name
          : (path ?? '').split(Platform.pathSeparator).last.split('/').last;
      final String base64 = base64Encode(bytes);
      value.base64String = base64;
      value.fileName = rawName;
      if (mounted) {
        setState(() {
          _fileSizeLabel = _formatBytes(bytes!.length);
        });
      }
    }
  }

  void _openSearchablePickerSheet({
    required BuildContext context,
    required String title,
    required List<Options> options,
    required String selectedTitle,
    required ValueChanged<Options> onSelect,
  }) {
    final TextEditingController searchCtrl = TextEditingController();
    String query = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final List<Options> filtered = query.trim().isEmpty
                ? options
                : options
                    .where((o) => (o.title ?? '')
                        .toLowerCase()
                        .contains(query.trim().toLowerCase()))
                    .toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD5DAE2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              title,
                              style: AppThemes.sora(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.blueTint,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${options.length} ${options.length == 1 ? 'option' : 'options'}',
                                style: AppThemes.sora(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextField(
                        controller: searchCtrl,
                        onChanged: (val) => setSheetState(() => query = val),
                        style: AppThemes.roboto(
                          fontSize: 14,
                          color: AppColors.ink,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: AppThemes.roboto(
                            fontSize: 13.5,
                            color: AppColors.muted,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: AppColors.muted,
                          ),
                          filled: true,
                          fillColor: AppColors.paper,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: AppColors.line),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.blue,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(ctx).size.height * 0.42,
                        ),
                        child: filtered.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 24,
                                ),
                                child: Center(
                                  child: Text(
                                    'No matching options',
                                    style: AppThemes.roboto(
                                      fontSize: 13,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: filtered.length,
                                itemBuilder: (_, i) {
                                  final opt = filtered[i];
                                  final String name = opt.title ?? '';
                                  final bool isSelected = name == selectedTitle;

                                  return InkWell(
                                    onTap: () {
                                      Navigator.of(sheetCtx).pop();
                                      onSelect(opt);
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      height: 48,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? AppColors.blueTint
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: AppThemes.sora(
                                                fontSize: 14,
                                                fontWeight: isSelected
                                                    ? FontWeight.w700
                                                    : FontWeight.w600,
                                                color: isSelected
                                                    ? AppColors.blue
                                                    : AppColors.ink,
                                              ),
                                            ),
                                          ),
                                          if (isSelected)
                                            const Icon(
                                              Icons.check_rounded,
                                              color: AppColors.blue,
                                              size: 20,
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line),
        boxShadow: [
          BoxShadow(
            color: AppColors.blueDeep.withValues(alpha: 0.06),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildCardHeader(String step, String title) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: AppColors.blueTint,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            step,
            style: AppThemes.sora(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.blue,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppThemes.sora(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: AppColors.blue,
            letterSpacing: 0.7,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: AppThemes.sora(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
    );
  }

  Widget _buildOptionSelector({
    required BuildContext context,
    required GlobalKey<FormFieldState<String>> fieldKey,
    required List<Options> options,
    required String selectedText,
    required String placeholder,
    required String sheetTitle,
    required ValueChanged<Options> onSelect,
    bool isLoading = false,
  }) {
    return FormField<String>(
      key: fieldKey,
      initialValue: selectedText,
      validator: (_) => HelperFunction.validator(selectedText),
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isLoading)
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.line),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.blue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Loading...',
                      style: AppThemes.roboto(
                        fontSize: 13.5,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              )
            else if (options.isEmpty)
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.paper,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: field.hasError ? AppColors.red : AppColors.line,
                  ),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  placeholder,
                  style: AppThemes.roboto(
                    fontSize: 13.5,
                    color: AppColors.muted,
                  ),
                ),
              )
            else
              InkWell(
                onTap: () => _openSearchablePickerSheet(
                  context: context,
                  title: sheetTitle,
                  options: options,
                  selectedTitle: selectedText,
                  onSelect: (opt) {
                    field.didChange(opt.title ?? '');
                    onSelect(opt);
                  },
                ),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: field.hasError ? AppColors.red : AppColors.line,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedText.isNotEmpty ? selectedText : placeholder,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppThemes.sora(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: selectedText.isNotEmpty
                                ? AppColors.ink
                                : AppColors.muted,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${options.length} ${options.length == 1 ? 'option' : 'options'}',
                        style: AppThemes.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: AppColors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            if (field.hasError) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  field.errorText!,
                  style: AppThemes.roboto(
                    fontSize: 12,
                    color: AppColors.red,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildAttachmentBox(AssignmentProvider value) {
    final String fileName = value.fileName ?? '';
    if (fileName.isNotEmpty) {
      final String ext = fileName.contains('.')
          ? fileName.split('.').last.toUpperCase()
          : 'FILE';
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.blueTint,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.blue.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.blue,
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                ext,
                style: AppThemes.sora(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppThemes.sora(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  if (_fileSizeLabel != null)
                    Text(
                      _fileSizeLabel!,
                      style: AppThemes.roboto(
                        fontSize: 11.5,
                        color: AppColors.muted,
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  value.fileName = '';
                  value.base64String = '';
                  _fileSizeLabel = null;
                });
              },
              icon: const Icon(
                Icons.close_rounded,
                size: 18,
                color: AppColors.blue,
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              tooltip: 'Remove attachment',
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: () => _pickFile(value),
      borderRadius: BorderRadius.circular(12),
      child: CustomPaint(
        painter: const _DashedBorderPainter(
          color: Color(0xFFD5DAE2),
          radius: 12,
        ),
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.attach_file_rounded,
                  size: 18,
                  color: AppColors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  'Attach a file',
                  style: AppThemes.sora(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'PDF, DOC, PPT',
                  style: AppThemes.roboto(
                    fontSize: 11.5,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssignmentProvider>(
      builder: (context, value, _) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                child: Form(
                  key: value.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1 CLASS AND SUBJECT
                      _buildCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCardHeader('1', 'CLASS AND SUBJECT'),
                            const SizedBox(height: 12),
                            _buildFieldLabel('Section'),
                            const SizedBox(height: 6),
                            _buildOptionSelector(
                              context: context,
                              fieldKey: _sectionFieldKey,
                              options: value.sections,
                              selectedText: value.sectionController.text,
                              placeholder: 'Select section',
                              sheetTitle: 'Choose section',
                              onSelect: (opt) => _selectSection(value, opt),
                            ),
                            const SizedBox(height: 14),
                            _buildFieldLabel('Subject'),
                            const SizedBox(height: 6),
                            _buildOptionSelector(
                              context: context,
                              fieldKey: _subjectFieldKey,
                              options: value.subjects,
                              selectedText: value.subjectController.text,
                              placeholder: 'Select a section first',
                              sheetTitle: 'Choose subject',
                              isLoading: _loadingSubjects,
                              onSelect: (opt) => _selectSubject(value, opt),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 2 DATE
                      _buildCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCardHeader('2', 'DATE'),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () => _pickDate(value),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 48,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.line),
                                ),
                                child: Row(
                                  children: [
                                    const CityzensIcon(
                                      type: CityzensIconType.event,
                                      size: 22,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        DateFormat('MM/dd/yyyy')
                                            .format(_selectedDate),
                                        style: AppThemes.sora(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.ink,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 15,
                                      color: AppColors.ink,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _relativeDateLabel(_selectedDate),
                                      style: AppThemes.roboto(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 3 CLASSWORK
                      _buildCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCardHeader('3', 'CLASSWORK'),
                            const SizedBox(height: 12),
                            _buildFieldLabel('Description'),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: value.descriptionController,
                              validator: HelperFunction.validator,
                              minLines: 4,
                              maxLines: 6,
                              textCapitalization: TextCapitalization.sentences,
                              style: AppThemes.roboto(
                                fontSize: 14,
                                color: AppColors.ink,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    'e.g. Worksheet on fractions, page 32',
                                hintStyle: AppThemes.roboto(
                                  fontSize: 13.5,
                                  color: AppColors.muted,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.all(14),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: AppColors.line),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.blue,
                                    width: 1.5,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: AppColors.red),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.red,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildAttachmentBox(value),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Sticky Bottom Save Bar
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.line)),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFD9C400),
                          offset: Offset(0, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => value.submitAssignment(),
                        borderRadius: BorderRadius.circular(12),
                        child: Center(
                          child: Text(
                            'Save classwork',
                            style: AppThemes.sora(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  const _DashedBorderPainter({
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final RRect rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    ).deflate(0.75);
    final Path path = Path()..addRRect(rrect);
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double dash = 5.0;
    const double gap = 3.5;
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final double next = (distance + dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
