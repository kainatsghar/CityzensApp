import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Components/ReceiptFeeComponents/receipt_fee_component.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/citizen/Provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class ReceiptFeeScreen extends StatefulWidget {
  const ReceiptFeeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return ReceiptFeeScreenState();
  }
}

class ReceiptFeeScreenState extends State<ReceiptFeeScreen> {
  late Future _receiptService;
  FeeChallanProvider get provider =>
      Provider.of<FeeChallanProvider>(AppNavigation.currentContext!,
          listen: false);

  @override
  void initState() {
    _receiptService = provider.loadReceiptRecords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.blue,
      backgroundColor: AppColors.yellow,
      onRefresh: () => provider.loadReceiptRecords(),
      child: FutureBuilder(
        future: _receiptService,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CustomLoader());
            default:
              if (snapshot.hasData) {
                return const ReceiptFeeComponent();
              } else {
                return Center(
                  child: ShowError(errorText: '${snapshot.error}'),
                );
              }
          }
        },
      ),
    );
  }
}
