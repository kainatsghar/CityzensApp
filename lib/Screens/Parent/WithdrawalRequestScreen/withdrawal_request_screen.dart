import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Components/WithdrawalRequestComponents/withdrawal_request_component.dart';
import '../../../CustomWidgets/CustomAppBar/custom_app_bar.dart';
import '../../../CustomWidgets/CustomLoader/custom_loader.dart';
import '../../../CustomWidgets/ShowError/show_error.dart';
import '../../../Provider/WithdrawalRequest/withdrawal_request_provider.dart';
import '../../../Routes/app_navigation.dart';

class WithdrawalRequestScreen extends StatefulWidget {
  const WithdrawalRequestScreen({super.key});

  @override
  State<WithdrawalRequestScreen> createState() =>
      _WithdrawalRequestScreenState();
}

class _WithdrawalRequestScreenState extends State<WithdrawalRequestScreen> {
  late Future withdrawalReasonsRecords;
  var provider = Provider.of<WithdrawalRequestProvider>(
      AppNavigation.currentContext!,
      listen: false);

  @override
  void initState() {
    withdrawalReasonsRecords = provider.loadWithdrawal();

    super.initState();
  }

  @override
  void dispose() {
    provider.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'WITHDRAWAL REQUEST'),
      body: FutureBuilder(
          future: withdrawalReasonsRecords,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CustomLoader();
              default:
                if (snapshot.hasData) {
                  return const WithdrawalRequestComponent();
                } else {
                  return ShowError(errorText: '${snapshot.error}');
                }
            }
          }),
    );
  }
}
