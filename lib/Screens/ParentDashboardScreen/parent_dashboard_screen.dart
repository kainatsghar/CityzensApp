import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/DashboardComponents/navigational_drawer.dart';
import 'package:tcs_app/Components/ParentDashboardComponents/multi_child_component.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/ParentDashboardProvider/parent_dashboard_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class ParentDashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ParentHomepageState();
  }
}

class ParentHomepageState extends State<ParentDashboardScreen> {
  Future _multiChild;

  var provider = Provider.of<ParentDashboardProvider>(
      AppNavigation.currentContext,
      listen: false);

  @override
  void initState() {
    _multiChild = provider.loadMultiChildData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: 'Cityzens'),
        drawer: NavigationalDrawer(),
        body: RefreshIndicator(
          child: FutureBuilder(
              future: _multiChild,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CustomLoader();
                  default:
                    if (snapshot.hasData) {
                      return MultiChildComponent();
                    } else {
                      return ShowError(errorText: '${snapshot.error}');
                    }
                }
              }),
          onRefresh: () => provider.loadMultiChildData()
        ));
  }
}
