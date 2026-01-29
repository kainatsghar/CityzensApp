import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/ResultsComponents/eye_overall_result.dart';
import 'package:tcs_app/components/ResultsComponents/result_card_info.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/provider/Results/results_provider.dart';
import 'package:tcs_app/utils/app_constants.dart';

class EyeOverallResultsComponent extends StatelessWidget {
  const EyeOverallResultsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ResultsProvider>(
        builder: (context, value, _) {
          return value.eyeResult.isEmpty
              ? const ShowCustomMessage(message: AppConstants.noRecordFound)
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ResultCardInfo(
                        stdInfo: value.resultsResponse.info!,
                        term: value.termController.text,
                        session: value.academicYearController.text,
                      ),
                      const EyeOverallResult(),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
