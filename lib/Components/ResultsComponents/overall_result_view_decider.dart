import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/ResultsComponents/eye_overall_results_component.dart';
import 'package:tcs_app/Components/ResultsComponents/overall_results_component.dart';
import 'package:tcs_app/Provider/Results/results_provider.dart';

class OverallResultViewDecider extends StatelessWidget {
  const OverallResultViewDecider({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResultsProvider>(builder: (context, value, _) {
      String className = value.resultsResponse.info!.className ?? '';
      return className == 'Class 1' ||
              className == 'Class 2' ||
              className == 'Playgroup' ||
              className == 'Nursery' ||
              className == 'Kindergarten'
          ? const EyeOverallResultsComponent()
          : const OverallResultsComponent();
    });
  }
}
