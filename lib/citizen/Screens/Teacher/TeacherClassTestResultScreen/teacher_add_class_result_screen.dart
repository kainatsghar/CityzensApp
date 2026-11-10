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
import 'package:tcs_app/citizen/Provider/ClassTestResult/class_test_result_provider.dart';

class TeacherAddClassResultScreen extends StatefulWidget {
  const TeacherAddClassResultScreen({super.key});

  @override
  State<TeacherAddClassResultScreen> createState() =>
      _TeacherAddClassResultScreenState();
}

class _TeacherAddClassResultScreenState
    extends State<TeacherAddClassResultScreen> {
  late Future studentRecords;

  ClassTestResultProvider get provider =>
      Provider.of<ClassTestResultProvider>(AppNavigation.currentContext!,
          listen: false);

  @override
  void initState() {
    provider.categoryId = 1;
    studentRecords = provider.loadStudentsBySubject();
    super.initState();
  }

  @override
  void dispose() {
    provider.clearLibraryData();
    super.dispose();
  }

  Future<void> _switchTestTab(
    ClassTestResultProvider prov,
    int categoryId,
  ) async {
    if (prov.categoryId == categoryId) return;
    prov.categoryId = categoryId;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: Column(
        children: [
          Consumer<ClassTestResultProvider>(
            builder: (context, prov, _) {
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
                      Container(
                        margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
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
          Expanded(
            child: FutureBuilder(
              future: studentRecords,
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
