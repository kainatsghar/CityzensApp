import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/cityzens_back_button.dart';
import 'package:tcs_app/CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/CustomWidgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/citizen/Provider/MarkAttendance/mark_attendance_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';

class MarkAttendanceHeader extends StatelessWidget {
  final bool allowClassSwitch;

  const MarkAttendanceHeader({
    super.key,
    this.allowClassSwitch = true,
  });

  Future<void> _safeReloadStudents(MarkAttendanceProvider prov) async {
    try {
      await prov.reloadStudentList();
    } catch (e) {
      DialogBuilder.hideOpenDialog();
      showSnackBar(e.toString());
    }
  }

  void _openClassSheet(BuildContext context, MarkAttendanceProvider prov) {
    final sections = prov.sections;
    if (sections.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
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
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Text(
                    'Choose class',
                    style: AppThemes.sora(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: sections.length,
                    itemBuilder: (_, i) {
                      final opt = sections[i];
                      final String name = opt.title ?? '';
                      final bool isSelected =
                          prov.sectionController.text == name;

                      return InkWell(
                        onTap: () async {
                          await prov.setSelectedSection(name);
                          if (prov.classId == 19 || prov.classId == 20) {
                            final subjList = prov.subjects;
                            if (subjList.isNotEmpty) {
                              prov.subjectId = subjList.first.value ?? 0;
                              prov.subjectController.text =
                                  subjList.first.title ?? '';
                            }
                          }
                          await _safeReloadStudents(prov);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.blueTint
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        );
      },
    );
  }

  void _openSubjectSheet(BuildContext context, MarkAttendanceProvider prov) {
    final subjects = prov.subjects;
    if (subjects.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
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
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Text(
                    'Choose subject',
                    style: AppThemes.sora(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: subjects.length,
                    itemBuilder: (_, i) {
                      final opt = subjects[i];
                      final String name = opt.title ?? '';
                      final bool isSelected =
                          prov.subjectController.text == name;

                      return InkWell(
                        onTap: () async {
                          prov.setSelectedSubject(name);
                          await _safeReloadStudents(prov);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.blueTint
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarkAttendanceProvider>(
      builder: (context, prov, _) {
        final String selectedClass = prov.sectionController.text.isNotEmpty
            ? prov.sectionController.text
            : 'Choose class';
        final bool isALevel = prov.classId == 19 || prov.classId == 20;

        return Container(
          width: double.infinity,
          color: AppColors.blue,
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top Bar Row (Circular Back Button, Centered Title, Spacer)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CityzensBackButton(
                        size: 40,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      Text(
                        'Mark attendance',
                        style: AppThemes.sora(
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 40, height: 40),
                    ],
                  ),
                ),

                // Class Picker Pill (.ma .pick)
                if (prov.sections.isNotEmpty ||
                    prov.sectionController.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    child: Column(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: allowClassSwitch && prov.sections.isNotEmpty
                                ? () => _openClassSheet(context, prov)
                                : null,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.13),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'CLASS',
                                          style: AppThemes.roboto(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.6,
                                            color: Colors.white.withValues(
                                              alpha: 0.72,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 1),
                                        Text(
                                          selectedClass,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppThemes.sora(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (allowClassSwitch &&
                                      prov.sections.isNotEmpty)
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (isALevel && prov.subjects.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: allowClassSwitch
                                  ? () => _openSubjectSheet(context, prov)
                                  : null,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.13),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'SUBJECT',
                                            style: AppThemes.roboto(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.6,
                                              color: Colors.white.withValues(
                                                alpha: 0.72,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 1),
                                          Text(
                                            prov.subjectController.text
                                                    .isNotEmpty
                                                ? prov.subjectController.text
                                                : 'Choose subject',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppThemes.sora(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (allowClassSwitch)
                                      const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
