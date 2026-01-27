import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/AppointmentComponents/book_an_appointment_component.dart';
import '../../../custom_widgets/CustomAppBar/custom_app_bar.dart';
import '../../../custom_widgets/CustomLoader/custom_loader.dart';
import '../../../custom_widgets/ShowError/show_error.dart';
import '../../../Provider/Appointment/appointment_provider.dart';
import '../../../Routes/app_navigation.dart';

class BookanAppointmentScreen extends StatefulWidget {
  const BookanAppointmentScreen({super.key});

  @override
  State<BookanAppointmentScreen> createState() =>
      _BookanAppointmentScreenState();
}

class _BookanAppointmentScreenState extends State<BookanAppointmentScreen> {
  late Future appointmentRecords;
  var provider = Provider.of<AppointmentProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    appointmentRecords = provider.loadAppointmentConfig();
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
      appBar: const CustomAppBar(title: 'BOOK AN APPOINTMENT'),
      body: FutureBuilder(
        future: appointmentRecords,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CustomLoader();
            default:
              if (snapshot.hasData) {
                return const BookAnAppointmentComponent();
              } else {
                return ShowError(errorText: '${snapshot.error}');
              }
          }
        },
      ),
    );
  }
}
