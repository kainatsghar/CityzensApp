import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/custom_app_bar.dart';

import 'package:tcs_app/citizen/Components/AddCircularComponents/add_circular_component.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/citizen/Provider/Circular/circular_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class AddCircularScreen extends StatefulWidget {
  const AddCircularScreen({super.key});

  @override
  State<AddCircularScreen> createState() => _AddCircularScreenState();
}

class _AddCircularScreenState extends State<AddCircularScreen> {
  late Future _sections;
  var provider = Provider.of<CircularProvider>(AppNavigation.currentContext!,
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
        appBar: const CustomAppBar(title: 'ADD CIRCULARS'),
        body: FutureBuilder(
            future: _sections,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const CustomLoader();
                default:
                  if (snapshot.hasData) {
                    return const AddCircularComponent();
                  } else {
                    return ShowError(errorText: '${snapshot.error}');
                  }
              }
            }));
  }
}
