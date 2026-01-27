import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/AddSchoolEventComponents/add_school_event_component.dart';
import 'package:tcs_app/Provider/SchoolEvents/school_event_provider.dart';

import '../../../custom_widgets/CustomAppBar/custom_app_bar.dart';
import '../../../custom_widgets/CustomLoader/custom_loader.dart';
import '../../../custom_widgets/ShowError/show_error.dart';
import '../../../Routes/app_navigation.dart';

class AddSchoolEventScreen extends StatefulWidget {
  const AddSchoolEventScreen({super.key});

  @override
  State<AddSchoolEventScreen> createState() => _AddSchoolEventScreenState();
}

class _AddSchoolEventScreenState extends State<AddSchoolEventScreen> {
  late Future sections;
  var provider = Provider.of<SchoolEventProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    sections = provider.loadSections();
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
      appBar: const CustomAppBar(title: 'ADD SCHOOL EVENTS'),
      body: FutureBuilder(
        future: sections,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CustomLoader();
            default:
              if (snapshot.hasData) {
                return const AddSchoolEventComponent();
              } else {
                return ShowError(errorText: '${snapshot.error}');
              }
          }
        },
      ),
    );
  }
}
