import 'package:flutter/material.dart';
import 'package:tcs_app/CustomWidgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/model/Results/results_response.dart';

class ResultCardInfo extends StatelessWidget {
  final StudentInfo stdInfo;
  final String session;
  final String term;

  const ResultCardInfo({Key key, this.stdInfo, this.term, this.session})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      child: Container(
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.all(5.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 2.0),
              child: Text('${stdInfo.name}',
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0)),
            ),
            SizedBox(
                height: size.width * 0.25,
                width: size.width * 0.25,
                child: CustomUserImage(userId: '${stdInfo.rollNo}')),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 6.0),
              child: Text('${stdInfo.centerName}',
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(
                    width: size.width / 7.5,
                    child: Text('Region: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 11))),
                SizedBox(
                    width: size.width / 2.5,
                    child: Text('${stdInfo.regionName}',
                        style: TextStyle(color: Colors.black54, fontSize: 11))),
                SizedBox(
                    width: size.width / 7.5,
                    child: Text('Roll No: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 11))),
                SizedBox(
                    width: size.width / 4.2,
                    child: Text(
                      '${stdInfo.rollNo}',
                      style: TextStyle(color: Colors.black54, fontSize: 11),
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: size.width / 7.5,
                      child: Text(
                        'Class: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 11),
                      ),
                    ),
                    SizedBox(
                      width: size.width / 2.5,
                      child: Text(
                        '${stdInfo.className}',
                        style: TextStyle(color: Colors.black54, fontSize: 11),
                      ),
                    ),
                    SizedBox(
                        width: size.width / 7.5,
                        child: Text('Section: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 11))),
                    SizedBox(
                        width: size.width / 4.2,
                        child: Text('${stdInfo.section}',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 11)))
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: size.width / 7.5,
                      child: Text(
                        'Session: ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 11),
                      ),
                    ),
                    SizedBox(
                      width: size.width / 2.5,
                      child: Text(
                        '$session',
                        style: TextStyle(color: Colors.black54, fontSize: 11),
                      ),
                    ),
                    SizedBox(
                        width: size.width / 7.5,
                        child: Text('Term: ',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 11))),
                    SizedBox(
                        width: size.width / 4.2,
                        child: Text('$term',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 11)))
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
