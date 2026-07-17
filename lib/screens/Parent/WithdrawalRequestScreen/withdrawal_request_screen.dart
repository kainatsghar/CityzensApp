import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/WithdrawalRequestComponents/withdrawal_request_component.dart';
import '../../../custom_widgets/CustomAppBar/custom_app_bar.dart';
import '../../../custom_widgets/CustomLoader/custom_loader.dart';
import '../../../custom_widgets/ShowError/show_error.dart';
import '../../../provider/WithdrawalRequest/withdrawal_request_provider.dart';
import '../../../routes/app_navigation.dart';

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
    listen: false,
  );

  @override
  void initState() {
    provider.clearFormState();
    withdrawalReasonsRecords = provider.loadWithdrawal();

    super.initState();
  }

  @override
  void dispose() {
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
        },
      ),
    );
  }
}
