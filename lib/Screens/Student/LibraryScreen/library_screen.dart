import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomTabBar/custom_tab_bar.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/custom_widgets/CustomStudentInfo/custom_student_info.dart';
import 'package:tcs_app/custom_widgets/ShowCustomMessage/show_message_image.dart';
import 'package:tcs_app/components/NotificationComponents/notification_component.dart';
import 'package:tcs_app/components/LibraryComponents/single_library_item.dart';
import 'package:tcs_app/provider/Library/library_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late final LibraryProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<LibraryProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );
    _provider.initializeData(this);
    // Deferred to avoid notifyListeners() during build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _provider.loadAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // AppBar is always visible — loading/error states are inside each tab
    return Scaffold(
      body: Consumer<LibraryProvider>(
        builder: (context, value, _) {
          return CustomTabBar(
            scrollController: value.scrollController,
            appBarTitle: 'LIBRARY',
            tabs: const [
              Tab(child: Text('RECORDS')),
              Tab(child: Text('NOTIFICATIONS')),
            ],
            widgets: <Widget>[
              _LibraryRecordsTab(onRefresh: _provider.loadAllData),
              _NotificationsTab(onRefresh: _provider.loadAllData),
            ],
            controller: value.tabController,
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// LIBRARY RECORDS TAB
// ═══════════════════════════════════════════════════════════════════
class _LibraryRecordsTab extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const _LibraryRecordsTab({this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(
      builder: (context, value, _) {
        // Loading state
        if (value.isLoading && value.libraryResponse == null) {
          return const CustomLoader();
        }

        // Error state
        if (value.loadError != null && value.libraryResponse == null) {
          return ShowError(errorText: value.loadError!);
        }

        final records = value.libraryResponse?.listLibrary;

        if (records == null || records.isEmpty) {
          return const ShowMessageOnImage(message: 'No library records found');
        }

        return RefreshIndicator(
          onRefresh: onRefresh ?? () async {},
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: records.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return CustomStudentInfo(info: value.libraryResponse!.info);
              }

              final recordIndex = index - 1;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleLibraryItem(
                  record: records[recordIndex],
                  index: recordIndex,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// NOTIFICATIONS TAB — wraps NotificationComponent with RefreshIndicator
// ═══════════════════════════════════════════════════════════════════
class _NotificationsTab extends StatelessWidget {
  final Future<void> Function()? onRefresh;

  const _NotificationsTab({this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh ?? () async {},
      child: const CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [SliverFillRemaining(child: NotificationComponent())],
      ),
    );
  }
}
