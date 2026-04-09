import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/utils/app_colors.dart';

import '../../../components/CircularRecordComponents/circular_record_component.dart';
import '../../../custom_widgets/CustomLoader/custom_loader.dart';
import '../../../custom_widgets/ShowError/show_error.dart';
import '../../../provider/Circular/circular_provider.dart';
import '../../../routes/app_navigation.dart';

class TeacherCircularScreen extends StatefulWidget {
  const TeacherCircularScreen({super.key});

  @override
  State<TeacherCircularScreen> createState() => _TeacherCircularScreenState();
}

class _TeacherCircularScreenState extends State<TeacherCircularScreen> {
  late Future _circularRecords;
  var provider = Provider.of<CircularProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    _circularRecords = provider.loadTeacherCircular();
    super.initState();
  }

  @override
  void dispose() {
    provider.clearLibraryData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ultraLightGrey,
      appBar: const CustomAppBar(title: 'CIRCULARS'),
      body: FutureBuilder(
        future: _circularRecords,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CustomLoader();
            default:
              if (snapshot.hasData) {
                return const CircularRecordComponent();
              } else {
                return ShowError(errorText: '${snapshot.error}');
              }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppNavigation.navigateTo(AppNavRoutes.addCircularRoute),
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add, color: AppColors.whiteColor),
      ),
    );
  }
}
