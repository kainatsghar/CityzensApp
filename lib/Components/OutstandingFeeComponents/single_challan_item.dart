import 'package:flutter/material.dart';
import 'package:tcs_app/CustomWidgets/CustomTitleValue/custom_title_value.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/model/FeeChallan/outstanding_challan_response.dart';

class SingleChallanItem extends StatelessWidget {
  final OutstandingChallan record;

  const SingleChallanItem({Key key, this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(5.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
        child: Column(
          children: <Widget>[
            CustomTitleValue(title: 'Challan No', value: record.challanNo),
            CustomTitleValue(title: 'Issue Date', value: HelperFunction.dateFormatter(record.issueDate)),
            CustomTitleValue(
                title: 'Due Date',
                value: HelperFunction.dateFormatter(record.dueDate)),
            CustomTitleValue(
                title: 'Validity Date',
                value: HelperFunction.dateFormatter(record.validityDate)),
            CustomTitleValue(
                title: 'Challan Type',
                value: record.challanType),
            CustomTitleValue(
                title: 'Period Name', value: record.periodName),
            CustomTitleValue(
                title: 'Original Fee', value: 'PKR ${record.originalFee}'),
          ],
        ),
      ),
    );
  }
}
