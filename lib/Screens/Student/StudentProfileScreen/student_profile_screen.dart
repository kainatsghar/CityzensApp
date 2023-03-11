import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/StudentProfileComponents/student_profile_component.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/StudentProfile/student_profile_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class StudentProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StudentProfileScreenState();
  }
}

class StudentProfileScreenState extends State<StudentProfileScreen> {
  Future _stdProfile;

  var provider = Provider.of<StudentProfileProvider>(
      AppNavigation.currentContext,
      listen: false);

  @override
  void initState() {
    _stdProfile = provider.loadStdProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Profile'),
      body: RefreshIndicator(
          child: FutureBuilder(
              future: _stdProfile,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CustomLoader();
                  default:
                    if (snapshot.hasData) {
                      return StudentProfileComponent();
                    } else {
                      return ShowError(errorText: '${snapshot.error}');
                    }
                }
              }),
          onRefresh: () => provider.loadStdProfile()),
    );
  }
}
