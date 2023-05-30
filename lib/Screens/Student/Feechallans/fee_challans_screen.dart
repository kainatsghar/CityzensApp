import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomTabBar/custom_tab_bar.dart';
import 'package:tcs_app/Provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Screens/Student/Feechallans/receipt_fee_screen.dart';

import 'outstanding_fee_screen.dart';

class FeeChallanScreen extends StatefulWidget {
  FeeChallanScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FeeChallanScreenState();
  }
}

class FeeChallanScreenState extends State<FeeChallanScreen>
    with SingleTickerProviderStateMixin {
  var provider = Provider.of<FeeChallanProvider>(AppNavigation.currentContext,
      listen: false);

  @override
  void initState() {
    provider.initializeData(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FeeChallanProvider>(builder: (context, value, _) {
        return CustomTabBar(
            scrollController: value.scrollController,
            appBarTitle: 'FEE CHALLANS',
            tabs: [
              Tab(child: Text('OUTSTANDING')),
              Tab(child: Text('RECEIPTS'))
            ],
            widgets: <Widget>[OutstandingFeeScreen(), ReceiptFeeScreen()],
            controller: value.controller);
      }),
    );
  }
}
