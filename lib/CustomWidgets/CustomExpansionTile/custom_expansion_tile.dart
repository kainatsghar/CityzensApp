import 'package:flutter/material.dart';

import '../../Utils/app_colors.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final String? detailMsg;
  final List<Widget> children;

  const CustomExpansionTile(
      {super.key,
      required this.title,
      this.detailMsg,
      this.children = const []});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedBackgroundColor: AppColors.secondaryColor,
          title: Text(title,
              style: const TextStyle(
                  color: AppColors.primaryTitleColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w600)),
          children: children.isEmpty
              ? <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(detailMsg!,
                        style: const TextStyle(color: Colors.black)),
                  ),
                ]
              : children,
        ),
      ),
    );
  }
}
