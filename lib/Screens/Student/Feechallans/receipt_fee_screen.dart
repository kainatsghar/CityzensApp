import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/ReceiptFeeComponents/receipt_fee_component.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'dart:async';
import 'package:tcs_app/Provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class ReceiptFeeScreen extends StatefulWidget {
  ReceiptFeeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ReceiptFeeScreenState();
  }
}

class ReceiptFeeScreenState extends State<ReceiptFeeScreen> {
  Future _receiptService;
  var provider = Provider.of<FeeChallanProvider>(AppNavigation.currentContext,
      listen: false);

  @override
  void initState() {
    _receiptService = provider.loadReceiptRecords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: FutureBuilder(
            future: _receiptService,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CustomLoader();
                default:
                  if (snapshot.hasData) {
                    return ReceiptFeeComponent();
                  } else {
                    return ShowError(errorText: '${snapshot.error}');
                  }
              }
            }),
        onRefresh: () => provider.loadReceiptRecords());
  }
}
