import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tcs_app/citizen/Components/AppointmentComponents/parents_appointment_component.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/citizen/Provider/Appointment/appointment_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class ParentAppointmentScreen extends StatefulWidget {
  const ParentAppointmentScreen({super.key});

  @override
  State<ParentAppointmentScreen> createState() =>
      _ParentAppointmentScreenState();
}

class _ParentAppointmentScreenState extends State<ParentAppointmentScreen> {
  late Future meetingRecords;
  var provider = Provider.of<AppointmentProvider>(AppNavigation.currentContext!,
      listen: false);

  @override
  void initState() {
    meetingRecords = provider.loadAppointments();
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
      appBar: const CustomAppBar(title: 'PARENTS APPOINTMENT'),
      body: FutureBuilder(
          future: meetingRecords,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const CustomLoader();
              default:
                if (snapshot.hasData) {
                  return const ParentAppointmentComponent();
                } else {
                  return ShowError(errorText: '${snapshot.error}');
                }
            }
          }),
    );
  }
}
