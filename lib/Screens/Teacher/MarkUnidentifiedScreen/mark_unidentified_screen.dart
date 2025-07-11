import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Components/MarkUnverifiedComponents/mark_unverified_component.dart';
import '../../../CustomWidgets/CustomAppBar/custom_app_bar.dart';
import '../../../CustomWidgets/CustomLoader/custom_loader.dart';
import '../../../CustomWidgets/ShowError/show_error.dart';
import '../../../Provider/MarkUnverified/mark_unverified_provider.dart';
import '../../../Routes/app_navigation.dart';

class MarkUnidentifiedScreen extends StatefulWidget {
  const MarkUnidentifiedScreen({super.key});

  @override
  State<MarkUnidentifiedScreen> createState() => _MarkUnidentifiedScreenState();
}

class _MarkUnidentifiedScreenState extends State<MarkUnidentifiedScreen> {
  late Future _sections, _reasons;
  var provider = Provider.of<MarkUnverifiedProvider>(
      AppNavigation.currentContext!,
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
        appBar: const CustomAppBar(title: 'MARK UNIDENTIFIED'),
        body: FutureBuilder(
            future: Future.wait([_sections, _reasons]),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CustomLoader();
                default:
                  if (snapshot.hasData) {
                    return const MarkUnverifiedComponent();
                  } else {
                    return ShowError(errorText: '${snapshot.error}');
                  }
              }
            }));
  }
}
