import 'package:flutter/material.dart';
import 'package:tcs_app/CustomWidgets/CustomUserImage/custom_user_image.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class CustomStudentInfo extends StatelessWidget {
  final dynamic info;

  const CustomStudentInfo({Key key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
        child: Container(
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.all(5.0),
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 5.0),
                child: Text(info.name,
                    style: TextStyle(
                        color: AppColors.primaryTitleColor,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                  height: size.width * 0.25,
                  width: size.width * 0.25,
                  margin: EdgeInsets.only(bottom: 5.0),
                  child: CustomUserImage(userId: '${info.rollNo}')),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: size.width * 0.43,
                    child: Column(
                      children: [
                        Text('BRANCH',
                            style: TextStyle(
                                color: AppColors.primaryTitleColor,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 2.0),
                        Text(info.centerName,
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
                          '${info.rollNo}',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: size.width * 0.43,
                        child: Column(
                          children: [
                            Text(
                              'REGION',
                              style: TextStyle(
                                  color: AppColors.primaryTitleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                            SizedBox(height: 2.0),
                            Text(
                              info.regionName,
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 12),
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
                            Text('CLASS',
                                style: TextStyle(
                                    color: AppColors.primaryTitleColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                            SizedBox(height: 2),
                            Text(info.className,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12)),
                          ],
                        ),
                      )
                    ]),
              )
            ])));
  }
}
