import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/TeacherProfileComponents/teacher_profile_component.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/TeacherProfile/teacher_profile_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class TeacherProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TeacherProfileScreenState();
  }
}

class TeacherProfileScreenState extends State<TeacherProfileScreen> {
  Future _teacherProfile;
  var provider = Provider.of<TeacherProfileProvider>(
      AppNavigation.currentContext,
      listen: false);

  @override
  void initState() {
    _teacherProfile = provider.loadTeacherProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'PROFILE'),
      body: RefreshIndicator(
          child: FutureBuilder(
              future: _teacherProfile,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CustomLoader();
                  default:
                    if (snapshot.hasData) {
                      return TeacherProfileComponent();
                    } else {
                      return ShowError(errorText: '${snapshot.error}');
                    }
                }
              }),
          onRefresh: () => provider.loadTeacherProfile()),
    );
  }
}
