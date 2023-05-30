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
        appBar: CustomAppBar(title: 'APP FEEDBACK'),
        body: Container(
            margin: EdgeInsets.all(15.0),
            child: Column(children: <Widget>[
              Image.asset('images/logo_cover.png',
                  fit: BoxFit.fitWidth,
                  height: size.height * 0.18,
                  width: size.width * 0.5),
              SizedBox(height: size.height * 0.03),
              Column(children: <Widget>[
                Text(
                    'Please share any issues and suggestions at below mentioned Email:  ',
                    style: TextStyle(color: Colors.black, fontSize: 16.0)),
                SizedBox(height: size.height * 0.01),
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
              ])
            ])));
  }
}
