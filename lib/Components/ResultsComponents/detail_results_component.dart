import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/ResultsComponents/detail_result.dart';
import 'package:tcs_app/components/ResultsComponents/result_card_info.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/provider/Results/results_provider.dart';
import 'package:tcs_app/utils/app_constants.dart';

class DetailResultsComponent extends StatelessWidget {
  const DetailResultsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ResultsProvider>(
        builder: (context, value, _) {
          return value.resultsResponse.listDetail!.isEmpty
              ? const ShowCustomMessage(message: AppConstants.noRecordFound)
              : ListView.builder(
                  itemCount: value.resultsResponse.listDetail!.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return ResultCardInfo(
                        stdInfo: value.resultsResponse.info!,
                        term: value.termController.text,
                        session: value.academicYearController.text,
                      );
                    } else {
                      index -= 1;
                      return DetailResult(index: index);
                    }
                  },
                );
        },
      ),
    );
  }
}
