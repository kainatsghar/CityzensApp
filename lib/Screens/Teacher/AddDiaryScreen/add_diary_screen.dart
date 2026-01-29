import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';

import '../../../components/AddDiaryComponents/add_diary_component.dart';
import '../../../provider/Diary/diary_provider.dart';
import '../../../routes/app_navigation.dart';

class AddDiaryScreen extends StatefulWidget {
  const AddDiaryScreen({super.key});

  @override
  State<AddDiaryScreen> createState() => _AddDiaryScreenState();
}

class _AddDiaryScreenState extends State<AddDiaryScreen> {
  // late Future _sections;
  var provider = Provider.of<DiaryProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    // _sections = provider.loadSections();
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
      appBar: const CustomAppBar(title: 'ADD HOMEWORK'),
      body: const AddDiaryComponent(),
      // FutureBuilder(
      //   future: _sections,
      //   builder: (context, snapshot) {
      //     switch (snapshot.connectionState) {
      //       case ConnectionState.waiting:
      //         return const CustomLoader();
      //       default:
      //         if (snapshot.hasData) {
      //           return const AddDiaryComponent();
      //         } else {
      //           return ShowError(errorText: '${snapshot.error}');
      //         }
      //     }
      //   },
      // ),
    );
  }
}
