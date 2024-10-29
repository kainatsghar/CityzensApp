import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomPercentageBar/custom_percentage_bar.dart';
import 'package:tcs_app/Provider/Results/results_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/helper_function.dart';

import '../../CustomWidgets/CustomSubjectGrade/custom_subject_grade.dart';

class OverallResult extends StatelessWidget {
  const OverallResult({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<ResultsProvider>(builder: (context, value, _) {
      var info = value.resultsResponse.info;
      return Column(
        children: [
          Card(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(15.0)),
              child: Column(children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: size.width / 3.4,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15.0),
                                  bottomLeft: Radius.circular(15.0)),
                              color: AppColors.secondaryColor),
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const Text('Overall Grade',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center),
                                Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: size.width / 5.4,
                                        width: size.width / 5.4,
                                        child: CustomSubjectGrade(
                                            grade: info!.overallGrade!)))
                              ])),
                      SizedBox(
                          width: size.width / 1.6,
                          child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                          width: size.width / 3.6,
                                          child: const Text('Overall %',
                                              style: TextStyle(fontSize: 11))),
                                      SizedBox(
                                        width: size.width / 4.6,
                                        child: CustomPercentageBar(
                                            barHeight: 4.0,
                                            barValue:
                                                HelperFunction.numberValue(
                                                    info.overallPercentage),
                                            barWidth: size.width / 4.6),
                                      ),
                                      SizedBox(
                                          width: size.width / 10.0,
                                          child: Text(
                                              HelperFunction.numberValue(
                                                  info.overallPercentage),
                                              style: const TextStyle(
                                                  fontSize: 11)))
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                        width: size.width / 3.6,
                                        child: const Text('Class Highest %',
                                            style: TextStyle(fontSize: 11))),
                                    SizedBox(
                                      width: size.width / 4.6,
                                      child: CustomPercentageBar(
                                          barHeight: 4.0,
                                          barValue: HelperFunction.numberValue(
                                              info.highestPercentage),
                                          barWidth: size.width / 4.6),
                                    ),
                                    SizedBox(
                                        width: size.width / 10.0,
                                        child: Text(
                                            HelperFunction.numberValue(
                                                info.highestPercentage),
                                            style:
                                                const TextStyle(fontSize: 11)))
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Row(
                                  children: <Widget>[
                                    SizedBox(
                                        width: size.width / 3.6,
                                        child: const Text('Class Lowest %',
                                            style: TextStyle(fontSize: 11))),
                                    SizedBox(
                                      width: size.width / 4.6,
                                      child: CustomPercentageBar(
                                          barHeight: 4.0,
                                          barValue: HelperFunction.numberValue(
                                              info.lowestPercentage),
                                          barWidth: size.width / 4.6),
                                    ),
                                    SizedBox(
                                        width: size.width / 10.0,
                                        child: Text(
                                            HelperFunction.numberValue(
                                                info.lowestPercentage),
                                            style:
                                                const TextStyle(fontSize: 11)))
                                  ],
                                ),
                                const SizedBox(height: 8.0),
                                Row(children: <Widget>[
                                  SizedBox(
                                      width: size.width / 3.6,
                                      child: const Text('Class Average %',
                                          style: TextStyle(fontSize: 11))),
                                  SizedBox(
                                    width: size.width / 4.6,
                                    child: CustomPercentageBar(
                                        barHeight: 4.0,
                                        barValue: HelperFunction.numberValue(
                                            info.average),
                                        barWidth: size.width / 4.6),
                                  ),
                                  SizedBox(
                                      width: size.width / 10.0,
                                      child: Text(
                                          HelperFunction.numberValue(
                                              info.average),
                                          style:
                                              const TextStyle(fontSize: 11))),
                                  const SizedBox(height: 8.0)
                                ])
                              ])))
                    ]),
              ])),
          const SizedBox(height: 5.0),
          Card(
            shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(15.0)),
            child: Container(
              width: size.width,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Visibility(
                      visible: info.teacherComment!.isEmpty ? false : true,
                      child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(children: <Widget>[
                            const Text(
                              "Teacher's Remarks: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(info.teacherComment!,
                                    textAlign: TextAlign.center))
                          ]))),
                  Visibility(
                      visible: info.term == 1 ? false : true,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Column(children: <Widget>[
                            const Text(
                              'Promoted To: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(info.promotedTo!),
                            )
                          ]))),
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}
