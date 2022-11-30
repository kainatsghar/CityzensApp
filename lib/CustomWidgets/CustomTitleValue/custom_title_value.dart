import 'package:flutter/material.dart';

class CustomTitleValue extends StatelessWidget {
  final String value;
  final String title;

  const CustomTitleValue({Key key, this.value, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            children: <Widget>[
              Container(
                width: size.width / 3.4,
                child: Text(
                  '$title: ',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                  child: Text(value,
                      style: TextStyle(color: Colors.blueGrey, fontSize: 13)))
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Divider(height: 0.0, color: Colors.black))
      ],
    );
  }
}
