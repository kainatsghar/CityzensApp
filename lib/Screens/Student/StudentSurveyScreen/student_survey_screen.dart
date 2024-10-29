import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Components/SurveyComponents/survey_component.dart';
import '../../../CustomWidgets/CustomAppbar/custom_appbar.dart';
import '../../../CustomWidgets/CustomLoader/custom_loader.dart';
import '../../../CustomWidgets/ShowError/show_error.dart';
import '../../../Provider/Survey/survey_provider.dart';
import '../../../Routes/app_navigation.dart';

class StudentSurveyScreen extends StatefulWidget {
  const StudentSurveyScreen({super.key});

  @override
  State<StudentSurveyScreen> createState() => _StudentSurveyScreenState();
}

class _StudentSurveyScreenState extends State<StudentSurveyScreen> {
  late Future surveyQuestionRecords;
  var provider =
      Provider.of<SurveyProvider>(AppNavigation.currentContext!, listen: false);

  @override
  void initState() {
    surveyQuestionRecords = provider.loadSurvey();

    super.initState();
  }

  @override
  void dispose() {
    provider.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'SURVEY'),
      body: FutureBuilder(
          future: surveyQuestionRecords,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CustomLoader();
              default:
                if (snapshot.hasData) {
                  return const SurveyComponent();
                } else {
                  return ShowError(errorText: '${snapshot.error}');
                }
            }
          }),
    );
  }
}
