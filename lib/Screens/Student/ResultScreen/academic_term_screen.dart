import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/AcademicTermComponents/academic_term_component.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/provider/Results/results_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/services/FirebaseServices/app_analytics_service.dart';

class AcademicTermScreen extends StatefulWidget {
  const AcademicTermScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return AcademicTermScreenState();
  }
}

class AcademicTermScreenState extends State<AcademicTermScreen> {
  late Future _academicTermService;
  var provider = Provider.of<ResultsProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    provider.clearFormState();
    AppAnalyticsService.logFeatureAccess("Term Results");
    _academicTermService = provider.loadAcademicTerm();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'ACADEMIC YEAR & TERM'),
      body: RefreshIndicator(
        child: FutureBuilder(
          future: _academicTermService,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CustomLoader();
              default:
                if (snapshot.hasData) {
                  return const AcademicTermComponent();
                } else {
                  return ShowError(errorText: '${snapshot.error}');
                }
            }
          },
        ),
        onRefresh: () => provider.loadAcademicTerm(forceRefresh: true),
      ),
    );
  }
}
