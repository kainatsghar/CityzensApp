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
                      color: AppColors.primaryTitleColor,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
                height: size.width * 0.25,
                width: size.width * 0.25,
                child: CustomUserImage(userId: '${stdInfo.rollNo}')),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 8.0),
              child: Text('${stdInfo.centerName}',
                  style: TextStyle(
                      color: AppColors.primaryTitleColor,
                      fontWeight: FontWeight.bold)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: size.width * 0.43,
                  child: Column(
                    children: [
                      Text('REGION',
                          style: TextStyle(
                              color: AppColors.primaryTitleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                      SizedBox(height: 2.0),
                      Text('${stdInfo.regionName}',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 12)),
                    ],
                  ),
                ),
                SizedBox(
                    height: 30,
                    child: VerticalDivider(
                        width: 15.0,
                        color: AppColors.blackColor,
                        thickness: 1)),
                SizedBox(
                  width: size.width * 0.43,
                  child: Column(
                    children: [
                      Text('ROLL NUMBER',
                          style: TextStyle(
                              color: AppColors.primaryTitleColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                      SizedBox(height: 2.0),
                      Text(
                        '${stdInfo.rollNo}',
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: size.width * 0.43,
                      child: Column(
                        children: [
                          Text(
                            'CLASS',
                            style: TextStyle(
                                color: AppColors.primaryTitleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                          SizedBox(height: 2.0),
                          Text(
                            '${stdInfo.className}',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: 30,
                        child: VerticalDivider(
                            width: 15.0,
                            color: AppColors.blackColor,
                            thickness: 1)),
                    SizedBox(
                      width: size.width * 0.43,
                      child: Column(
                        children: [
                          Text('SECTION',
                              style: TextStyle(
                                  color: AppColors.primaryTitleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                          SizedBox(height: 2.0),
                          Text('${stdInfo.section}',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 12)),
                        ],
                      ),
                    )
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: size.width * 0.43,
                      child: Column(
                        children: [
                          Text(
                            'SESSION',
                            style: TextStyle(
                                color: AppColors.primaryTitleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                          SizedBox(height: 2.0),
                          Text(
                            '$session',
                            style:
                                TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: 30,
                        child: VerticalDivider(
                            width: 15.0,
                            color: AppColors.blackColor,
                            thickness: 1)),
                    SizedBox(
                      width: size.width * 0.43,
                      child: Column(
                        children: [
                          Text('TERM',
                              style: TextStyle(
                                  color: AppColors.primaryTitleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                          SizedBox(height: 2.0),
                          Text('$term',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 12)),
                        ],
                      ),
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
