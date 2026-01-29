import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomTabBar/custom_tab_bar.dart';
import 'package:tcs_app/provider/Library/library_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/screens/Student/LibraryScreen/library_notification_screen.dart';

import 'library_records_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return LibraryScreenState();
  }
}

class LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  var provider = Provider.of<LibraryProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    provider.initializeData(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LibraryProvider>(
        builder: (context, value, _) {
          return CustomTabBar(
            scrollController: value.scrollController,
            appBarTitle: 'Library',
            tabs: const [
              Tab(child: Text('Records')),
              Tab(child: Text('Notifications')),
            ],
            widgets: const <Widget>[
              LibraryDetailsScreen(),
              LibraryNotificationScreen(),
            ],
            controller: value.tabController,
          );
        },
      ),
    );
  }
}
