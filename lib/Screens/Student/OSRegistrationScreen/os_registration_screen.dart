import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/OSRegistrationComponents/os_registration_component.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/custom_widgets/ShowError/show_error.dart';
import 'package:tcs_app/Provider/OSRegistration/os_registration_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class OSRegistrationScreen extends StatefulWidget {
  const OSRegistrationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return OSRegistrationScreenState();
  }
}

class OSRegistrationScreenState extends State<OSRegistrationScreen> {
  late Future _nationalityService, _sessionService, _citiesService;

  var provider = Provider.of<OSRegistrationProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    provider.initializeData();
    _nationalityService = provider.loadCountries();
    _sessionService = provider.loadSessions();
    _citiesService = provider.loadCities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Student Registration'),
      body: FutureBuilder(
        future: Future.wait([
          _nationalityService,
          _sessionService,
          _citiesService,
        ]),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CustomLoader();
            default:
              if (snapshot.hasData) {
                return const OSRegistrationComponent();
              } else {
                return ShowError(errorText: '${snapshot.error}');
              }
          }
        },
      ),
    );
  }
}
