import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';

import '../../../Components/AddDiaryComponents/add_diary_component.dart';
import '../../../CustomWidgets/CustomLoader/custom_loader.dart';
import '../../../CustomWidgets/ShowError/show_error.dart';
import '../../../Provider/Diary/diary_provider.dart';
import '../../../Routes/app_navigation.dart';

class AddDiaryScreen extends StatefulWidget {
  const AddDiaryScreen({Key key}) : super(key: key);

  @override
  State<AddDiaryScreen> createState() => _AddDiaryScreenState();
}

class _AddDiaryScreenState extends State<AddDiaryScreen> {
  Future _sections;
  var provider = Provider.of<DiaryProvider>(AppNavigation.currentContext,
      listen: false);

  @override
  void initState() {
    _sections = provider.loadSections();
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
        appBar: CustomAppBar(title: 'Add Diary'),
        body: FutureBuilder(
            future: _sections,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CustomLoader();
                default:
                  if (snapshot.hasData) {
                    return AddDiaryComponent();
                  } else {
                    return ShowError(errorText: '${snapshot.error}');
                  }
              }
            }));
  }
}
