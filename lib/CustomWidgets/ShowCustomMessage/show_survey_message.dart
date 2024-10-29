import 'package:flutter/material.dart';

class ShowSurveyMessage extends StatelessWidget {
  final String message;
  final bool showMsg;

  const ShowSurveyMessage(
      {super.key, required this.message, this.showMsg = false});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.04),
            Image.asset('images/survey_announcement.png'),
            Visibility(
              visible: showMsg,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(message,
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600))),
            )
          ]),
    );
  }
}
