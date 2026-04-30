// === UPDATED FILE: custom_timetable_form_field.dart ===
// Modernized: Premium input styling with subtle fill, refined focus states,
// and consistent border radius matching the new design system.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_colors.dart';

class CustomTimeTableFormField extends StatelessWidget {
  final IconData? prefixIcon;
  final Widget? suffixWidget;
  final String hintText;
  final bool isEnable, obscureText;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final FocusNode? node;
  final ValueChanged<String>? onChange;
  final TextInputAction? inputAction;
  final bool readOnly;
  final Function()? onTap;
  final int maxLines;
  final int? maxLength;
  final FormFieldValidator<String>? validator;

  final AutovalidateMode autoValidateMode;
  final String? labelText;
  final List<TextInputFormatter> inputFormatter;
  final bool isDense;
  final TextCapitalization? textCapitalization;

  const CustomTimeTableFormField({
    super.key,
    this.hintText = "",
    this.obscureText = false,
    this.isEnable = true,
    this.inputType,
    this.controller,
    this.node,
    this.validator,
    this.onChange,
    this.inputAction = TextInputAction.done,
    this.readOnly = false,
    this.onTap,
    this.prefixIcon,
    this.suffixWidget,
    this.autoValidateMode = AutovalidateMode.onUserInteraction,
    this.maxLines = 1,
    this.maxLength,
    this.labelText,
    this.isDense = false,
    this.inputFormatter = const [],
    this.textCapitalization,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatter,
      autovalidateMode: autoValidateMode,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      keyboardType: inputType ?? TextInputType.text,
      obscureText: obscureText,
      textInputAction: inputAction ?? TextInputAction.next,
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      focusNode: node,
      onTap: onTap,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      readOnly: readOnly,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: isEnable
            ? AppColors.primaryDarkColor
            : AppColors.primaryDarkColor.withOpacity(0.65),
      ),
      decoration: InputDecoration(
        fillColor: isEnable
            ? AppColors.primaryBlue.withOpacity(0.04)
            : Colors.grey.shade50,
        filled: true,
        focusColor: AppColors.primaryLightBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.primaryBlue.withOpacity(0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.primaryBlue.withOpacity(0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.primaryBlue,
            width: 1.5,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.1),
          ),
        ),
        enabled: isEnable,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 10,
        ),
        counterText: '',
        errorMaxLines: 5,
        suffixIcon: suffixWidget == null
            ? null
            : Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: suffixWidget,
              ),
        prefixIcon: prefixIcon != null
            ? Container(
                margin: const EdgeInsets.only(right: 3.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Icon(prefixIcon, color: AppColors.whiteColor),
              )
            : null,
        hintText: hintText,
        labelStyle: const TextStyle(fontSize: 14.0),
        hintStyle: TextStyle(
          fontSize: 12.0,
          color: Colors.grey.shade400,
        ),
      ),
      enabled: isEnable,
      validator: validator,
      onChanged: onChange,
    );
  }
}
