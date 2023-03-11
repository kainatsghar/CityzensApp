import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/Provider/Dashboard/dashboard_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class AppFeedbackScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AppFeedbackScreenState();
  }
}

class AppFeedbackScreenState extends State<AppFeedbackScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: CustomAppBar(title: 'App Feedback'),
        body: Container(
            margin: EdgeInsets.only(top: 15.0),
            child: Column(children: <Widget>[
              Image.asset('images/logo_horizontal.png',
                  width: size.width / 2, height: size.height / 7),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(children: <Widget>[
                    Text(
                      'Please share any issues and suggestions at below mentioned Email:  ',
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                    Consumer<DashboardProvider>(builder: (context, value, _) {
                      return InkWell(
                          onTap: value.launchEmail,
                          child: Text('appfeedback@csn.edu.pk',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.primaryColor,
                                  decoration: TextDecoration.underline)));
                    })
                  ]))
            ])));
  }
}
