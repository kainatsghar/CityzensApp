import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class CustomTitleValue extends StatelessWidget {
  final String value;
  final String title;
  final bool showDivider;

  const CustomTitleValue(
      {Key key, this.value, this.title, this.showDivider = true})
      : super(key: key);

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
                      color: AppColors.primaryTitleColor, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                  child: Text(value,
                      style: TextStyle(color: Colors.black, fontSize: 13)))
            ],
          ),
        ),
        Visibility(
          visible: showDivider,
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Divider(height: 0.0, color: Colors.black)),
        )
      ],
    );
  }
}
