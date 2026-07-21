import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcs_app/utils/app_colors.dart';

class CustomTextFormFieldV2 extends StatelessWidget {
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
  final FormFieldValidator<String>? validator;

  final AutovalidateMode autoValidateMode;
  final String? labelText;
  final List<TextInputFormatter> inputFormatter;
  final bool isDense;
  final TextCapitalization? textCapitalization;

  const CustomTextFormFieldV2({
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
    this.labelText,
    this.isDense = false,
    this.inputFormatter = const [],
    this.textCapitalization,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 14.0,
        color: AppColors.primaryDarkBlue,
        fontWeight: FontWeight.bold,
      ),
      inputFormatters: inputFormatter,
      autovalidateMode: autoValidateMode,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      keyboardType: inputType ?? TextInputType.text,
      obscureText: obscureText,
      textInputAction: inputAction ?? TextInputAction.next,
      controller: controller,
      maxLines: maxLines,
      focusNode: node,
      onTap: onTap,
      readOnly: readOnly,
      decoration: InputDecoration(
        fillColor: AppColors.secondaryColor,
        filled: true,
        focusColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.secondaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.secondaryColor),
        ),
        isDense: isDense,
        enabled: isEnable,
        contentPadding: const EdgeInsets.only(left: 40),
        errorMaxLines: 5,
        suffixIcon: suffixWidget == null
            ? null
            : Container(
                decoration: const BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                ),
                child: suffixWidget,
              ),
        prefixIcon: prefixIcon != null
            ? Container(
                margin: const EdgeInsets.only(right: 3.0),
                decoration: const BoxDecoration(
                  color: AppColors.secondaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  ),
                ),
                child: Icon(prefixIcon, color: AppColors.white),
              )
            : null,
        hintText: hintText,
        labelStyle: const TextStyle(fontSize: 14.0),
        hintStyle: const TextStyle(
          fontSize: 14.0,
          color: AppColors.primaryDarkBlue,
          fontWeight: FontWeight.bold,
        ) /*,
            labelText: labelText*/,
      ),
      enabled: isEnable,
      validator: validator,
      onChanged: onChange,
    );
  }
}
