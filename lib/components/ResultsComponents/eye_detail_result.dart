import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomExpansionTile/custom_expansion_tile.dart';
import 'package:tcs_app/provider/Results/results_provider.dart';
import 'package:tcs_app/utils/app_colors.dart';

class EyeDetailResult extends StatelessWidget {
  final int index;

  const EyeDetailResult({super.key, this.index = 0});

  @override
  Widget build(BuildContext context) {
    return Consumer<ResultsProvider>(
      builder: (context, value, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
          child: CustomExpansionTile(
            title: value.eyeResult[index].subjectName,
            children: List.generate(
              value.eyeResult[index].details.length,
              (i) => ListTile(
                title: Text(
                  value.eyeResult[index].details[i].kLO!,
                  textAlign: TextAlign.center,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Table(
                    border: TableBorder.all(width: 1.0, color: AppColors.black),
                    children: [
                      TableRow(
                        children: [
                          const TableCell(
                            child: Text(
                              'Exceeding \n Dev.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const TableCell(
                            child: Text(
                              'Expected \n Dev.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const TableCell(
                            child: Text(
                              'Emerging \n Dev.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (value.selectAcademicYear < 11) ...[
                            const TableCell(
                              child: Text(
                                'Needs \n Imp.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                            child: Center(
                              child: Icon(
                                Icons.check,
                                color:
                                    value.eyeResult[index].details[i].key1 == 1
                                    ? AppColors.materialGreen
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                          TableCell(
                            child: Icon(
                              Icons.check,
                              color: value.eyeResult[index].details[i].key2 == 1
                                  ? AppColors.green300
                                  : Colors.transparent,
                            ),
                          ),
                          TableCell(
                            child: Icon(
                              Icons.check,
                              color: value.eyeResult[index].details[i].key3 == 1
                                  ? AppColors.amber
                                  : Colors.transparent,
                            ),
                          ),
                          if (value.selectAcademicYear < 11) ...[
                            TableCell(
                              child: Icon(
                                Icons.check,
                                color:
                                    value.eyeResult[index].details[i].key4 == 1
                                    ? AppColors.materialRed
                                    : Colors.transparent,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
