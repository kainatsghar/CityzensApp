import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/model/Options/options.dart';

class CustomDropdownMenu extends StatelessWidget {
  final List<Options> options;
  final String selectedValue;
  final ValueChanged<String?> itemCallBack;
  final bool isEnabled;
  final Color? textColor;
  final String hintText;
  final Widget? dropDownIcon;
  final double width;

  const CustomDropdownMenu({
    super.key,
    required this.options,
    this.selectedValue = '',
    this.isEnabled = true,
    required this.itemCallBack,
    this.textColor,
    this.hintText = 'Select',
    this.dropDownIcon,
    this.width = 150.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 35,
      decoration: BoxDecoration(
        color: AppColors.blackColor,
        border: Border.all(width: 0.2),
        borderRadius: BorderRadius.circular(3),
      ),
      child: DropdownButton<String>(
        underline: const SizedBox.shrink(),
        value: selectedValue.isEmpty ? null : selectedValue,
        style: const TextStyle(fontSize: 14.0),
        hint: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(hintText),
        ),
        isExpanded: true,
        icon: dropDownIcon ?? const Icon(Icons.arrow_drop_down, size: 30),
        items: options.map((item) {
          return DropdownMenuItem<String>(
            value: '${item.value}',
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${item.title}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          );
        }).toList(),
        onChanged: isEnabled ? itemCallBack : null,
      ),
    );
  }
}
