import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/MarkUnverifiedComponents/mark_unverified_component.dart';
import '../../../custom_widgets/CustomAppBar/custom_app_bar.dart';
import '../../../provider/MarkUnverified/mark_unverified_provider.dart';
import '../../../routes/app_navigation.dart';

class MarkUnidentifiedScreen extends StatefulWidget {
  const MarkUnidentifiedScreen({super.key});

  @override
  State<MarkUnidentifiedScreen> createState() => _MarkUnidentifiedScreenState();
}

class _MarkUnidentifiedScreenState extends State<MarkUnidentifiedScreen> {
  // late Future _sections, _reasons;
  var provider = Provider.of<MarkUnverifiedProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    provider.clearFormState();
    // _sections = provider.loadSections();
    // _reasons = provider.loadReasons();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'MARK UNIDENTIFIED'),
      body: const MarkUnverifiedComponent(),
      // FutureBuilder(
      //   future: Future.wait([_sections, _reasons]),
      //   builder: (context, snapshot) {
      //     switch (snapshot.connectionState) {
      //       case ConnectionState.waiting:
      //         return const CustomLoader();
      //       default:
      //         if (snapshot.hasData) {
      //           return const MarkUnverifiedComponent();
      //         } else {
      //           return ShowError(errorText: '${snapshot.error}');
      //         }
      //     }
      //   },
      // ),
    );
  }
}
