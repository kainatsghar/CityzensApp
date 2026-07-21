import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/utils/app_colors.dart';

import '../../../components/DiaryRecordComponents/diary_record_component.dart';
import '../../../custom_widgets/CustomLoader/custom_loader.dart';
import '../../../custom_widgets/ShowError/show_error.dart';
import '../../../provider/Diary/diary_provider.dart';
import '../../../routes/app_navigation.dart';

class TeacherDiaryScreen extends StatefulWidget {
  const TeacherDiaryScreen({super.key});

  @override
  State<TeacherDiaryScreen> createState() => _TeacherDiaryScreenState();
}

class _TeacherDiaryScreenState extends State<TeacherDiaryScreen> {
  late Future _diaryRecords;
  var provider = Provider.of<DiaryProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    _diaryRecords = provider.loadTeacherDiary();
    super.initState();
  }

  @override
  void dispose() {
    provider.clearLibraryData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ultraLightGrey,
      appBar: const CustomAppBar(title: 'HOMEWORK DIARY'),
      body: FutureBuilder(
        future: _diaryRecords,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CustomLoader();
            default:
              if (snapshot.hasData) {
                return const DiaryRecordComponent();
              } else {
                return ShowError(errorText: '${snapshot.error}');
              }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppNavigation.navigateTo(AppNavRoutes.addDiaryRoute),
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
