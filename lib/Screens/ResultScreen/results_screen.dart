import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomTabBar/custom_tab_bar.dart';
import 'package:tcs_app/Provider/Results/results_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Screens/ResultScreen/detail_result_screen.dart';
import 'package:tcs_app/Screens/ResultScreen/overall_result_screen.dart';

class ResultsScreen extends StatefulWidget {
  ResultsScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ResultsScreenState();
  }
}

class ResultsScreenState extends State<ResultsScreen>
    with SingleTickerProviderStateMixin {
  var provider =
      Provider.of<ResultsProvider>(AppNavigation.currentContext, listen: false);


  @override
  void initState() {
    provider.initializeData(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ResultsProvider>(builder: (context, value, _) {
      return CustomTabBar(
          scrollController: value.scrollController,
          appBarTitle: 'Results',
          tabs: [
            Tab(child: Text('Detail Result')),
            Tab(child: Text('Overall Result'))
          ],
          widgets: <Widget>[DetailResultScreen(), OverallResultScreen()],
          controller: value.controller);
    },
    ));
  }
}
