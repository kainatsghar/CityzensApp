import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomPercentageBar/custom_percentage_bar.dart';
import 'package:tcs_app/Provider/Results/results_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/helper_function.dart';

import '../../CustomWidgets/CustomSubjectGrade/custom_subject_grade.dart';

class DetailResult extends StatelessWidget {
  final int index;

  const DetailResult({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<ResultsProvider>(builder: (context, value, _) {
      var detail = value.resultsResponse.listDetail![index];
      var info = value.resultsResponse.info;
      return Card(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15.0)),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: size.width / 3.0,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            bottomLeft: Radius.circular(15.0)),
                        color: AppColors.secondaryColor),
                    padding: const EdgeInsets.all(5.0),
                    child: Column(children: <Widget>[
                      Text(detail.subject!,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const RotatedBox(
                              quarterTurns: -1,
                              child: Text('GRADE',
                                  style: TextStyle(
                                      color: AppColors.primaryDarkColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ),
                            const SizedBox(width: 3.0),
                            SizedBox(
                                height: size.width / 5.4,
                                width: size.width / 5.4,
                                child:
                                    CustomSubjectGrade(grade: detail.grade!)),
                          ],
                        ),
                      )
                    ])),
                SizedBox(
                    width: size.width / 1.75,
                    child: Column(children: <Widget>[
                      const SizedBox(height: 20.0),
                      info!.term == 1
                          ? const SizedBox.shrink()
                          : Row(children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(left: 4.0),
                                width: size.width / 4.7,
                                child: const Text('Mid Year',
                                    style: TextStyle(fontSize: 11)),
                              ),
                              SizedBox(
                                width: size.width / 4.6,
                                child: CustomPercentageBar(
                                    barHeight: 4.0,
                                    barValue: HelperFunction.numberValue(
                                        detail.midYear),
                                    barWidth: size.width / 4.6),
                              ),
                              SizedBox(
                                  width: size.width / 10.0,
                                  child: Text(
                                      HelperFunction.numberValue(
                                          detail.midYear),
                                      style: const TextStyle(fontSize: 11)))
                            ]),
                      const SizedBox(height: 8.0),
                      Row(children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 4.0),
                          width: size.width / 4.7,
                          child: const Text('Coursework',
                              style: TextStyle(fontSize: 11)),
                        ),
                        SizedBox(
                          width: size.width / 4.6,
                          child: CustomPercentageBar(
                              barHeight: 4.0,
                              barValue:
                                  HelperFunction.numberValue(detail.courseWork),
                              barWidth: size.width / 4.6),
                        ),
                        SizedBox(
                            width: size.width / 10.0,
                            child: Text(
                                HelperFunction.numberValue(detail.courseWork),
                                style: const TextStyle(fontSize: 11)))
                      ]),
                      const SizedBox(height: 8.0),
                      Row(children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left: 4.0),
                          width: size.width / 4.7,
                          child: const Text('Exam',
                              style: TextStyle(fontSize: 11)),
                        ),
                        SizedBox(
                          width: size.width / 4.6,
                          child: CustomPercentageBar(
                              barHeight: 4.0,
                              barValue:
                                  HelperFunction.numberValue(detail.theoryExam),
                              barWidth: size.width / 4.6),
                        ),
                        SizedBox(
                            width: size.width / 10.0,
                            child: Text(
                                HelperFunction.numberValue(detail.theoryExam),
                                style: const TextStyle(fontSize: 11)))
                      ]),
                      Visibility(
                          visible:
                              value.selectAcademicYear >= 11 ? false : true,
                          child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  width: size.width / 4.7,
                                  child: const Text('Average',
                                      style: TextStyle(fontSize: 11)),
                                ),
                                SizedBox(
                                  width: size.width / 4.6,
                                  child: CustomPercentageBar(
                                      barHeight: 4.0,
                                      barValue: HelperFunction.numberValue(
                                          detail.marks),
                                      barWidth: size.width / 4.6),
                                ),
                                SizedBox(
                                    width: size.width / 10.0,
                                    child: Text(
                                        HelperFunction.numberValue(
                                            detail.marks),
                                        style: const TextStyle(fontSize: 11)))
                              ]))),
                      const SizedBox(height: 8.0),
                    ]))
              ]));
    });
  }
}
