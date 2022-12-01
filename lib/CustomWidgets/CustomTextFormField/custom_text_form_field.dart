import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final IconData prefixIcon;
  final Widget suffixWidget;
  final String hintText;
  final bool isEnable, obscureText;
  final TextInputType inputType;
  final TextEditingController controller;
  final FocusNode node;
  final ValueChanged<String> onChange;
  final TextInputAction inputAction;
  final bool readOnly;
  final Function() onTap;
  final int maxLines;
  final FormFieldValidator<String> validator;

  final AutovalidateMode autoValidateMode;
  final String labelText;
  final List<TextInputFormatter> inputFormatter;
  final bool isDense;
  final TextCapitalization textCapitalization;

  const CustomTextFormField(
      {Key key,
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
      this.textCapitalization})
      : super(key: key);

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
        readOnly: readOnly,
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
            isDense: isDense,
            enabled: isEnable,
            contentPadding: EdgeInsets.only(left: 12, top: 18, bottom: 18),
            errorMaxLines: 5,
            suffixIcon: suffixWidget,
            prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
            hintText: hintText,
            labelStyle: TextStyle(fontSize: 14.0),
            hintStyle: TextStyle(fontSize: 14.0),
            labelText: labelText),
        enabled: isEnable,
        validator: validator,
        onChanged: onChange);
  }
}
