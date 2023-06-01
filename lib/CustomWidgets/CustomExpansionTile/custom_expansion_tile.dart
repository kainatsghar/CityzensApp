import 'package:flutter/material.dart';

import '../../Utils/app_colors.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final String detailMsg;
  final List<Widget> children;

  const CustomExpansionTile(
      {Key key, this.title, this.detailMsg, this.children = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedBackgroundColor: AppColors.secondaryColor,
          title: Text(title,
              style: TextStyle(
                  color: AppColors.primaryTitleColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic)),
          children: children.isEmpty
              ? <Widget>[
                  Padding(
                    child:
                        Text(detailMsg, style: TextStyle(color: Colors.black)),
                    padding: EdgeInsets.all(10),
                  ),
                ]
              : children,
        ),
      ),
    );
  }
}
