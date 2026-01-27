import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/TeacherProfileComponents/teacher_profile_component.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/TeacherProfile/teacher_profile_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return TeacherProfileScreenState();
  }
}

class TeacherProfileScreenState extends State<TeacherProfileScreen> {
  Future? _teacherProfile;
  var provider = Provider.of<TeacherProfileProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    if (provider.profileResponse != null) {
      _teacherProfile = provider.loadTeacherProfile();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'PROFILE'),
      body: RefreshIndicator(
        child: provider.profileResponse != null
            ? const TeacherProfileComponent()
            : FutureBuilder(
                future: _teacherProfile,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CustomLoader();
                    default:
                      if (snapshot.hasData) {
                        return const TeacherProfileComponent();
                      } else {
                        return ShowError(errorText: '${snapshot.error}');
                      }
                  }
                },
              ),
        onRefresh: () => provider.loadTeacherProfile(),
      ),
    );
  }
}
