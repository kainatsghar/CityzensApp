import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/cityzens_back_button.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/citizen/Components/AddCircularComponents/add_circular_component.dart';
import 'package:tcs_app/citizen/Provider/Circular/circular_provider.dart';

class AddCircularScreen extends StatefulWidget {
  const AddCircularScreen({super.key});

  @override
  State<AddCircularScreen> createState() => _AddCircularScreenState();
}

class _AddCircularScreenState extends State<AddCircularScreen> {
  late Future _sections;

  CircularProvider get provider => Provider.of<CircularProvider>(
        AppNavigation.currentContext!,
        listen: false,
      );

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
      backgroundColor: AppColors.paper,
      body: Column(
        children: [
          // T7 Blue Header (Circular Back Button, Centered Title, Spacer)
          Container(
            width: double.infinity,
            color: AppColors.blue,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CityzensBackButton(
                      size: 40,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    Text(
                      'Add circular',
                      style: AppThemes.sora(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 40, height: 40),
                  ],
                ),
              ),
            ),
          ),

          // Body
          Expanded(
            child: FutureBuilder(
              future: _sections,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CustomLoader());
                  default:
                    if (snapshot.hasData) {
                      return const AddCircularComponent();
                    } else {
                      return ShowError(errorText: '${snapshot.error}');
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
