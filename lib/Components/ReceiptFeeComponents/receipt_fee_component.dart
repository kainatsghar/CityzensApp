import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/OutstandingFeeComponents/single_challan_item.dart';
import 'package:tcs_app/CustomWidgets/CustomStudentInfo/custom_student_info.dart';
import 'package:tcs_app/CustomWidgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/Provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/Utils/app_constants.dart';

class ReceiptFeeComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<FeeChallanProvider>(builder: (context, value, _) {
        var responseData = value.outstandingChallans.outstandingList;
        return responseData.isEmpty
            ? ShowCustomMessage(message: AppConstants.noRecordFound)
            : ListView.builder(
                itemCount: responseData.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return CustomStudentInfo(
                        info: value.outstandingChallans.info);
                  } else {
                    index -= 1;
                    return SingleChallanItem(record: responseData[index]);
                  }
                });
      }),
    );
  }
}
