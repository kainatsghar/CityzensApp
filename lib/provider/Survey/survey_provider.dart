import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../custom_widgets/CustomDialogBoxes/loading_dialog_box.dart';

import '../../custom_widgets/CustomSnackbar/custom_snackbar.dart';
import '../../model/AddSurvey/add_survey_request.dart';
import '../../model/Survey/survey_response.dart';
import '../../services/AddSurveyAnswer/add_survey_answer_service.dart';
import '../../services/Survey/survey_service.dart';
import '../../routes/app_navigation.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../model/ResponseMessage/response_message.dart';
import '../LocalData/local_data_provider.dart';

class SurveyProvider with ChangeNotifier {
  SurveyResponse? surveyResponse;
  late final formKey = GlobalKey<FormState>();

  List<SurveyQuestionAnswerDto> surveyAnswers = [];

  LocalDataProvider localDataProvider = Provider.of<LocalDataProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  void setSurveyRecords(SurveyResponse response) {
    surveyResponse = response;
    notifyListeners();
  }

  void updateSelectedAnswer(
    int? questionId,
    int? answerId,
    String? answerString,
  ) {
    final existingAnswer = surveyAnswers.firstWhere(
      (answer) => answer.questionId == questionId,
      orElse: () => SurveyQuestionAnswerDto(),
    );

    if (existingAnswer.questionId == questionId) {
      existingAnswer.answerId = answerId;
      existingAnswer.answer = answerString;
    } else {
      surveyAnswers.add(
        SurveyQuestionAnswerDto(
          userId: localDataProvider.userData!.userName ?? '',
          userType: localDataProvider.userData!.userType ?? '',
          questionId: questionId,
          answerId: answerId,
          answer: answerString,
          createdBy: localDataProvider.userData!.userName ?? '',
        ),
      );
    }
    notifyListeners();
  }

  Future<void> saveSurveyAnswers() async {
    DialogBuilder.showLoadingIndicator();
    try {
      if (formKey.currentState!.validate()) {
        FocusScope.of(AppNavigation.currentContext!).requestFocus(FocusNode());

        AddSurveyAnswersRequest request = AddSurveyAnswersRequest();

        if (surveyAnswers.isEmpty) {
          showSnackBar("Please answer the questions and submit!");
        } else {
          request.surveyQuestionAnswerLists = surveyAnswers;

          ResponseMessage response =
              await AddSurveyAnswerService.addSurveyAnswers(request);

          if (response.isSuccess!) {
            await loadSurvey();
            Future.delayed(
              const Duration(seconds: 1),
              () => AppNavigation.goBack(),
            );
            showSnackBar(
              'Survey Answer Added Successfully',
              color: AppColors.successGreenColor,
            );
          } else {
            showSnackBar(response.message);
          }
        }
      }
    } catch (ex) {
      showSnackBar(AppConstants.exceptionMessage);
    } finally {
      DialogBuilder.hideOpenDialog();
    }
  }

  Future<SurveyResponse> loadSurvey() async {
    try {
      String? userId = localDataProvider.userData!.userType == 'Student'
          ? localDataProvider.studentId.toString()
          : localDataProvider.userData!.userType == 'Parent'
          ? localDataProvider.userData!.userName.toString()
          : localDataProvider.userData!.userName ?? '';

      SurveyResponse response = await SurveyService.getSurveyRecords(
        userId: userId,
      );
      setSurveyRecords(response);
      return response;
    } catch (ex) {
      rethrow;
    }
  }

  /// Clears only survey answer state. Call in initState() of survey screens.
  /// Does NOT clear surveyResponse (survey questions data).
  void clearFormState() {
    surveyAnswers = [];
  }

  void clearData() {
    surveyAnswers = [];
  }
}
