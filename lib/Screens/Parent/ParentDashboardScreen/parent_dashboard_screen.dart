import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/DashboardComponents/navigational_drawer.dart';
import 'package:tcs_app/Components/ParentDashboardComponents/multi_child_component.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/ParentDashboard/parent_dashboard_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Services/FCMTokenRefresh/fcm_token_refresh_service.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return ParentHomepageState();
  }
}

class ParentHomepageState extends State<ParentDashboardScreen> {
  late Future _multiChild;

  var provider = Provider.of<ParentDashboardProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    _multiChild = provider.loadMultiChildData();
    FcmTokenRefreshService.refreshToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'CITYZENS'),
      drawer: const NavigationalDrawer(),
      body: RefreshIndicator(
        child: FutureBuilder(
          future: _multiChild,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CustomLoader();
              default:
                if (snapshot.hasData) {
                  return const MultiChildComponent();
                } else {
                  return ShowError(errorText: '${snapshot.error}');
                }
            }
          },
        ),
        onRefresh: () => provider.loadMultiChildData(),
      ),
    );
  }
}
