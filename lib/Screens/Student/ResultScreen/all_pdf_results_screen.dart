import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/ResultsComponents/all_pdf_results_list_component.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/Results/results_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/services/FirebaseServices/app_analytics_service.dart';

class AllPDFResultsScreen extends StatefulWidget {
  const AllPDFResultsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return AllPDFResultsScreenState();
  }
}

class AllPDFResultsScreenState extends State<AllPDFResultsScreen> {
  late Future _allResultsFuture;
  var provider = Provider.of<ResultsProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    AppAnalyticsService.logFeatureAccess("Term Results");
    _allResultsFuture = provider.loadAllPDFResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'TERM RESULTS'),
      body: RefreshIndicator(
        child: FutureBuilder(
          future: _allResultsFuture,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CustomLoader();
              default:
                if (snapshot.hasData) {
                  return const AllPDFResultsListComponent();
                } else {
                  return ShowError(errorText: '${snapshot.error}');
                }
            }
          },
        ),
        onRefresh: () {
          setState(() {
            _allResultsFuture = provider.loadAllPDFResults(forceRefresh: true);
          });
          return _allResultsFuture;
        },
      ),
    );
  }
}
