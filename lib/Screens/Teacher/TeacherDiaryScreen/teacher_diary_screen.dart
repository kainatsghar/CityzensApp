import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Utils/app_colors.dart';

import '../../../Components/DiaryRecordComponents/diary_record_component.dart';
import '../../../CustomWidgets/CustomLoader/custom_loader.dart';
import '../../../CustomWidgets/ShowError/show_error.dart';
import '../../../Provider/Diary/diary_provider.dart';
import '../../../Routes/app_navigation.dart';

class TeacherDiaryScreen extends StatefulWidget {
  const TeacherDiaryScreen({Key key}) : super(key: key);

  @override
  State<TeacherDiaryScreen> createState() => _TeacherDiaryScreenState();
}

class _TeacherDiaryScreenState extends State<TeacherDiaryScreen> {
  Future _diaryRecords;
  var provider =
      Provider.of<DiaryProvider>(AppNavigation.currentContext, listen: false);

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
      appBar: CustomAppBar(title: 'Diary Records'),
      body: FutureBuilder(
          future: _diaryRecords,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CustomLoader();
              default:
                if (snapshot.hasData) {
                  return DiaryRecordComponent();
                } else {
                  return ShowError(errorText: '${snapshot.error}');
                }
            }
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () => AppNavigation.navigateTo(AppNavRoutes.addDiaryRoute),
          backgroundColor: AppColors.primaryColor,
          child: Icon(Icons.add, color: AppColors.whiteColor)),
    );
  }
}
