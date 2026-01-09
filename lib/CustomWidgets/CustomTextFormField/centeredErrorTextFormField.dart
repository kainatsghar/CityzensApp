import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class CenteredErrorTextFormField extends StatelessWidget {
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String labelText;
  final Function(String)? onChanged;
  final TextAlign textAlign;

  const CenteredErrorTextFormField({
    super.key,
    required this.labelText,
    this.validator,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: validator,
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color.fromARGB(255, 240, 240, 240),
              ),
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                style: TextStyle(
                  color: AppColors.primaryTitleColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: textAlign,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                onChanged: (val) {
                  field.didChange(val);
                  onChanged?.call(val);
                },
                decoration: InputDecoration(
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text(labelText, textAlign: TextAlign.center)],
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  labelStyle: const TextStyle(
                    color: AppColors.primaryTitleColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),

            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  field.errorText!,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        );
      },
    );
  }
}
