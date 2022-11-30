import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/Provider/Results/results_provider.dart';

class EyeDetailResult extends StatelessWidget {
  final int index;

  const EyeDetailResult({Key key, this.index = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ResultsProvider>(builder: (context, value, _) {
      return Padding(
        padding: EdgeInsets.only(top: 5.0),
        child: Card(
          shape: Border.all(),
          child: ExpansionTile(
            title: Text(
              value.eyeResult[index].subjectName,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            children: List.generate(
                value.eyeResult[index].details.length,
                (i) => ListTile(
                      title: Text(value.eyeResult[index].details[i].kLO,
                          textAlign: TextAlign.center),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        child: Table(
                            border: TableBorder.all(
                                width: 1.0, color: Colors.black),
                            children: [
                              TableRow(children: [
                                TableCell(
                                    child: Text(
                                  'Exceeding \n Dev.',
                                  textAlign: TextAlign.center,
                                )),
                                TableCell(
                                    child: Text(
                                      'Expected \n Dev.',
                                      textAlign: TextAlign.center,
                                    )),
                                TableCell(
                                    child: Text(
                                  'Emerging \n Dev.',
                                  textAlign: TextAlign.center,
                                )),
                                if (value.selectAcademicYear < 11) ...[
                                  TableCell(
                                      child: Text(
                                        'Needs \n Imp.',
                                        textAlign: TextAlign.center,
                                      ))
                                ]
                              ]),
                              TableRow(children: [
                                TableCell(
                                    child: Center(
                                        child: Icon(Icons.check,
                                            color: value.eyeResult[index]
                                                        .details[i].key1 ==
                                                    1
                                                ? Colors.green
                                                : Colors.transparent))),
                                TableCell(
                                    child: Icon(Icons.check,
                                        color: value.eyeResult[index].details[i]
                                                    .key2 ==
                                                1
                                            ? Colors.green[300]
                                            : Colors.transparent)),
                                TableCell(
                                    child: Icon(Icons.check,
                                        color: value.eyeResult[index]
                                                    .details[i].key3 ==
                                                1
                                            ? Colors.amber
                                            : Colors.transparent)),
                                if (value.selectAcademicYear < 11) ...[
                                  TableCell(
                                      child: Icon(Icons.check,
                                          color: value.eyeResult[index].details[i]
                                                      .key4 ==
                                                  1
                                              ? Colors.red
                                              : Colors.transparent))
                                ]
                              ])
                            ]),
                      ),
                    )),
          ),
        ),
      );
    });
  }
}
