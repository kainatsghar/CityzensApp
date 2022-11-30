import 'package:flutter/material.dart';
import 'package:tcs_app/CustomWidgets/CustomTitleValue/custom_title_value.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/model/FeeChallan/challan_receipts_response.dart';
import 'package:tcs_app/model/FeeChallan/outstanding_challan_response.dart';

class SingleReceiptItem extends StatelessWidget {
  final FeechallanHistory record;

  const SingleReceiptItem({Key key, this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Column(
          children: <Widget>[
            CustomTitleValue(title: 'Receipt No', value: record.receiptNo),
            CustomTitleValue(title: 'Period Name', value: record.periodName),
            CustomTitleValue(title: 'Challan Type', value: record.challanType),
            CustomTitleValue(
                title: 'Receipt Date',
                value: HelperFunction.dateFormatter(record.receiptDate)),
            CustomTitleValue(title: 'Amount', value: 'PKR ${record.amount}'),
            CustomTitleValue(title: 'Over Receipt', value: '${record.overReceipt}')
          ],
        ),
      ),
    );
  }
}
