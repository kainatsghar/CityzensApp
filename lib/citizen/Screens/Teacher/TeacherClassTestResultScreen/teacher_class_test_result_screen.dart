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
import 'package:tcs_app/citizen/Components/ClassTestResultComponents/teacher_add_class_result_component.dart';
import 'package:tcs_app/citizen/Model/ClassTestResult/class_test_student_list_response.dart';
import 'package:tcs_app/citizen/Model/Options/options.dart';
import 'package:tcs_app/citizen/Provider/ClassTestResult/class_test_result_provider.dart';

class TeacherClassTestResultScreen extends StatefulWidget {
  const TeacherClassTestResultScreen({super.key});

  @override
  State<TeacherClassTestResultScreen> createState() =>
      _TeacherClassTestResultScreenState();
}

class _TeacherClassTestResultScreenState
    extends State<TeacherClassTestResultScreen> {
  late Future<ClassTestResultStudentListResponse> _initFuture;

  ClassTestResultProvider get provider =>
      Provider.of<ClassTestResultProvider>(AppNavigation.currentContext!,
          listen: false);

  @override
  void initState() {
    _initFuture = _initializeClassTests();
    super.initState();
  }

  Future<ClassTestResultStudentListResponse> _initializeClassTests() async {
    provider.categoryId = 1;
    provider.selectedSubjectName = '';
    await provider.loadSections();
    if (provider.sections.isNotEmpty) {
      final firstSection = provider.sections.first;
      provider.sectionId = firstSection.value;
      provider.sectionController.text = firstSection.title ?? '';
      await provider.loadSubjects();
      if (provider.subjects.isNotEmpty) {
        final firstSubject = provider.subjects.first;
        provider.subjectId = firstSubject.value ?? 0;
        provider.selectedSubjectName = firstSubject.title ?? '';
        provider.subjectController.text = provider.selectedSubjectName;
        return provider.loadStudentsBySubject();
      }
    }
    return ClassTestResultStudentListResponse(studentList: []);
  }

  Future<void> _onSectionSelected(
    ClassTestResultProvider prov,
    Options option,
  ) async {
    final String title = option.title ?? '';
    if (prov.sectionId == option.value &&
        prov.sectionController.text == title) {
      return;
    }

    DialogBuilder.showLoadingIndicator();
    try {
      prov.sectionId = option.value;
      prov.sectionController.text = title;
      prov.subjectController.clear();
      prov.subjectId = 0;
      prov.selectedSubjectName = '';
      await prov.loadSubjects();
      if (prov.subjects.isNotEmpty) {
        final firstSubject = prov.subjects.first;
        prov.subjectId = firstSubject.value ?? 0;
        prov.selectedSubjectName = firstSubject.title ?? '';
        prov.subjectController.text = prov.selectedSubjectName;
        await prov.loadStudentsBySubject();
      } else {
        prov.classTestResultStudentResponse =
            ClassTestResultStudentListResponse(studentList: []);
        prov.totalMarks = 0;
      }
      if (mounted) setState(() {});
    } catch (e) {
      showSnackBar(e.toString());
    } finally {
      DialogBuilder.hideOpenDialog();
    }
  }

  Future<void> _onSubjectSelected(
    ClassTestResultProvider prov,
    Options option,
  ) async {
    final int nextId = option.value ?? 0;
    final String title = option.title ?? '';
    if (prov.subjectId == nextId && prov.subjectController.text == title) {
      return;
    }

    DialogBuilder.showLoadingIndicator();
    try {
      prov.subjectId = nextId;
      prov.selectedSubjectName = title;
      prov.subjectController.text = title;
      await prov.loadStudentsBySubject();
      if (mounted) setState(() {});
    } catch (e) {
      showSnackBar(e.toString());
    } finally {
      DialogBuilder.hideOpenDialog();
    }
  }

  Future<void> _switchTestTab(
    ClassTestResultProvider prov,
    int categoryId,
  ) async {
    if (prov.categoryId == categoryId) return;
    prov.categoryId = categoryId;
    if (prov.subjectId == 0) {
      setState(() {});
      return;
    }

    DialogBuilder.showLoadingIndicator();
    try {
      await prov.loadStudentsBySubject();
      if (mounted) setState(() {});
    } catch (e) {
      showSnackBar(e.toString());
    } finally {
      DialogBuilder.hideOpenDialog();
    }
  }

  void _openSearchablePicker({
    required BuildContext context,
    required String title,
    required List<Options> options,
    required String selectedTitle,
    required ValueChanged<Options> onSelect,
  }) {
    if (options.isEmpty) return;
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
                            Text(
                              '${options.length} ${options.length == 1 ? 'option' : 'options'}',
                              style: AppThemes.roboto(
                                fontSize: 12,
                                color: AppColors.muted,
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
                                    'Nothing matches "$query"',
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

  Widget _buildContextPill({
    required String label,
    required String valueText,
    required VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: AppThemes.roboto(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.6,
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      valueText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppThemes.sora(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    provider.clearData();
    provider.clearLibraryData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: Column(
        children: [
          // T8 Blue Header (Title + SECTION/SUBJECT pills + Test 1/2/3 segmented bar)
          Consumer<ClassTestResultProvider>(
            builder: (context, prov, _) {
              final String sectionText = prov.sectionController.text.isNotEmpty
                  ? prov.sectionController.text
                  : 'Select section';
              final String subjectText = prov.subjectController.text.isNotEmpty
                  ? prov.subjectController.text
                  : 'Select subject';

              return Container(
                width: double.infinity,
                color: AppColors.blue,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      // Top Bar
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
                              'Class test marks',
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

                      // Context Pickers (1.35fr : 1fr)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 135,
                              child: _buildContextPill(
                                label: 'SECTION',
                                valueText: sectionText,
                                onTap: prov.sections.isNotEmpty
                                    ? () => _openSearchablePicker(
                                          context: context,
                                          title: 'Choose section',
                                          options: prov.sections,
                                          selectedTitle:
                                              prov.sectionController.text,
                                          onSelect: (opt) =>
                                              _onSectionSelected(prov, opt),
                                        )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              flex: 100,
                              child: _buildContextPill(
                                label: 'SUBJECT',
                                valueText: subjectText,
                                onTap: prov.subjects.isNotEmpty
                                    ? () => _openSearchablePicker(
                                          context: context,
                                          title: 'Choose subject',
                                          options: prov.subjects,
                                          selectedTitle:
                                              prov.subjectController.text,
                                          onSelect: (opt) =>
                                              _onSubjectSelected(prov, opt),
                                        )
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Test 1 | Test 2 | Test 3 Segmented Selector
                      Container(
                        margin: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.13),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            for (int cat = 1; cat <= 3; cat++)
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _switchTestTab(prov, cat),
                                  child: Container(
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: prov.categoryId == cat
                                          ? Colors.white
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Test $cat',
                                      style: AppThemes.sora(
                                        fontSize: 13,
                                        fontWeight: prov.categoryId == cat
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        color: prov.categoryId == cat
                                            ? AppColors.blue
                                            : Colors.white
                                                .withValues(alpha: 0.9),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Body
          Expanded(
            child: FutureBuilder<ClassTestResultStudentListResponse>(
              future: _initFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CustomLoader());
                  default:
                    if (snapshot.hasData) {
                      return const TeacherAddClassResultComponent();
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
