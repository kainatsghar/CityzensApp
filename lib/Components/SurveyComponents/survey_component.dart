import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';

import '../../custom_widgets/CustomAppButton/custom_app_button.dart';
import '../../custom_widgets/CustomCoverImage/custom_cover_image.dart';
import '../../custom_widgets/ShowCustomMessage/show_survey_message.dart';
import '../../Provider/Survey/survey_provider.dart';
import '../../Utils/app_constants.dart';

class SurveyComponent extends StatelessWidget {
  const SurveyComponent({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Consumer<SurveyProvider>(
      builder: (context, value, _) {
        var responseData = value.surveyResponse;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child:
                responseData == null || responseData.surveyCategoryList!.isEmpty
                ? const ShowSurveyMessage(message: AppConstants.noRecordFound)
                : Form(
                    key: value.formKey,
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              responseData.surveyCategoryList?.length ?? 0,
                          itemBuilder: (_, categoryIndex) {
                            var category =
                                responseData.surveyCategoryList![categoryIndex];
                            return Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      category.surveyCatName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                                const CustomCoverImage(
                                  title: 'SURVEY',
                                  imagePath: 'survey.png',
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: size.height * 0.01),
                                      ListView.builder(
                                        physics: const ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            category.questionCategories.length,
                                        itemBuilder: (_, questionCategoryIndex) {
                                          var questionCategory = category
                                              .questionCategories[questionCategoryIndex];
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                                child: SizedBox(
                                                  height: size.height * 0.035,
                                                  child: Card(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            0,
                                                          ),
                                                    ),
                                                    elevation: 2,
                                                    color: const Color.fromARGB(
                                                      255,
                                                      227,
                                                      165,
                                                      236,
                                                    ),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        questionCategory
                                                                .questionCategory ??
                                                            '',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Divider(
                                                  color: AppColors.primaryColor,
                                                  height: 20,
                                                  thickness: 4,
                                                  indent: size.width * 0.1,
                                                  endIndent: size.width * 0.1,
                                                ),
                                              ),
                                              SizedBox(
                                                height: size.height * 0.02,
                                              ),
                                              ListView.builder(
                                                physics:
                                                    const ClampingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    questionCategory
                                                        .questionList
                                                        ?.length ??
                                                    0,
                                                itemBuilder: (_, questionIndex) {
                                                  var question = questionCategory
                                                      .questionList![questionIndex];
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          question.question ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14,
                                                              ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                      Stack(
                                                        children: [
                                                          Divider(
                                                            color: AppColors
                                                                .primaryColor,
                                                            height: 20,
                                                            thickness: 4,
                                                            indent:
                                                                size.width *
                                                                0.1,
                                                            endIndent:
                                                                size.width *
                                                                0.1,
                                                          ),
                                                          Stack(
                                                            children: [
                                                              Divider(
                                                                color: AppColors
                                                                    .primaryColor,
                                                                height: 20,
                                                                thickness: 4,
                                                                indent:
                                                                    size.width *
                                                                    0.1,
                                                                endIndent:
                                                                    size.width *
                                                                    0.1,
                                                              ),
                                                              const Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_drop_down_sharp,
                                                                  size: 32,
                                                                  color: AppColors
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      question.answerCategoryList!
                                                              .every(
                                                                (ac) =>
                                                                    ac
                                                                        .answerList!
                                                                        .length ==
                                                                    1,
                                                              )
                                                          ? SizedBox(
                                                              height:
                                                                  size.height *
                                                                  0.05,
                                                              child: TextFormField(
                                                                decoration: InputDecoration(
                                                                  contentPadding:
                                                                      const EdgeInsets.only(
                                                                        left:
                                                                            10,
                                                                      ),
                                                                  labelText:
                                                                      'Enter your answer',
                                                                  border: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          8.0,
                                                                        ),
                                                                    borderSide:
                                                                        const BorderSide(
                                                                          color:
                                                                              AppColors.whiteColor,
                                                                        ),
                                                                  ),
                                                                ),
                                                                onTapOutside:
                                                                    (
                                                                      event,
                                                                    ) => FocusScope.of(
                                                                      context,
                                                                    ).unfocus(),
                                                                onChanged: (values) {
                                                                  value.updateSelectedAnswer(
                                                                    question
                                                                        .questionId,
                                                                    null,
                                                                    values,
                                                                  );
                                                                },
                                                              ),
                                                            )
                                                          : Column(
                                                              children:
                                                                  question
                                                                      .answerCategoryList
                                                                      ?.expand(
                                                                        (
                                                                          answerCategory,
                                                                        ) =>
                                                                            answerCategory.answerList?.map<
                                                                              Widget
                                                                            >((
                                                                              answer,
                                                                            ) {
                                                                              int
                                                                              trendIndex;
                                                                              bool
                                                                              isChanged = false;
                                                                              if (value.surveyAnswers.isNotEmpty) {
                                                                                trendIndex = value.surveyAnswers.indexWhere(
                                                                                  (
                                                                                    f,
                                                                                  ) =>
                                                                                      f.questionId ==
                                                                                          question.questionId &&
                                                                                      f.answerId ==
                                                                                          answer.answerId,
                                                                                );

                                                                                if (trendIndex !=
                                                                                    -1) {
                                                                                  isChanged = true;
                                                                                }
                                                                              }

                                                                              return SizedBox(
                                                                                height:
                                                                                    size.height *
                                                                                    0.035,
                                                                                child: GestureDetector(
                                                                                  onTap: () {
                                                                                    value.updateSelectedAnswer(
                                                                                      question.questionId,
                                                                                      answer.answerId,
                                                                                      null,
                                                                                    );
                                                                                  },
                                                                                  child: Card(
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(
                                                                                        0,
                                                                                      ),
                                                                                    ),
                                                                                    elevation: 2,
                                                                                    color: isChanged
                                                                                        ? AppColors.primaryDarkColor
                                                                                        : AppColors.secondaryColor,
                                                                                    child: Align(
                                                                                      alignment: Alignment.center,
                                                                                      child: Text(
                                                                                        answer.answer ??
                                                                                            '',
                                                                                        style: TextStyle(
                                                                                          fontSize: 14,
                                                                                          color: isChanged
                                                                                              ? AppColors.whiteColor
                                                                                              : AppColors.blackColor,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            }) ??
                                                                            const Iterable.empty(),
                                                                      )
                                                                      .map<
                                                                        Widget
                                                                      >(
                                                                        (e) =>
                                                                            e,
                                                                      )
                                                                      .toList() ??
                                                                  [],
                                                            ),
                                                      SizedBox(
                                                        height:
                                                            size.height * 0.02,
                                                      ),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomAppButton(
                            buttonTitle: 'SAVE',
                            onTap: () => {value.saveSurveyAnswers()},
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
