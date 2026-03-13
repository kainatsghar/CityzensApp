import 'package:flutter/material.dart';
import 'package:tcs_app/custom_widgets/CustomCard/custom_card.dart';
import 'package:tcs_app/custom_widgets/CustomTitleValue/custom_title_value.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:tcs_app/model/FeeChallan/challan_receipts_response.dart';

class SingleReceiptItem extends StatelessWidget {
  final FeechallanHistory record;

  const SingleReceiptItem({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        children: <Widget>[
          CustomTitleValue(title: 'Receipt No', value: record.receiptNo!),
          CustomTitleValue(title: 'Period Name', value: record.periodName!),
          CustomTitleValue(title: 'Challan Type', value: record.challanType!),
          CustomTitleValue(
            title: 'Receipt Date',
            value: HelperFunction.dateFormatter(record.receiptDate!),
          ),
          CustomTitleValue(
            title: 'Amount',
            value: HelperFunction().formatCurrency(record.amount!),
          ),
          CustomTitleValue(
            title: 'Over Receipt',
            value: HelperFunction().formatCurrency(record.overReceipt!),
            showDivider: false,
          ),
        ],
      ),
    );
  }
}
