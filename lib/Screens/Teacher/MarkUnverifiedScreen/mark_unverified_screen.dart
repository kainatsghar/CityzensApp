import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Components/MarkUnverifiedComponents/mark_unverified_component.dart';
import '../../../CustomWidgets/CustomAppbar/custom_appbar.dart';
import '../../../CustomWidgets/CustomLoader/custom_loader.dart';
import '../../../CustomWidgets/ShowError/show_error.dart';
import '../../../Provider/MarkUnverified/mark_unverified_provider.dart';
import '../../../Routes/app_navigation.dart';

class MarkUnverifiedScreen extends StatefulWidget {
  const MarkUnverifiedScreen({Key key}) : super(key: key);

  @override
  State<MarkUnverifiedScreen> createState() => _MarkUnverifiedScreenState();
}

class _MarkUnverifiedScreenState extends State<MarkUnverifiedScreen> {
  Future _sections, _reasons;
  var provider = Provider.of<MarkUnverifiedProvider>(
      AppNavigation.currentContext,
      listen: false);

  @override
  void initState() {
    _sections = provider.loadSections();
    _reasons = provider.loadReasons();
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
        appBar: CustomAppBar(title: 'Mark Unverified'),
        body: FutureBuilder(
            future: Future.wait([_sections,_reasons]),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CustomLoader();
                default:
                  if (snapshot.hasData) {
                    return MarkUnverifiedComponent();
                  } else {
                    return ShowError(errorText: '${snapshot.error}');
                  }
              }
            }));
  }
}
