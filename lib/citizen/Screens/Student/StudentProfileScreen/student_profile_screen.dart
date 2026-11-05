import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Components/StudentProfileComponents/student_profile_component.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/citizen/Provider/StudentProfile/student_profile_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return StudentProfileScreenState();
  }
}

class StudentProfileScreenState extends State<StudentProfileScreen> {
  late Future _stdProfile;

  StudentProfileProvider get provider => Provider.of<StudentProfileProvider>(
        AppNavigation.currentContext!,
        listen: false,
      );

  @override
  void initState() {
    _stdProfile = provider.loadStdProfile();
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
            _stdProfile = provider.loadStdProfile();
          });
        },
        child: FutureBuilder(
          future: _stdProfile,
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
                  return const StudentProfileComponent();
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
