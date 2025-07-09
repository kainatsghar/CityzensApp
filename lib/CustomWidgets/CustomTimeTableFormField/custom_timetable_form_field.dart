import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Utils/app_colors.dart';

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
  final FormFieldValidator<String>? validator;

  final AutovalidateMode autoValidateMode;
  final String? labelText;
  final List<TextInputFormatter> inputFormatter;
  final bool isDense;
  final TextCapitalization? textCapitalization;

  const CustomTimeTableFormField(
      {super.key,
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
      this.textCapitalization});

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
        maxLines: maxLines,
        focusNode: node,
        onTap: onTap,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        readOnly: readOnly,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.secondaryColor),
        decoration: InputDecoration(
            fillColor: AppColors.whiteColor,
            filled: true,
            focusColor: AppColors.whiteColor,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: AppColors.whiteColor)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: AppColors.whiteColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: AppColors.whiteColor)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.transparent)),
            isDense: isDense,
            enabled: isEnable,
            contentPadding: const EdgeInsets.only(left: 5),
            errorMaxLines: 5,
            suffixIcon: suffixWidget == null
                ? null
                : Container(
                    decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0))),
                    child: suffixWidget),
            prefixIcon: prefixIcon != null
                ? Container(
                    margin: const EdgeInsets.only(right: 3.0),
                    decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0))),
                    child: Icon(prefixIcon, color: AppColors.whiteColor))
                : null,
            hintText: hintText,
            labelStyle: const TextStyle(fontSize: 14.0),
            hintStyle: const TextStyle(
                fontSize: 14.0) /*,
            labelText: labelText*/
            ),
        enabled: isEnable,
        validator: validator,
        onChanged: onChange);
  }
}
