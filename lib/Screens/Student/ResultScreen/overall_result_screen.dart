import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/ResultsComponents/overall_result_view_decider.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/Results/results_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';


class OverallResultScreen extends StatefulWidget {
  OverallResultScreen({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new OverallResultScreenState();
  }
}

class OverallResultScreenState extends State<OverallResultScreen> {
  Future resultService;
  var provider =
      Provider.of<ResultsProvider>(AppNavigation.currentContext, listen: false);

  @override
  void initState() {
    resultService = provider.loadResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: FutureBuilder(
            future: resultService,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CustomLoader();
                default:
                  if (snapshot.hasData) {
                    return OverallResultViewDecider();
                  } else {
                    return ShowError(errorText: '${snapshot.error}');
                  }
              }
            }),
        onRefresh: () => provider.loadAcademicTerm());
  }
}
