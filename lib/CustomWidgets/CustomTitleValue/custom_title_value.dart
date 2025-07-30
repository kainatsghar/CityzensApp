import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class CustomTitleValue extends StatelessWidget {
  final String value;
  final String title;
  final bool showDivider;

  const CustomTitleValue({
    super.key,
    required this.value,
    required this.title,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: size.width / 3.4,
                child: Text(
                  '$title: ',
                  style: const TextStyle(
                    color: AppColors.primaryTitleColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.black, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: showDivider,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 2.0),
            child: Divider(height: 0.0, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
