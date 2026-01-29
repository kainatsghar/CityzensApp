import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/OutstandingFeeComponents/outstanding_fee_component.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';

class OutstandingFeeScreen extends StatefulWidget {
  const OutstandingFeeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return OutstandingFeeScreenState();
  }
}

class OutstandingFeeScreenState extends State<OutstandingFeeScreen> {
  late Future _outstandingFeeService;
  var provider = Provider.of<FeeChallanProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    _outstandingFeeService = provider.loadOutstandingRecords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: FutureBuilder(
        future: _outstandingFeeService,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CustomLoader();
            default:
              if (snapshot.hasData) {
                return const OutstandingFeeComponent();
              } else {
                return ShowError(errorText: '${snapshot.error}');
              }
          }
        },
      ),
      onRefresh: () => provider.loadOutstandingRecords(),
    );
  }
}
