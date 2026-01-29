import 'package:flutter/material.dart';
import 'package:tcs_app/custom_widgets/CustomBottomSheets/custom_bottom_sheet.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/model/Options/options.dart';

class CustomFilterBottomSheet extends StatelessWidget {
  const CustomFilterBottomSheet({
    super.key,
    required this.controller,
    required this.filterOptions,
    required this.onSelect,
    this.title = 'User Type',
  });
  final TextEditingController controller;
  final List<Options> filterOptions;
  final ValueChanged<String> onSelect;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomBottomSheet(
        title: title,
        scrollRequired: true,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(filterOptions.length, (index) {
              var item = filterOptions[index];
              return Column(
                children: [
                  ListTile(
                    onTap: () => onSelect(item.title!),
                    //  onTap: () => onSelect(item.title),
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                    title: Text(
                      item.title!,
                      style: TextStyle(
                        color: controller.text == item.title
                            ? AppColors.primaryColor
                            : AppColors.blackColor,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Visibility(
                      visible: controller.text == item.title,
                      child: const Icon(
                        Icons.check,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  const Divider(height: 0.2),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
