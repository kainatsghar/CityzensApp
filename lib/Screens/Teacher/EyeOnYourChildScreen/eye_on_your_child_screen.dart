import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/EyeOnYourChildComponents/eye_on_your_child_component.dart';
import '../../../custom_widgets/CustomAppBar/custom_app_bar.dart';
import '../../../custom_widgets/CustomLoader/custom_loader.dart';
import '../../../custom_widgets/ShowError/show_error.dart';
import '../../../Provider/EyeOnYourChild/eye_on_your_child_provider.dart';
import '../../../Routes/app_navigation.dart';

class EyeOnYourChildScreen extends StatefulWidget {
  const EyeOnYourChildScreen({super.key});

  @override
  State<EyeOnYourChildScreen> createState() => _EyeOnYourChildScreenState();
}

class _EyeOnYourChildScreenState extends State<EyeOnYourChildScreen> {
  late Future eyeOnYourChildRecords;
  var provider = Provider.of<EyeOnYourChildProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    eyeOnYourChildRecords = provider.loadEyeOnChildConfig();
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
      appBar: const CustomAppBar(title: 'EYE ON YOUR CHILD'),
      body: FutureBuilder(
        future: eyeOnYourChildRecords,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const CustomLoader();
            default:
              if (snapshot.hasData) {
                return const EyeOnYourChildComponent();
              } else {
                return ShowError(errorText: '${snapshot.error}');
              }
          }
        },
      ),
    );
  }
}
