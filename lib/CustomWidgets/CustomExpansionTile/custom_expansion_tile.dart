import 'package:flutter/material.dart';

import '../../Utils/app_colors.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final String? detailMsg;
  final List<Widget> children;
  final EdgeInsets? childrenPadding;

  const CustomExpansionTile({
    super.key,
    required this.title,
    this.detailMsg,
    this.children = const [],
    this.childrenPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          collapsedBackgroundColor: AppColors.secondaryColor,
          title: Text(
            title,
            style: const TextStyle(
              color: AppColors.primaryTitleColor,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          iconColor: AppColors.primaryTitleColor,
          collapsedIconColor: AppColors.primaryTitleColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,
          childrenPadding: childrenPadding,
          children: children.isEmpty
              ? <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        detailMsg!,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ]
              : children,
        ),
      ),
    );
  }
}
