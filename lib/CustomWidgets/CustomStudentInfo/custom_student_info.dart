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
              Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                      height: size.width * 0.25,
                      width: size.width * 0.25,
                      child: CustomUserImage(userId: '${info.rollNo}'))),
              Padding(
                padding: const EdgeInsets.only(top:4.0,bottom: 2.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(info.name,
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                      width: size.width / 7.5,
                      child: Text('Branch: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 11))),
                  SizedBox(
                      width: size.width / 2.5,
                      child: Text(info.centerName,
                          style:
                              TextStyle(color: Colors.black54, fontSize: 11))),
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
                        '${info.rollNo}',
                        style: TextStyle(color: Colors.black54, fontSize: 11),
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top:2.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: size.width / 7.5,
                        child: Text(
                          'Region: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 11),
                        ),
                      ),
                      SizedBox(
                        width: size.width / 2.5,
                        child: Text(
                          info.regionName,
                          style: TextStyle(color: Colors.black54, fontSize: 11),
                        ),
                      ),
                      SizedBox(
                          width: size.width / 7.5,
                          child: Text('Class: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11))),
                      SizedBox(
                          width: size.width / 4.2,
                          child: Text(info.className,
                              style:
                                  TextStyle(color: Colors.black54, fontSize: 11)))
                    ]),
              )
            ])));
  }
}
