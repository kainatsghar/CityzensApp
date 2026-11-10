import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Components/MarkUnverifiedComponents/mark_unverified_component.dart';
import 'package:tcs_app/CustomWidgets/CityzensIcons/cityzens_icons.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/cityzens_back_button.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/citizen/Provider/MarkUnverified/mark_unverified_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';

class MarkUnidentifiedScreen extends StatefulWidget {
  const MarkUnidentifiedScreen({super.key});

  @override
  State<MarkUnidentifiedScreen> createState() => _MarkUnidentifiedScreenState();
}

class _MarkUnidentifiedScreenState extends State<MarkUnidentifiedScreen> {
  late Future _sections, _reasons;

  MarkUnverifiedProvider get provider => Provider.of<MarkUnverifiedProvider>(
        AppNavigation.currentContext!,
        listen: false,
      );

  @override
  void initState() {
    _sections = provider.loadSections();
    _reasons = provider.loadReasons();
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
          // T3 Blue Header (Back Button, Centered Title, Intro Banner)
          Container(
            width: double.infinity,
            color: AppColors.blue,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CityzensBackButton(
                          size: 40,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                        Text(
                          'Mark unidentified',
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

                  // Translucent Intro Banner (.mu .intro)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const CityzensIcon(
                          type: CityzensIconType.search,
                          size: 28,
                          primaryColor: Colors.white,
                          secondaryColor: Color(0xFF9DBFEA),
                          accentColor: AppColors.blue,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'For a student who is in class but not on your list.',
                            style: AppThemes.roboto(
                              fontSize: 12.5,
                              color: Colors.white.withValues(alpha: 0.92),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Form Body
          Expanded(
            child: FutureBuilder(
              future: Future.wait([_sections, _reasons]),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CustomLoader());
                  default:
                    if (snapshot.hasData) {
                      return const MarkUnverifiedComponent();
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
