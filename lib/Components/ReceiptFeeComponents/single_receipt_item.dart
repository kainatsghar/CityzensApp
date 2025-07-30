import 'package:flutter/material.dart';
import 'package:tcs_app/CustomWidgets/CustomTitleValue/custom_title_value.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/model/FeeChallan/challan_receipts_response.dart';

class SingleReceiptItem extends StatelessWidget {
  final FeechallanHistory record;

  const SingleReceiptItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
        // margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          // border: Border.all(color: AppColors.primaryTitleColor),
          borderRadius: BorderRadius.circular(16.0),
          color: AppColors.secondaryColor,
        ),
        child: Column(
          children: <Widget>[
            CustomTitleValue(title: 'Receipt No', value: record.receiptNo!),
            CustomTitleValue(title: 'Period Name', value: record.periodName!),
            CustomTitleValue(title: 'Challan Type', value: record.challanType!),
            CustomTitleValue(
              title: 'Receipt Date',
              value: HelperFunction.dateFormatter(record.receiptDate!),
            ),
            CustomTitleValue(title: 'Amount', value: 'PKR ${record.amount}'),
            CustomTitleValue(
              title: 'Over Receipt',
              value: '${record.overReceipt}',
              showDivider: false,
            ),
          ],
        ),
      ),
    );
  }
}
