import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Provider/Results/results_provider.dart';

class EyeOverallResult extends StatelessWidget {
  const EyeOverallResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResultsProvider>(
      builder: (context, value, _) {
        return Card(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  title: const Text(
                    "Teacher's Comments:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(value.resultsResponse.info!.teacherComment!),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  'PERFORMANCE INDICATORS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: ListTile(
                  title: Text(
                    '► Exceeding Development:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text('Working above the expected level'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: ListTile(
                  title: Text(
                    '► Expected Development:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text('Working at the expected level'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: ListTile(
                  title: Text(
                    '► Emerging Development:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text('Working below the expected level'),
                ),
              ),
              Visibility(
                visible: value.selectAcademicYear >= 11 ? false : true,
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: ListTile(
                    title: Text(
                      '► Needs Improvement:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      'Experiencing difficulty requires continuous assistance',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
