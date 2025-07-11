import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Provider/ComplaintQuery/complaint_query_provider.dart';

import '../../../Components/ComplaintQueryComponents/complaint_query_componet.dart';
import '../../../CustomWidgets/CustomAppBar/custom_app_bar.dart';
import '../../../CustomWidgets/CustomLoader/custom_loader.dart';
import '../../../CustomWidgets/ShowError/show_error.dart';
import '../../../Routes/app_navigation.dart';

class ComplaintQueryScreen extends StatefulWidget {
  const ComplaintQueryScreen({super.key});

  @override
  State<ComplaintQueryScreen> createState() => _ComplaintQueryScreenState();
}

class _ComplaintQueryScreenState extends State<ComplaintQueryScreen> {
  late Future withdrawalReasonsRecords;
  var provider = Provider.of<ComplaintQueryProvider>(
      AppNavigation.currentContext!,
      listen: false);

  @override
  void initState() {
    provider.changeRollNumberInputField();
    withdrawalReasonsRecords = provider.loadComplaintQuery();

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
      appBar: const CustomAppBar(title: 'COMPLAINT/QUERY'),
      body: FutureBuilder(
          future: withdrawalReasonsRecords,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CustomLoader();
              default:
                if (snapshot.hasData) {
                  return const ComplaintQueryComponents();
                } else {
                  return ShowError(errorText: '${snapshot.error}');
                }
            }
          }),
    );
  }
}
