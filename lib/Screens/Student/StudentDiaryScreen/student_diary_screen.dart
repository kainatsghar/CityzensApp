import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';

import '../../../components/DiaryRecordComponents/diary_record_component.dart';
import '../../../custom_widgets/CustomLoader/custom_loader.dart';
import '../../../custom_widgets/ShowError/show_error.dart';
import '../../../provider/Diary/diary_provider.dart';
import '../../../routes/app_navigation.dart';
import '../../../services/FirebaseServices/app_analytics_service.dart';

class StudentDiaryScreen extends StatefulWidget {
  const StudentDiaryScreen({super.key});

  @override
  State<StudentDiaryScreen> createState() => _StudentDiaryScreenState();
}

class _StudentDiaryScreenState extends State<StudentDiaryScreen> {
  late Future _diaryRecords;
  var provider = Provider.of<DiaryProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    AppAnalyticsService.logFeatureAccess("Homework Diary");
    _diaryRecords = provider.loadStudentDiary();
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
    );
  }
}
