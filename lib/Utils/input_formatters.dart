import 'package:flutter/services.dart';

class InputFormatters {
  InputFormatters._();
  static List<TextInputFormatter> mobileNumberFormatter() {
    return [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,11}'))];
  }

  static List<TextInputFormatter> cnicFormatter() {
    // Input Formatter for Pakistan CNIC Number
    // CNIC should be 13 digits long, formatted as 12345-1234567-1
    // The first 5 digits can be any number, the next 7 digits must be numeric,
    // and the last digit is a checksum digit.
    // This regex allows for the format 12345-1234567-1 or 1234512345671
    // and allows for optional dashes.
    return [FilteringTextInputFormatter.allow(RegExp(r'^\d{0,13}'))];
  }
}
