import 'package:flutter/material.dart';
import 'package:tcs_app/custom_widgets/CustomTitleValue/custom_title_value.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/model/FeeChallan/outstanding_challan_response.dart';

import '../../Utils/app_colors.dart';

class SingleChallanItem extends StatelessWidget {
  final OutstandingChallan record;
  final List<OutstandingChallan>? arearMonths;
  const SingleChallanItem({super.key, required this.record, this.arearMonths});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        // margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          // border: Border.all(color: AppColors.primaryTitleColor),
          borderRadius: BorderRadius.circular(16.0),
          color: AppColors.secondaryColor,
        ),
        child: Column(
          children: <Widget>[
            CustomTitleValue(
              title: 'Challan No',
              value: record.challanNo!,
              isSelectionAllowed: true,
            ),
            CustomTitleValue(
              title: 'Issue Date',
              value: HelperFunction.dateFormatter(record.issueDate!),
            ),
            CustomTitleValue(
              title: 'Due Date',
              value: HelperFunction.dateFormatter(record.dueDate!),
            ),
            CustomTitleValue(
              title: 'Validity Date',
              value: HelperFunction.dateFormatter(record.validityDate!),
            ),
            // CustomTitleValue(title: 'Challan Type', value: record.challanType!),
            CustomTitleValue(title: 'Billing Month', value: record.periodName!),
            CustomTitleValue(
              title: '${record.periodName} Fee',
              value: HelperFunction().formatCurrency(record.outstandingFee!),
            ),
            // CustomTitleValue(
            //   title: 'Outstanding Fee',
            //   value: 'PKR ${record.outstandingFee}',
            //   showDivider: false,
            // ),
            if (arearMonths != null && arearMonths!.isNotEmpty) ...[
              for (var month in arearMonths!) ...[
                CustomTitleValue(
                  title: 'Arrears ${month.periodName}',
                  value: HelperFunction().formatCurrency(month.outstandingFee!),
                ),
              ],
            ],
            CustomTitleValue(
              title: 'Total Payable',
              value: HelperFunction().formatCurrency(
                record.outstandingFee! +
                    (arearMonths != null
                        ? arearMonths!.fold(
                            0,
                            (sum, item) => sum + item.outstandingFee!,
                          )
                        : 0),
              ),
              boldValue: true,
              showDivider: false,
            ),

            // SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
