import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/citizen/Components/AcademicTermComponents/academic_term_component.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loader.dart';
import 'package:tcs_app/CustomWidgets/ShowError/show_error.dart';
import 'package:tcs_app/citizen/Provider/Results/results_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/cityzens_back_button.dart';

class AcademicTermScreen extends StatefulWidget {
  const AcademicTermScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return AcademicTermScreenState();
  }
}

class AcademicTermScreenState extends State<AcademicTermScreen> {
  late Future _academicTermService;
  ResultsProvider get provider =>
      Provider.of<ResultsProvider>(AppNavigation.currentContext!, listen: false);

  @override
  void initState() {
    _academicTermService = provider.loadAcademicTerm();
    super.initState();
  }

  @override
  void dispose() {
    provider.clearData();
    super.dispose();
  }

  Widget _buildStaticHeader(BuildContext context) {
    return Container(
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
                onTap: () => Navigator.of(context).pop(),
              ),
              Text(
                'Term results',
                style: AppThemes.sora(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.13),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _academicTermService = provider.loadAcademicTerm();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: RefreshIndicator(
        color: AppColors.blue,
        backgroundColor: AppColors.yellow,
        onRefresh: () async {
          setState(() {
            _academicTermService = provider.loadAcademicTerm();
          });
        },
        child: FutureBuilder(
          future: _academicTermService,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Column(
                  children: [
                    _buildStaticHeader(context),
                    const Expanded(
                      child: Center(
                        child: CustomLoader(),
                      ),
                    ),
                  ],
                );
              default:
                if (snapshot.hasData) {
                  return AcademicTermComponent(
                    onRefresh: () {
                      setState(() {
                        _academicTermService = provider.loadAcademicTerm();
                      });
                    },
                  );
                } else {
                  return Column(
                    children: [
                      _buildStaticHeader(context),
                      Expanded(
                        child: Center(
                          child: ShowError(errorText: '${snapshot.error}'),
                        ),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
