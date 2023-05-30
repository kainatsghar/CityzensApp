import 'package:flutter/material.dart';

import '../../Utils/app_colors.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final String detailMsg;

  const CustomExpansionTile({Key key, this.title, this.detailMsg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: ExpansionTile(
        collapsedBackgroundColor: AppColors.secondaryColor,
        title: Text(title,
            style: TextStyle(
                color: AppColors.primaryTitleColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic)),
        children: <Widget>[
          Padding(
            child: Text(detailMsg, style: TextStyle(color: Colors.black)),
            padding: EdgeInsets.all(10),
          ),
        ],
      ),
    );
  }
}
