import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CenteredErrorTextFormField extends StatelessWidget {
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String hintText;
  final Function(String)? onChanged;

  const CenteredErrorTextFormField({
    super.key,
    required this.hintText,
    this.validator,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color.fromARGB(255, 240, 240, 240),
              ),
              child: TextFormField(
                canRequestFocus: true,
                controller: controller,
                textAlign: TextAlign.center,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                onChanged: (val) {
                  field.didChange(val);
                  if (onChanged != null) onChanged!(val);
                },
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: Color.fromARGB(255, 204, 204, 204),
                    fontSize: 20,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),

            // Center-aligned error text
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
