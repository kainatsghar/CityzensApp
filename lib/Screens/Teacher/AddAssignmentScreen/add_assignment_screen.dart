import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/AddAssignmentComponents/add_assignment_component.dart';
import 'package:tcs_app/Provider/Assignment/assignment_provider.dart';

import '../../../CustomWidgets/CustomAppbar/custom_appbar.dart';
import '../../../CustomWidgets/CustomLoader/custom_loader.dart';
import '../../../CustomWidgets/ShowError/show_error.dart';
import '../../../Routes/app_navigation.dart';

class AddAssignmnetScreen extends StatefulWidget {
  const AddAssignmnetScreen({super.key});

  @override
  State<AddAssignmnetScreen> createState() => _AddAssignmnetScreenState();
}

class _AddAssignmnetScreenState extends State<AddAssignmnetScreen> {
  late Future sections;
  var provider = Provider.of<AssignmentProvider>(AppNavigation.currentContext!,
      listen: false);

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
        appBar: const CustomAppBar(title: 'ADD ASSIGNMENT'),
        body: FutureBuilder(
            future: sections,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CustomLoader();
                default:
                  if (snapshot.hasData) {
                    return const AddAssignmentComponent();
                  } else {
                    return ShowError(errorText: '${snapshot.error}');
                  }
              }
            }));
  }
}
