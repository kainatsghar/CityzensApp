import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomTitleValue/custom_title_value.dart';
import 'package:tcs_app/Provider/LocalData/local_data_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/model/FeeChallan/outstanding_challan_response.dart';

import '../../Utils/app_colors.dart';

class SingleChallanItem extends StatelessWidget {
  final OutstandingChallan record;

  const SingleChallanItem({super.key, required this.record});

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
            CustomTitleValue(title: 'Challan No', value: record.challanNo!),
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
            CustomTitleValue(title: 'Challan Type', value: record.challanType!),
            CustomTitleValue(title: 'Period Name', value: record.periodName!),
            CustomTitleValue(
              title: 'Original Fee',
              value: 'PKR ${record.originalFee}',
              showDivider: false,
            ),
            SizedBox(height: 8.0),
            if (Provider.of<LocalDataProvider>(
                  AppNavigation.currentContext!,
                  listen: false,
                ).userData!.userType ==
                'Parent')
              CustomAppButton(
                buttonTitle: 'Pay Now',
                onTap: () =>
                    AppNavigation.navigateTo(AppNavRoutes.challanPaymentRoute),
              ),
          ],
        ),
      ),
    );
  }
}
