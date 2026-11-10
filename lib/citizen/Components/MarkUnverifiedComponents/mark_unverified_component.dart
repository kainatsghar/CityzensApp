import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CityzensIcons/cityzens_icons.dart';
import 'package:tcs_app/citizen/Model/Options/options.dart';
import 'package:tcs_app/citizen/Provider/MarkUnverified/mark_unverified_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final prov = Provider.of<MarkUnverifiedProvider>(context, listen: false);
      bool changed = false;
      if (prov.sectionId == null && prov.sections.isNotEmpty) {
        prov.sectionId = prov.sections.first.value;
        prov.sectionController.text = prov.sections.first.title ?? '';
        changed = true;
      }
      if (prov.reasonId == null && prov.reasons.isNotEmpty) {
        prov.reasonId = prov.reasons.first.value;
        prov.reasonController.text = prov.reasons.first.title ?? '';
        changed = true;
      }
      if (changed && mounted) {
        setState(() {});
      }
    });
  }

  CityzensIconType _reasonIcon(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('new') || lower.contains('admis')) {
      return CityzensIconType.plus;
    }
    if (lower.contains('withdraw')) {
      return CityzensIconType.logout;
    }
    if (lower.contains('repeat') ||
        lower.contains('detain') ||
        lower.contains('transfer') ||
        lower.contains('switch')) {
      return CityzensIconType.switchArrows;
    }
    return CityzensIconType.info;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarkUnverifiedProvider>(
      builder: (context, value, _) {
        return Column(
          children: [
            // Scrollable Numbered Form Cards (.mu .bd)
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Form(
                  key: value.formKey,
                  child: Column(
                    children: [
                      // 1 STUDENT Card
                      _buildStepCard(
                        stepNumber: '1',
                        title: 'STUDENT',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFieldLabel('Student name', required: true),
                            const SizedBox(height: 5),
                            _buildTextField(
                              controller: value.studentNameController,
                              hint: 'Full name',
                              textInputAction: TextInputAction.next,
                              validator: value.validator,
                            ),
                            const SizedBox(height: 10),
                            _buildFieldLabel(
                              'Roll number',
                              optionalText: '(optional)',
                            ),
                            const SizedBox(height: 5),
                            _buildTextField(
                              controller: value.studentIdController,
                              hint: 'e.g. 194820',
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 2 CLASS AND SECTION Card
                      _buildStepCard(
                        stepNumber: '2',
                        title: 'CLASS AND SECTION',
                        child: FormField<int>(
                          key: ValueKey('sec_${value.sectionId}'),
                          initialValue: value.sectionId,
                          validator: (_) => value.sectionId == null
                              ? 'Please select a section'
                              : null,
                          builder: (fieldState) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: value.sections.map((Options opt) {
                                    final bool isSelected =
                                        value.sectionId == opt.value;
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          value.sectionId = opt.value;
                                          value.sectionController.text =
                                              opt.title ?? '';
                                        });
                                        fieldState.didChange(opt.value);
                                      },
                                      borderRadius: BorderRadius.circular(999),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 140),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 9,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.blue
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(999),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.blue
                                                : const Color(0xFFD5DAE2),
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (isSelected) ...[
                                              const Icon(
                                                Icons.check_rounded,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 6),
                                            ],
                                            Text(
                                              opt.title ?? '',
                                              style: AppThemes.sora(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w600,
                                                color: isSelected
                                                    ? Colors.white
                                                    : AppColors.ink,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                if (fieldState.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      fieldState.errorText!,
                                      style: AppThemes.roboto(
                                        fontSize: 11.5,
                                        color: const Color(0xFFC42840),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 3 REASON Card
                      _buildStepCard(
                        stepNumber: '3',
                        title: 'REASON',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FormField<int>(
                              key: ValueKey('rsn_${value.reasonId}'),
                              initialValue: value.reasonId,
                              validator: (_) => value.reasonId == null
                                  ? 'Please select a reason'
                                  : null,
                              builder: (fieldState) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: value.reasons.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 8,
                                        mainAxisSpacing: 8,
                                        childAspectRatio: 2.15,
                                      ),
                                      itemBuilder: (_, idx) {
                                        final opt = value.reasons[idx];
                                        final String title = opt.title ?? '';
                                        final bool isSelected =
                                            value.reasonId == opt.value;

                                        return InkWell(
                                          onTap: () {
                                            setState(() {
                                              value.reasonId = opt.value;
                                              value.reasonController.text =
                                                  title;
                                            });
                                            fieldState.didChange(opt.value);
                                          },
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 140,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? AppColors.blueTint
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              border: Border.all(
                                                color: isSelected
                                                    ? AppColors.blue
                                                    : const Color(0xFFD5DAE2),
                                                width: isSelected ? 2.0 : 1.5,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CityzensIcon(
                                                  type: _reasonIcon(title),
                                                  size: 24,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  title,
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppThemes.sora(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: isSelected
                                                        ? AppColors.blue
                                                        : AppColors.ink,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    if (fieldState.hasError)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          fieldState.errorText!,
                                          style: AppThemes.roboto(
                                            fontSize: 11.5,
                                            color: const Color(0xFFC42840),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            _buildFieldLabel('Remarks', required: true),
                            const SizedBox(height: 5),
                            _buildTextField(
                              controller: value.remarksController,
                              hint: 'Anything the office should know',
                              maxLines: 3,
                              textInputAction: TextInputAction.done,
                              validator: value.validator,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Sticky Bottom Submit Button (.mu .ft)
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: AppColors.line),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Container(
                    width: double.infinity,
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.yellowDeep,
                          offset: Offset(0, 2),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => value.markUnverified(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellow,
                        foregroundColor: AppColors.blue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Submit',
                        style: AppThemes.sora(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.blue,
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

  Widget _buildStepCard({
    required String stepNumber,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.blueTint,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: Text(
                  stepNumber,
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
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _buildFieldLabel(
    String label, {
    bool required = false,
    String? optionalText,
  }) {
    return RichText(
      text: TextSpan(
        text: label,
        style: AppThemes.roboto(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.muted,
        ),
        children: [
          if (required)
            TextSpan(
              text: ' *',
              style: AppThemes.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFC42840),
              ),
            ),
          if (optionalText != null)
            TextSpan(
              text: ' $optionalText',
              style: AppThemes.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: const Color(0xFFA0A8B5),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      validator: validator,
      style: AppThemes.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.ink,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppThemes.roboto(
          fontSize: 14,
          color: const Color(0xFFA0A8B5),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: maxLines > 1 ? 10 : 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCDD4DE)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC42840)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC42840), width: 1.5),
        ),
      ),
    );
  }
}
