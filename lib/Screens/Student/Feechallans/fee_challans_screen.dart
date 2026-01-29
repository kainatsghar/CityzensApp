import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomTabBar/custom_tab_bar.dart';
import 'package:tcs_app/provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/screens/Student/Feechallans/receipt_fee_screen.dart';

import 'outstanding_fee_screen.dart';

class FeeChallanScreen extends StatefulWidget {
  const FeeChallanScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return FeeChallanScreenState();
  }
}

class FeeChallanScreenState extends State<FeeChallanScreen>
    with SingleTickerProviderStateMixin {
  var provider = Provider.of<FeeChallanProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    provider.initializeData(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FeeChallanProvider>(
        builder: (context, value, _) {
          return CustomTabBar(
            scrollController: value.scrollController,
            appBarTitle: 'FEE CHALLANS',
            tabs: const [
              Tab(child: Text('OUTSTANDING')),
              Tab(child: Text('RECEIPTS')),
            ],
            widgets: const <Widget>[OutstandingFeeScreen(), ReceiptFeeScreen()],
            controller: value.controller,
          );
        },
      ),
    );
  }
}
