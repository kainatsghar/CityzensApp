import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/provider/Results/results_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';

import '../../../components/IndividualEducationPlanComponents/Individual_education_plan_component.dart';

class IndividualEducationPlanScreen extends StatefulWidget {
  const IndividualEducationPlanScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return IndividualEducationPlanState();
  }
}

class IndividualEducationPlanState
    extends State<IndividualEducationPlanScreen> {
  late Future _academicTermService;
  var provider = Provider.of<ResultsProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    _academicTermService = provider.loadAcademicTerm();
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
      appBar: const CustomAppBar(title: 'INDIVIDUAL EDUCATION PLAN'),
      body: RefreshIndicator(
        child: FutureBuilder(
          future: _academicTermService,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CustomLoader();
              default:
                if (snapshot.hasData) {
                  return const IndividualEducationPlanComponent();
                } else {
                  return const IndividualEducationPlanComponent();
                  //return ShowError(errorText: '${snapshot.error}');
                }
            }
          },
        ),
        onRefresh: () => provider.loadAcademicTerm(),
      ),
    );
  }
}
