import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/cityzens_menu_button.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/citizen/Components/DashboardComponents/navigational_drawer.dart';
import 'package:tcs_app/citizen/Components/ParentDashboardComponents/multi_child_component.dart';
import 'package:tcs_app/citizen/Model/MultiChild/multi_child_response.dart';
import 'package:tcs_app/citizen/Model/StudentAttendance/attendance_percentage_response.dart';
import 'package:tcs_app/citizen/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/citizen/Provider/ParentDashboard/parent_dashboard_provider.dart';
import 'package:tcs_app/citizen/Provider/StudentAttendance/student_attendance_provider.dart';
import 'package:tcs_app/citizen/Services/FCMTokenRefresh/fcm_token_refresh_service.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return ParentHomepageState();
  }
}

class ParentHomepageState extends State<ParentDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<MultiChildResponse> _multiChild;

  ParentDashboardProvider get provider => Provider.of<ParentDashboardProvider>(
        AppNavigation.currentContext!,
        listen: false,
      );

  @override
  void initState() {
    _multiChild = provider.loadMultiChildData();
    FcmTokenRefreshService.refreshToken();
    super.initState();
  }

  Future<void> _handleRefresh() async {
    final Future<MultiChildResponse> nextFuture = provider.loadMultiChildData();
    setState(() {
      _multiChild = nextFuture;
    });
    await nextFuture;
    if (!mounted) return;
    final localData = Provider.of<LocalDataProvider>(context, listen: false);
    if (localData.studentId.isNotEmpty) {
      final attendance =
          Provider.of<StudentAttendanceProvider>(context, listen: false);
      await attendance
          .getAttendancePercentage()
          .catchError((_) => AttendancePercentageResponse());
    }
  }

  Widget _buildFallbackTopBar(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.blue,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CityzensMenuButton(
                size: 40,
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/logo-horizontal-white.png',
                    height: 36,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 40, height: 40),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.paper,
      drawer: const NavigationalDrawer(),
      body: RefreshIndicator(
        color: AppColors.blue,
        backgroundColor: AppColors.yellow,
        onRefresh: _handleRefresh,
        child: FutureBuilder<MultiChildResponse>(
          future: _multiChild,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Column(
                  children: [
                    _buildFallbackTopBar(context),
                    const Expanded(child: Center(child: CustomLoader())),
                  ],
                );
              default:
                if (snapshot.hasData) {
                  return MultiChildComponent(
                    onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
                  );
                } else {
                  return Column(
                    children: [
                      _buildFallbackTopBar(context),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.72,
                            child: ShowError(
                              errorText: '${snapshot.error}',
                              showRetryOption: true,
                              onTap: _handleRefresh,
                            ),
                          ),
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
