import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/ResultsComponents/overall_result_view_decider.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/Results/results_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class OverallResultScreen extends StatefulWidget {
  const OverallResultScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return OverallResultScreenState();
  }
}

class OverallResultScreenState extends State<OverallResultScreen> {
  late Future resultService;
  var provider = Provider.of<ResultsProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

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
                return const OverallResultViewDecider();
              } else {
                return ShowError(errorText: '${snapshot.error}');
              }
          }
        },
      ),
      onRefresh: () => provider.loadAcademicTerm(),
    );
  }
}
