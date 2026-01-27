import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/StudentProfileComponents/student_profile_component.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/StudentProfile/student_profile_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return StudentProfileScreenState();
  }
}

class StudentProfileScreenState extends State<StudentProfileScreen> {
  late Future _stdProfile;

  var provider = Provider.of<StudentProfileProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    _stdProfile = provider.loadStdProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'PROFILE'),
      body: RefreshIndicator(
        child: FutureBuilder(
          future: _stdProfile,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CustomLoader();
              default:
                if (snapshot.hasData) {
                  return const StudentProfileComponent();
                } else {
                  return ShowError(errorText: '${snapshot.error}');
                }
            }
          },
        ),
        onRefresh: () => provider.loadStdProfile(),
      ),
    );
  }
}
