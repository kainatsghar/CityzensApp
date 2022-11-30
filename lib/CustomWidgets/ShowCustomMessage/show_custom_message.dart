import 'package:flutter/material.dart';

class ShowCustomMessage extends StatelessWidget {
  final String message;

  const ShowCustomMessage({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/nodata-found.png',
                height: size.width * 0.3, width: size.width * 0.3),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(message,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)))
          ]),
    );
  }
}
