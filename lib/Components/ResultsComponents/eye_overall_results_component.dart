import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/ResultsComponents/eye_overall_result.dart';
import 'package:tcs_app/Components/ResultsComponents/result_card_info.dart';
import 'package:tcs_app/CustomWidgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/Provider/Results/results_provider.dart';
import 'package:tcs_app/Utils/app_constants.dart';

class EyeOverallResultsComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ResultsProvider>(builder: (context, value, _) {
        return value.eyeResult.isEmpty
            ? ShowCustomMessage(message: AppConstants.noRecordFound)
            : SingleChildScrollView(
                child: Column(children: <Widget>[
                ResultCardInfo(
                    stdInfo: value.resultsResponse.info,
                    term: value.termController.text,
                    session: value.academicYearController.text),
                EyeOverallResult()
              ]));
      }),
    );
  }
}
