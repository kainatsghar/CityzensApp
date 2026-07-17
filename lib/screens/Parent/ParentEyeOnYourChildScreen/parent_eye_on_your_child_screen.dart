import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/EyeOnYourChildComponents/parent_eye_on_your_child_component.dart';
import '../../../custom_widgets/CustomAppBar/custom_app_bar.dart';
import '../../../custom_widgets/CustomLoader/custom_loader.dart';
import '../../../custom_widgets/ShowError/show_error.dart';
import '../../../provider/EyeOnYourChild/eye_on_your_child_provider.dart';
import '../../../routes/app_navigation.dart';

class ParentEyeOnYourChildScreen extends StatefulWidget {
  const ParentEyeOnYourChildScreen({super.key});

  @override
  State<ParentEyeOnYourChildScreen> createState() =>
      _ParentEyeOnYourChildScreenState();
}

class _ParentEyeOnYourChildScreenState
    extends State<ParentEyeOnYourChildScreen> {
  late Future eyeOnYourChildRecords;
  var provider = Provider.of<EyeOnYourChildProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    eyeOnYourChildRecords = provider.loadStudentUpdates();
    super.initState();
  }

  @override
  void dispose() {
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
                return const ParentEyeOnYourChildComponent();
              } else {
                return ShowError(errorText: '${snapshot.error}');
              }
          }
        },
      ),
    );
  }
}
