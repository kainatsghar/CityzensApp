import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/Provider/DashboardProvider/dashboard_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class AboutAppScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AboutAppScreenState();
  }
}

class AboutAppScreenState extends State<AboutAppScreen> {
  var provider = Provider.of<DashboardProvider>(AppNavigation.currentContext,
      listen: false);

  @override
  void initState() {
    provider.loadVersionName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'About App'),
        body: Container(
            margin: EdgeInsets.all(15.0),
            child: SingleChildScrollView(child:
            Consumer<DashboardProvider>(builder: (context, value, _) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 5),
                    Text('App Version',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 2),
                    Text(
                      value.projectVersion,
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Update App',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 2),
                    InkWell(
                        child: Text(
                          Platform.isAndroid
                              ? 'Check for updates on Google Play Store'
                              : 'Check for updates on App Store',
                          style: TextStyle(
                              color: AppColors.primaryColor, fontSize: 15),
                        ),
                        onTap: () => Platform.isAndroid
                            ? value.launchPlayStore()
                            : value.launchAppStore()),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Divider(color: Colors.black, height: 8.0)),
                    Text('App Modifications',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(height: 5),
                    Text(
                        "\u2022 Teacher's Module Added\n"
                            '\u2022 Online Student Registraion Form(Coming Soon)\n'
                            '\u2022 Student Attendance\n'
                            '\u2022 Privacy Policy Dialog Box on Invstr Button\n'
                            '\u2022 Invstr button enable/disable\n'
                            '\u2022 App logging\n'
                            '\u2022 Bug fixes\n'
                            '\u2022 Layout changes\n'
                            '\u2022 Student registration\n'
                            '\u2022 App feedback screen\n',
                        style: TextStyle(color: AppColors.primaryColor)),
                    Divider(color: Colors.black, height: 8.0)
                  ]);
            }))));
  }
}
