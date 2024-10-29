import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/OutstandingFeeComponents/outstanding_fee_component.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class OutstandingFeeScreen extends StatefulWidget {
  const OutstandingFeeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return OutstandingFeeScreenState();
  }
}

class OutstandingFeeScreenState extends State<OutstandingFeeScreen> {
  late Future _outstandingFeeService;
  var provider = Provider.of<FeeChallanProvider>(AppNavigation.currentContext!,
      listen: false);

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
            }),
        onRefresh: () => provider.loadOutstandingRecords());
  }
}
