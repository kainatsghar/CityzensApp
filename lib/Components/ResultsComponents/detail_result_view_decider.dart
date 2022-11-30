import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/ResultsComponents/detail_results_component.dart';
import 'package:tcs_app/Components/ResultsComponents/eye_detail_results_component.dart';
import 'package:tcs_app/Provider/Results/results_provider.dart';

class DetailResultViewDecider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ResultsProvider>(builder: (context, value, _) {
      String className = value.resultsResponse.info.className ?? '';
      return className == 'Class 1' ||
              className == 'Class 2' ||
              className == 'Playgroup' ||
              className == 'Nursery' ||
              className == 'Kindergarten'
          ? EyeDetailResultsComponent()
          : DetailResultsComponent();
    });
  }
}
