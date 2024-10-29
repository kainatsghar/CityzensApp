import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Components/LibraryComponents/library_component.dart';
import 'package:tcs_app/CustomWidgets/CustomAppbar/custom_appbar.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/Library/library_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return LibraryScreenState();
  }
}

class LibraryScreenState extends State<LibraryScreen> {
  late Future _libraryRecords;
  var provider = Provider.of<LibraryProvider>(AppNavigation.currentContext!,
      listen: false);

  @override
  void initState() {
    _libraryRecords = provider.loadLibraryRecords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: 'LIBRARY DETAILS'),
        body: RefreshIndicator(
            child: FutureBuilder(
                future: _libraryRecords,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const CustomLoader();
                    default:
                      if (snapshot.hasData) {
                        return const LibraryComponent();
                      } else {
                        return ShowError(errorText: '${snapshot.error}');
                      }
                  }
                }),
            onRefresh: () => provider.loadLibraryRecords()));
  }
}
