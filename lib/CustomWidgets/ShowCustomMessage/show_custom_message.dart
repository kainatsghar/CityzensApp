import 'package:flutter/material.dart';

class ShowCustomMessage extends StatelessWidget {
  final String message;
  final bool showMsg;

  const ShowCustomMessage(
      {super.key, required this.message, this.showMsg = false});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/no-data-found.png',
                height: size.width * 0.5, width: size.width * 0.5),
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
