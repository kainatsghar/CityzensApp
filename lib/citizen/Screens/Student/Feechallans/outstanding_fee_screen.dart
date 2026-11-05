import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Components/OutstandingFeeComponents/outstanding_fee_component.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/citizen/Provider/FeeChallan/feechallan_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class OutstandingFeeScreen extends StatefulWidget {
  const OutstandingFeeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return OutstandingFeeScreenState();
  }
}

class OutstandingFeeScreenState extends State<OutstandingFeeScreen> {
  late Future _outstandingFeeService;
  FeeChallanProvider get provider =>
      Provider.of<FeeChallanProvider>(AppNavigation.currentContext!,
          listen: false);

  @override
  void initState() {
    _outstandingFeeService = provider.loadOutstandingRecords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.blue,
      backgroundColor: AppColors.yellow,
      onRefresh: () => provider.loadOutstandingRecords(),
      child: FutureBuilder(
        future: _outstandingFeeService,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CustomLoader());
            default:
              if (snapshot.hasData) {
                return const OutstandingFeeComponent();
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
