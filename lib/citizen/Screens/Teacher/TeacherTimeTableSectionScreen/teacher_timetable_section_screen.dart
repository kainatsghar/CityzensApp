import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/cityzens_back_button.dart';
import 'package:tcs_app/CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/citizen/Components/TimeTableComponents/teacher_timetable_component.dart';
import 'package:tcs_app/citizen/Model/TimeTable/timetable_response.dart';
import 'package:tcs_app/citizen/Provider/TimeTable/timetable_provider.dart';

class TeacherTimeTableSectionScreen extends StatefulWidget {
  const TeacherTimeTableSectionScreen({super.key});

  @override
  State<TeacherTimeTableSectionScreen> createState() {
    return _TeacherTimeTableSectionScreenState();
  }
}

class _TeacherTimeTableSectionScreenState
    extends State<TeacherTimeTableSectionScreen> {
  late Future<TimeTableResponse> _initFuture;

  TimeTableProvider get provider =>
      Provider.of<TimeTableProvider>(AppNavigation.currentContext!,
          listen: false);

  @override
  void initState() {
    _initFuture = _initSectionsAndTimeTable();
    super.initState();
  }

  Future<TimeTableResponse> _initSectionsAndTimeTable() async {
    final sectionRes = await provider.loadSections();
    final list = sectionRes.section;
    if (list != null && list.isNotEmpty) {
      final first = list.first;
      provider.sectionId = first.classSectionId;
      provider.classId = first.classId;
      provider.sectionController.text = first.name ?? '';
    } else if (provider.sections.isNotEmpty) {
      final firstOpt = provider.sections.first;
      provider.sectionId = firstOpt.value;
      provider.sectionController.text = firstOpt.title ?? '';
    }
    provider.clearData();
    provider.isInitial = false;
    return provider.loadTimeTable();
  }

  Future<void> _reloadTimeTableForSection(
    TimeTableProvider prov,
    String name,
  ) async {
    await prov.setSelectedSection(name);
    DialogBuilder.showLoadingIndicator();
    try {
      prov.clearData();
      prov.isInitial = false;
      final Future<TimeTableResponse> nextFuture = prov.loadTimeTable();
      if (mounted) {
        setState(() {
          _initFuture = nextFuture;
        });
      }
      await nextFuture;
    } catch (e) {
      showSnackBar(e.toString());
    } finally {
      DialogBuilder.hideOpenDialog();
    }
  }

  void _openClassSheet(BuildContext context, TimeTableProvider prov) {
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
                        onTap: () {
                          if (isSelected) {
                            Navigator.of(sheetCtx).pop();
                            return;
                          }
                          _reloadTimeTableForSection(prov, name);
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
  void dispose() {
    provider.clearClassSectionData();
    provider.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: Column(
        children: [
          // T4 Blue Header (Back button, Timetable title, CLASS picker pill)
          Consumer<TimeTableProvider>(
            builder: (context, prov, _) {
              final String selectedClass = prov.sectionController.text.isNotEmpty
                  ? prov.sectionController.text
                  : 'Choose class';
              return Container(
                width: double.infinity,
                color: AppColors.blue,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CityzensBackButton(
                              size: 40,
                              onTap: () => Navigator.of(context).maybePop(),
                            ),
                            Text(
                              'Timetable',
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
                      if (prov.sections.isNotEmpty ||
                          prov.sectionController.text.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: prov.sections.isNotEmpty
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
                                    if (prov.sections.isNotEmpty)
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
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Body (FutureBuilder with Timetable Grid + Sticky Save Footer)
          Expanded(
            child: FutureBuilder<TimeTableResponse>(
              future: _initFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CustomLoader());
                  default:
                    if (snapshot.hasData) {
                      return const TeacherTimeTableComponent();
                    } else {
                      return ShowError(errorText: '${snapshot.error}');
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
