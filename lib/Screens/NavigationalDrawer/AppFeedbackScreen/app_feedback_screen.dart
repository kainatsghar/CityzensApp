import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/Provider/Dashboard/dashboard_provider.dart';
import 'package:tcs_app/Utils/app_colors.dart';

import '../../../CustomWidgets/CustomLogoCover/custom_logo_cover.dart';

class AppFeedbackScreen extends StatefulWidget {
  const AppFeedbackScreen({super.key});

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
        appBar: const CustomAppBar(title: 'APP FEEDBACK'),
        body: Container(
            margin: const EdgeInsets.all(15.0),
            child: Column(children: <Widget>[
              const CustomLogoCover(),
              SizedBox(height: size.height * 0.03),
              Column(children: <Widget>[
                const Text(
                    'Please share any issues and suggestions at below mentioned Email:  ',
                    style: TextStyle(color: Colors.black, fontSize: 16.0)),
                SizedBox(height: size.height * 0.01),
                Consumer<DashboardProvider>(builder: (context, value, _) {
                  return InkWell(
                      onTap: value.launchEmail,
                      child: const Text('appfeedback@csn.edu.pk',
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
