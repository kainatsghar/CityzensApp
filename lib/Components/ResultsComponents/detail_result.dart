import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomPercentageBar/custom_percentage_bar.dart';
import 'package:tcs_app/Provider/Results/results_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/helper_function.dart';

class DetailResult extends StatelessWidget {
  final int index;

  const DetailResult({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<ResultsProvider>(builder: (context, value, _) {
      var detail = value.resultsResponse.listDetail[index];
      var info = value.resultsResponse.info;
      return Card(
          child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        width: size.width / 3.0,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(detail.subject,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center),
                              Padding(padding: EdgeInsets.all(5.0)),
                              ClipOval(
                                child: Container(
                                    height: size.width / 5.4,
                                    width: size.width / 5.4,
                                    color: AppColors.primaryColor,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Grade',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            detail.grade,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          )
                                        ])),
                              )
                            ])),
                    SizedBox(
                        width: size.width / 1.75,
                        child: Column(children: <Widget>[
                          SizedBox(height: 20.0),
                          info.term == 1
                              ? SizedBox.shrink()
                              : Row(children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(left: 4.0),
                                    width: size.width / 4.7,
                                    child: Text('Mid Year',
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
                                          style: TextStyle(fontSize: 11)))
                                ]),
                          SizedBox(height: 8.0),
                          Row(children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 4.0),
                              width: size.width / 4.7,
                              child: Text('Coursework',
                                  style: TextStyle(fontSize: 11)),
                            ),
                            SizedBox(
                              width: size.width / 4.6,
                              child: CustomPercentageBar(
                                  barHeight: 4.0,
                                  barValue: HelperFunction.numberValue(
                                      detail.courseWork),
                                  barWidth: size.width / 4.6),
                            ),
                            SizedBox(
                                width: size.width / 10.0,
                                child: Text(
                                    HelperFunction.numberValue(
                                        detail.courseWork),
                                    style: TextStyle(fontSize: 11)))
                          ]),
                          SizedBox(height: 8.0),
                          Row(children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 4.0),
                              width: size.width / 4.7,
                              child:
                                  Text('Exam', style: TextStyle(fontSize: 11)),
                            ),
                            SizedBox(
                              width: size.width / 4.6,
                              child: CustomPercentageBar(
                                  barHeight: 4.0,
                                  barValue: HelperFunction.numberValue(
                                      detail.theoryExam),
                                  barWidth: size.width / 4.6),
                            ),
                            SizedBox(
                                width: size.width / 10.0,
                                child: Text(
                                    HelperFunction.numberValue(
                                        detail.theoryExam),
                                    style: TextStyle(fontSize: 11)))
                          ]),
                          Visibility(
                              visible:
                                  value.selectAcademicYear >= 11 ? false : true,
                              child: Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Row(children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.only(left: 4.0),
                                      width: size.width / 4.7,
                                      child: Text('Average',
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
                                            style: TextStyle(fontSize: 11)))
                                  ]))),
                          SizedBox(height: 8.0),
                        ]))
                  ])));
    });
  }
}
