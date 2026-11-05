import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Components/TeacherProfileComponents/teacher_profile_component.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/citizen/Provider/TeacherProfile/teacher_profile_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';

class TeacherProfileScreen extends StatefulWidget {
  const TeacherProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return TeacherProfileScreenState();
  }
}

class TeacherProfileScreenState extends State<TeacherProfileScreen> {
  late Future _teacherProfile;

  TeacherProfileProvider get provider => Provider.of<TeacherProfileProvider>(
        AppNavigation.currentContext!,
        listen: false,
      );

  @override
  void initState() {
    _teacherProfile = provider.loadTeacherProfile();
    super.initState();
  }

  Widget _buildStaticHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 16, 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Text(
                'Profile',
                style: AppThemes.sora(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: RefreshIndicator(
        color: AppColors.blue,
        backgroundColor: AppColors.yellow,
        onRefresh: () async {
          setState(() {
            _teacherProfile = provider.loadTeacherProfile();
          });
        },
        child: FutureBuilder(
          future: _teacherProfile,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Column(
                  children: [
                    _buildStaticHeader(context),
                    const Expanded(
                      child: Center(
                        child: CustomLoader(),
                      ),
                    ),
                  ],
                );
              default:
                if (snapshot.hasData) {
                  return const TeacherProfileComponent();
                } else {
                  return Column(
                    children: [
                      _buildStaticHeader(context),
                      Expanded(
                        child: Center(
                          child: ShowError(errorText: '${snapshot.error}'),
                        ),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
