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
    return Container(
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryTitleColor),
          borderRadius: BorderRadius.circular(15.0),
          color: AppColors.secondaryColor),
      child: Column(
        children: <Widget>[
          CustomTitleValue(title: 'Receipt No', value: record.receiptNo!),
          CustomTitleValue(title: 'Period Name', value: record.periodName!),
          CustomTitleValue(title: 'Challan Type', value: record.challanType!),
          CustomTitleValue(
              title: 'Receipt Date',
              value: HelperFunction.dateFormatter(record.receiptDate!)),
          CustomTitleValue(title: 'Amount', value: 'PKR ${record.amount}'),
          CustomTitleValue(
              title: 'Over Receipt',
              value: '${record.overReceipt}',
              showDivider: false)
        ],
      ),
    );
  }
}
