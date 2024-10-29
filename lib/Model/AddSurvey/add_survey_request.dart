class AddSurveyAnswersRequest {
  List<SurveyQuestionAnswerDto>? surveyQuestionAnswerLists;

  AddSurveyAnswersRequest({
    this.surveyQuestionAnswerLists,
  });

  AddSurveyAnswersRequest.fromJson(Map<String, dynamic> json) {
    if (json['SurveyQuestionAnswerDtos'] != null) {
      surveyQuestionAnswerLists = <SurveyQuestionAnswerDto>[];
      json['SurveyQuestionAnswerDtos'].forEach((v) {
        surveyQuestionAnswerLists!.add(SurveyQuestionAnswerDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['SurveyQuestionAnswerDtos'] =
        surveyQuestionAnswerLists?.map((v) => v.toJson()).toList();
    return data;
  }
}

class SurveyQuestionAnswerDto {
  String? userId;
  String? userType;
  int? questionId;
  int? answerId;
  String? createdBy;
  String? answer;

  SurveyQuestionAnswerDto(
      {this.userId,
      this.userType,
      this.questionId,
      this.answerId,
      this.createdBy,
      this.answer});

  SurveyQuestionAnswerDto.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    userType = json['UserType'];
    questionId = json['QuestionId'];
    answerId = json['AnswerId'];
    createdBy = json['CreatedBy'];
    answer = json['Answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UserId'] = userId;
    data['UserType'] = userType;
    data['QuestionId'] = questionId;
    data['AnswerId'] = answerId;
    data['CreatedBy'] = createdBy;
    data['Answer'] = answer;

    return data;
  }
}
