import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/AppointmentComponents/parents_appointment_component.dart';
import '../../../custom_widgets/CustomAppBar/custom_app_bar.dart';
import '../../../custom_widgets/CustomLoader/custom_loader.dart';
import '../../../custom_widgets/ShowError/show_error.dart';
import '../../../provider/Appointment/appointment_provider.dart';
import '../../../routes/app_navigation.dart';

class ParentAppointmentScreen extends StatefulWidget {
  const ParentAppointmentScreen({super.key});

  @override
  State<ParentAppointmentScreen> createState() =>
      _ParentAppointmentScreenState();
}

class _ParentAppointmentScreenState extends State<ParentAppointmentScreen> {
  late Future meetingRecords;
  var provider = Provider.of<AppointmentProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

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
        },
      ),
    );
  }
}
