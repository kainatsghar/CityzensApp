import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomCard/custom_card.dart';
import 'package:tcs_app/custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/model/Promotion/promotion_model.dart';
import 'package:tcs_app/model/Promotion/promotion_enums.dart';
import 'package:tcs_app/repositories/Promotion/promotion_repository.dart';
import 'package:tcs_app/utils/app_colors.dart';

class PromotionFormScreen extends StatefulWidget {
  final PromotionModel? promotion;

  const PromotionFormScreen({super.key, this.promotion});

  @override
  State<PromotionFormScreen> createState() => _PromotionFormScreenState();
}

class _PromotionFormScreenState extends State<PromotionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final PromotionRepository _repository = PromotionRepository();
  bool _isLoading = false;
  bool _wasModified = false;
  PromotionModel? _currentPromotion;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _urlController;
  late TextEditingController _tapLinkURLController;
  late TextEditingController _displayDurationController;
  late TextEditingController _filePathController;

  File? _pickedFile;

  bool _isLive = false;
  bool _isTesting = false;
  bool _isFullScreen = true;
  PromotionType _promotionType = PromotionType.image;
  AdPosition _adPosition = AdPosition.launchPage;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _currentPromotion = widget.promotion;
    _populateFields();
  }

  void _populateFields() {
    final p = _currentPromotion;
    _titleController = TextEditingController(text: p?.title ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _urlController = TextEditingController(text: p?.url ?? '');
    _tapLinkURLController = TextEditingController(text: p?.tapLinkURL ?? '');
    _displayDurationController = TextEditingController(
      text: p?.displayDuration.toString() ?? '30',
    );

    _isLive = p?.isLive ?? false;
    _isTesting = p?.isTesting ?? false;
    _isFullScreen = p?.isFullScreen ?? true;
    _promotionType = PromotionType.fromString(p?.promotionType);
    _adPosition = AdPosition.fromString(p?.adPosition);
    _startDate = p?.startDate;
    _endDate = p?.endDate;
    _filePathController = TextEditingController(text: p?.filePath ?? '');
    _pickedFile = null; // Reset on populate
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    _tapLinkURLController.dispose();
    _displayDurationController.dispose();
    _filePathController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryBlue,
              onPrimary: Colors.white,
              onSurface: AppColors.primaryDarkBlue,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate; // Auto-fix end date
          }
        } else {
          if (_startDate != null && picked.isBefore(_startDate!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('End Date cannot be before Start Date'),
              ),
            );
            return;
          }
          _endDate = picked;
        }
      });
    }
  }

  String? _urlValidator(String? value) {
    if (value != null && value.isNotEmpty) {
      final uri = Uri.tryParse(value);
      if (uri == null || !uri.hasAbsolutePath) {
        return 'Please enter a valid URL';
      }
    }
    return null;
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both Start and End Dates.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    String generatedKey = _titleController.text.trim().toLowerCase().replaceAll(
      RegExp(r'\s+'),
      '_',
    );

    final newPromotion = PromotionModel(
      id: _currentPromotion?.id ?? 0,
      promotionKey: generatedKey.isEmpty ? null : generatedKey,
      title: _titleController.text.isEmpty ? null : _titleController.text,
      description: _descriptionController.text.isEmpty
          ? null
          : _descriptionController.text,
      url: _urlController.text.isEmpty ? null : _urlController.text,
      tapLinkURL: _tapLinkURLController.text.isEmpty
          ? null
          : _tapLinkURLController.text,
      displayFileName: '',
      filePath: _filePathController.text.isEmpty
          ? null
          : _filePathController.text,
      adPosition: _adPosition.value,
      displayDuration: int.tryParse(_displayDurationController.text) ?? 30,
      isLive: _isLive,
      isTesting: _isTesting,
      isFullScreen: _isFullScreen,
      promotionType: _promotionType.value,
      startDate: _startDate,
      endDate: _endDate,
    );

    if (_currentPromotion == null) {
      await _repository.addPromotion(newPromotion, file: _pickedFile);
    } else {
      await _repository.updatePromotion(newPromotion, file: _pickedFile);
    }

    // Refetch to get the latest DB ID and populated data
    final list = await _repository.getActivePromotionList();
    if (list != null) {
      try {
        final updated = list.firstWhere((p) => p.promotionKey == generatedKey);
        _currentPromotion = updated;
        _populateFields();
      } catch (e) {
        // Fallback if not found
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
        _wasModified = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Promotion saved successfully!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: AppColors.successGreen,
        ),
      );
    }
  }

  void _delete() async {
    if (_currentPromotion == null) return;

    bool confirm =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Confirm Delete',
              style: TextStyle(
                color: AppColors.primaryDarkBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Are you sure you want to delete promotion "${_currentPromotion!.title ?? _currentPromotion!.promotionKey}"?',
              style: const TextStyle(color: AppColors.softGreyText),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      setState(() => _isLoading = true);
      await _repository.deletePromotion(_currentPromotion!.id);
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pop(context, true); // Pop out to list after delete
      }
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context, _wasModified);
    return false;
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryBlue, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDarkBlue,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.media,
      allowMultiple: false,
    );
    if (result != null && result.files.single.path != null) {
      final file = result.files.single;
      final ext = file.extension?.toLowerCase() ?? '';
      final isVideo = ['mp4', 'mov', 'avi', 'mkv', 'webm', 'flv'].contains(ext);
      setState(() {
        _pickedFile = File(file.path!);
        _filePathController.text = file.name;
        _promotionType = isVideo ? PromotionType.video : PromotionType.image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.ultraLightGrey,
        appBar: CustomAppBar(
          title: _currentPromotion == null
              ? 'CREATE PROMOTION'
              : 'EDIT PROMOTION',
          onBackPressed: () => Navigator.pop(context, _wasModified),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryBlue),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- General Details ---
                      CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(
                              'General Details',
                              Icons.info_outline,
                            ),
                            CustomTextFormField(
                              controller: _titleController,
                              hintText: 'Title',
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                            const SizedBox(height: 12),
                            CustomTextFormField(
                              controller: _descriptionController,
                              hintText: 'Description',
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- Media Configuration & File Upload ---
                      CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(
                              'Media Configuration',
                              Icons.perm_media_outlined,
                            ),
                            // Type dropdown (auto-set on file pick)
                            DropdownButtonFormField<PromotionType>(
                              value: _promotionType,
                              decoration: InputDecoration(
                                labelText: 'Type',
                                filled: true,
                                fillColor: AppColors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              items: PromotionType.values.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(
                                    type.value.toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) =>
                                  setState(() => _promotionType = val!),
                            ),
                            const SizedBox(height: 16),
                            // File display row
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.ultraLightGrey,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.primaryBlue.withValues(
                                    alpha: 0.15,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _pickedFile != null
                                        ? Icons.insert_drive_file_rounded
                                        : Icons.file_open_outlined,
                                    size: 18,
                                    color: _pickedFile != null
                                        ? AppColors.primaryBlue
                                        : AppColors.softGreyText,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _filePathController.text.isEmpty
                                          ? 'No file selected'
                                          : _filePathController.text,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: _pickedFile != null
                                            ? AppColors.primaryDarkColor
                                            : AppColors.softGreyText,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (_pickedFile != null)
                                    GestureDetector(
                                      onTap: () => setState(() {
                                        _pickedFile = null;
                                        _filePathController.clear();
                                      }),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 18,
                                        color: AppColors.errorRed,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Browse button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _pickFile,
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: AppColors.primaryBlue,
                                    width: 1.5,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.attach_file_rounded,
                                  color: AppColors.primaryBlue,
                                  size: 18,
                                ),
                                label: Text(
                                  _pickedFile != null
                                      ? 'CHANGE FILE'
                                      : 'BROWSE FILE',
                                  style: const TextStyle(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            CustomTextFormField(
                              controller: _tapLinkURLController,
                              hintText: 'Tap Link URL (Optional)',
                              validator: _urlValidator,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- Display Settings ---
                      CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(
                              'Display Settings',
                              Icons.settings_overscan,
                            ),
                            DropdownButtonFormField<AdPosition>(
                              initialValue: _adPosition,
                              decoration: InputDecoration(
                                labelText: 'Ad Position',
                                filled: true,
                                fillColor: AppColors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              items: AdPosition.values.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(
                                    type.value,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) =>
                                  setState(() => _adPosition = val!),
                            ),
                            const SizedBox(height: 12),
                            CustomTextFormField(
                              controller: _displayDurationController,
                              hintText: 'Display Duration (seconds)',
                              inputType: TextInputType.number,
                            ),
                            const SizedBox(height: 12),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Is Full Screen',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: const Text(
                                'Cover the entire screen',
                                style: TextStyle(fontSize: 12),
                              ),
                              activeThumbColor: AppColors.primaryBlue,
                              value: _isFullScreen,
                              onChanged: (val) =>
                                  setState(() => _isFullScreen = val),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- Targeting & Status ---
                      CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(
                              'Targeting & Status',
                              Icons.track_changes,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _selectDate(context, true),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Start Date',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.softGreyText,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today,
                                                size: 16,
                                                color: AppColors.primaryBlue,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                _startDate == null
                                                    ? 'Select Date'
                                                    : '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _selectDate(context, false),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'End Date',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.softGreyText,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today,
                                                size: 16,
                                                color: AppColors.primaryBlue,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                _endDate == null
                                                    ? 'Select Date'
                                                    : '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Is Live',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: const Text(
                                'Make this promotion active',
                                style: TextStyle(fontSize: 12),
                              ),
                              activeThumbColor: AppColors.successGreen,
                              value: _isLive,
                              onChanged: (val) => setState(() => _isLive = val),
                            ),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text(
                                'Is Testing',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: const Text(
                                'Only visible to testers',
                                style: TextStyle(fontSize: 12),
                              ),
                              activeThumbColor: AppColors.warningOrange,
                              value: _isTesting,
                              onChanged: (val) =>
                                  setState(() => _isTesting = val),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Save Button
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              onPressed: _save,
                              child: const Text(
                                'SAVE PROMOTION',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                          if (_currentPromotion != null) ...[
                            const SizedBox(width: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.errorRed,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              onPressed: _delete,
                              child: const Icon(
                                Icons.delete,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
