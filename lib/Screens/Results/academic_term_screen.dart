import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/AcademicTermComponents/academic_term_component.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/Results/results_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class AcademicTermScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AcademicTermScreenState();
  }
}

class AcademicTermScreenState extends State<AcademicTermScreen> {
  Future _academicTermService;
  var provider =
      Provider.of<ResultsProvider>(AppNavigation.currentContext, listen: false);

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
        appBar: CustomAppBar(title: 'Academic Year & Term'),
        body: RefreshIndicator(
            child: FutureBuilder(
                future: _academicTermService,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CustomLoader();
                    default:
                      if (snapshot.hasData) {
                        return AcademicTermComponent();
                      } else {
                        return ShowError(errorText: '${snapshot.error}');
                      }
                  }
                }),
            onRefresh: () => provider.loadAcademicTerm()));
  }
}
