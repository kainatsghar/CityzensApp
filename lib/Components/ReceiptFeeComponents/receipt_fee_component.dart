import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/ReceiptFeeComponents/single_receipt_item.dart';
import 'package:tcs_app/CustomWidgets/CustomStudentInfo/custom_student_info.dart';
import 'package:tcs_app/CustomWidgets/ShowCustomMessage/show_custom_message.dart';
import 'package:tcs_app/Provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/Utils/app_constants.dart';

class ReceiptFeeComponent extends StatelessWidget {
  const ReceiptFeeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<FeeChallanProvider>(builder: (context, value, _) {
        var responseData = value.challanReceiptResponse!.receiptList;
        return responseData == null || responseData.isEmpty
            ? const ShowCustomMessage(message: AppConstants.noRecordFound)
            : ListView.builder(
                itemCount: responseData.length + 1,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return value.challanReceiptResponse!.info == null
                        ? const SizedBox.shrink()
                        : CustomStudentInfo(
                            info: value.challanReceiptResponse!.info);
                  } else {
                    index -= 1;
                    return SingleReceiptItem(record: responseData[index]);
                  }
                });
      }),
    );
  }
}
