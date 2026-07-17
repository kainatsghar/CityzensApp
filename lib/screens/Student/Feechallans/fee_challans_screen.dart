import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomTabBar/custom_tab_bar.dart';
import 'package:tcs_app/provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/components/FeeChallanComponents/outstanding_fee_component.dart';
import 'package:tcs_app/components/FeeChallanComponents/receipt_fee_component.dart';
import 'package:tcs_app/services/FirebaseServices/app_analytics_service.dart';

class FeeChallanScreen extends StatefulWidget {
  const FeeChallanScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FeeChallanScreenState();
}

class _FeeChallanScreenState extends State<FeeChallanScreen>
    with SingleTickerProviderStateMixin {
  late final FeeChallanProvider _provider;

  @override
  void initState() {
    super.initState();
    AppAnalyticsService.logFeatureAccess("Fee Challans");
    _provider = Provider.of<FeeChallanProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );
    _provider.initializeData(this);
    // Deferred to avoid notifyListeners() during build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.loadAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // AppBar is always visible — loading/error states are inside each tab
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
            widgets: <Widget>[
              OutstandingFeeComponent(onRefresh: _provider.loadAllData),
              ReceiptFeeComponent(onRefresh: _provider.loadAllData),
            ],
            controller: value.controller,
          );
        },
      ),
    );
  }
}
