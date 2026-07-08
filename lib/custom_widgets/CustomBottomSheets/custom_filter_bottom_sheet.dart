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
        child: ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: filterOptions.length,
          separatorBuilder: (context, index) => Divider(
            height: 1,
            color: AppColors.borderGrey.withValues(alpha: 0.5),
          ),
          itemBuilder: (context, index) {
            final item = filterOptions[index];
            final isSelected = controller.text == item.title;

            return Material(
              color: Colors.transparent,
              child: ListTile(
                onTap: () => onSelect(item.title!),
                dense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                tileColor: isSelected
                    ? AppColors.primaryBlue.withValues(alpha: 0.08)
                    : Colors.transparent,
                title: Text(
                  item.title!,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primaryBlue
                        : AppColors.primaryDarkBlue,
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
                trailing: isSelected
                    ? Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryBlue.withValues(alpha: 0.15),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppColors.primaryBlue,
                          size: 16,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            );
          },
        ),
      ),
    );
  }
}
