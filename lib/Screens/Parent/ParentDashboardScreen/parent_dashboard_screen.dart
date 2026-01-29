import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/DashboardComponents/navigational_drawer.dart';
import 'package:tcs_app/components/ParentDashboardComponents/multi_child_component.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/ParentDashboard/parent_dashboard_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/services/FCMTokenRefresh/fcm_token_refresh_service.dart';

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
        onRefresh: () => provider.loadMultiChildData(),
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
                  return SingleChildScrollView(
                    child: SizedBox(
                      height:
                          MediaQuery.sizeOf(context).height -
                          kToolbarHeight -
                          MediaQuery.paddingOf(context).top,
                      child: ShowError(
                        errorText: '${snapshot.error}',
                        showRetryOption: true,
                        onTap: () => provider.loadMultiChildData(),
                      ),
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
