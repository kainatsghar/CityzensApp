class SurveyResponse {
  List<SurveyCategoryDTO>? surveyCategoryList;
  bool? isSuccessful;
  String? message;
  bool? isServerException;

  SurveyResponse(
      {this.surveyCategoryList,
      this.isSuccessful,
      this.message,
      this.isServerException});

  factory SurveyResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic>? surveyJson = json['Data'];
    List<SurveyCategoryDTO> surveyList = surveyJson != null
        ? surveyJson.map((e) => SurveyCategoryDTO.fromJson(e)).toList()
        : [];

    return SurveyResponse(
      surveyCategoryList: surveyList,
    );
  }
}

class SurveyCategoryDTO {
  final int surveyCategoryId;
  final String surveyCatName;
  final List<QuestionCategoryDTO> questionCategories;

  SurveyCategoryDTO({
    required this.surveyCategoryId,
    required this.surveyCatName,
    required this.questionCategories,
  });

  factory SurveyCategoryDTO.fromJson(Map<String, dynamic> json) {
    var questionCategoriesFromJson = json['QuestionCategories'] as List;
    List<QuestionCategoryDTO> questionCategoriesList =
        questionCategoriesFromJson
            .map((e) => QuestionCategoryDTO.fromJson(e))
            .toList();

    return SurveyCategoryDTO(
      surveyCategoryId: json['SurveyCategoryId'],
      surveyCatName: json['SurveyCatName'],
      questionCategories: questionCategoriesList,
    );
  }
}

class QuestionCategoryDTO {
  int? questionCategoryId;
  String? questionCategory;
  List<QuestionDTO>? questionList;

  QuestionCategoryDTO(
      {this.questionCategoryId, this.questionCategory, this.questionList});

  factory QuestionCategoryDTO.fromJson(Map<String, dynamic> json) {
    List<dynamic>? questionCategoriesJson = json['Questions'];
    List<QuestionDTO> questionCategories = questionCategoriesJson != null
        ? questionCategoriesJson.map((e) => QuestionDTO.fromJson(e)).toList()
        : [];

    return QuestionCategoryDTO(
      questionCategoryId: json['QuestionCategoryId'],
      questionCategory: json['QuestionCategory'],
      questionList: questionCategories,
    );
  }
}

class QuestionDTO {
  int? questionId;
  String? question;
  List<AnswerCategoryDTO>? answerCategoryList;

  QuestionDTO({this.questionId, this.question, this.answerCategoryList});

  factory QuestionDTO.fromJson(Map<String, dynamic> json) {
    List<dynamic>? answerCategoriesJson = json['AnswersCategories'];
    List<AnswerCategoryDTO> answerCategories = answerCategoriesJson != null
        ? answerCategoriesJson
            .map((e) => AnswerCategoryDTO.fromJson(e))
            .toList()
        : [];

    return QuestionDTO(
      questionId: json['QuestionId'],
      question: json['Question'],
      answerCategoryList: answerCategories,
    );
  }
}

class AnswerCategoryDTO {
  int? answerCategoryId;
  String? categoryName;
  List<AnswerDTO>? answerList;

  AnswerCategoryDTO(
      {this.answerCategoryId, this.categoryName, this.answerList});

  factory AnswerCategoryDTO.fromJson(Map<String, dynamic> json) {
    List<dynamic>? answersJson = json['Answers'];
    List<AnswerDTO> answers = answersJson != null
        ? answersJson.map((e) => AnswerDTO.fromJson(e)).toList()
        : [];

    return AnswerCategoryDTO(
      answerCategoryId: json['AnswerCategoryId'],
      categoryName: json['CategoryName'],
      answerList: answers,
    );
  }
}

class AnswerDTO {
  int? answerId;
  String? answer;

  AnswerDTO({this.answerId, this.answer});

  factory AnswerDTO.fromJson(Map<String, dynamic> json) {
    return AnswerDTO(
      answerId: json['AnswerId'],
      answer: json['Answer'],
    );
  }
}
