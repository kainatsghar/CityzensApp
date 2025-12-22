import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tcs_app/CustomWidgets/CustomBottomSheets/imagepicker_bottom_sheet.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/model/Options/options.dart';
import 'package:url_launcher/url_launcher.dart';

class HelperFunction {
  static List<Options> userTypes() => [
    Options(title: 'Student', value: 1),
    Options(title: 'Parent', value: 2),
    Options(title: 'Teacher', value: 3),
  ];

  static List<Options> attendanceOptions() => [
    Options(
      title: 'Present',
      isSelected: true,
      color: AppColors.successGreenColor,
      value: 1,
    ),
    Options(
      title: 'Absent',
      isSelected: false,
      color: AppColors.valuesRedColors,
      value: 2,
    ),
    Options(title: 'Leave', isSelected: false, color: Colors.amber, value: 3),
    Options(
      title: 'Unreconciled',
      isSelected: false,
      color: Colors.grey,
      value: 35,
    ),
  ];

  static Future<void> launchURL(String url) async {
    final uri = Uri.parse(url.trim());

    // Decide launch mode automatically
    final bool isExternal =
        uri.scheme == 'http' || uri.scheme == 'https' || uri.scheme == 'mailto';

    // Try launching directly (more reliable than canLaunchUrl)
    try {
      await launchUrl(
        uri,
        mode: isExternal
            ? LaunchMode
                  .externalApplication // Chrome/Safari/Gmail
            : LaunchMode.platformDefault,
      );
    } catch (e) {
      throw 'Could not launch $url';
    }
  }

  static Future<DateTime?> openDatePicker({
    required TextEditingController filterDate,
  }) async {
    DateTime now = DateTime.now();
    DateTime initialDate = DateTime(now.year - 3, now.month, now.day);
    final DateTime? picked = await showDatePicker(
      context: AppNavigation.currentContext!,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: initialDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (ctx, child) => child!,
    );
    if (picked != null) {
      filterDate.text = dateFormatter('$picked', format: 'dd-MMM-yyyy');
    }
    return picked;
  }

  static List<Options> genderOptions() => [
    Options(title: 'Male', value: 1),
    Options(title: 'Female', value: 2),
  ];

  static List<Options> previousSchoolOptions() => [
    Options(title: 'Yes', value: 1),
    Options(title: 'No', value: 0),
  ];

  static String dateFormatter(String? date, {String? format}) =>
      date == null || date == '' || date == 'null'
      ? '-'
      : DateFormat(format ?? 'MMMM dd, yyyy').format(DateTime.parse(date));

  static void imagePickerBottomSheet() {
    showModalBottomSheet(
      context: AppNavigation.currentContext!,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => const ImagePickerBottomSheet(),
    );
  }

  static String numberValue(dynamic number) =>
      number == null || number == '-' || '$number'.isEmpty || number == 'null'
      ? '-'
      : NumberFormat.decimalPattern().format(
          num.parse(
            removeTrailingZero(num.parse('$number').toStringAsFixed(2)),
          ),
        );

  static String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return "Required*";
    } else {
      return null;
    }
  }

  static Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor!;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.id;
    }
  }

  static String removeTrailingZero(String string) {
    if (!string.contains('.')) {
      return string;
    }
    string = string.replaceAll(RegExp(r'0*$'), '');
    if (string.endsWith('.')) {
      string = string.substring(0, string.length - 1);
    }
    return string;
  }

  static String noNullStringText(String? value) {
    if (value == 'null' || value == null || value.isEmpty || value == '-') {
      return '-';
    } else {
      return value;
    }
  }

  /// Formats a double value into a currency string (e.g. "PKR 38,370")
  String formatCurrency(
    double amount, {
    String symbol = 'PKR ',
    int decimalDigits = 0,
  }) {
    final format = NumberFormat.currency(
      locale: 'en_PK', // Locale for Pakistan (adjust if needed)
      symbol: symbol, // You can pass '₨ ' or '' for no symbol
      decimalDigits: decimalDigits,
    );
    return format.format(amount);
  }

  static Future<void> sendEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      // query: encodeQueryParameters(<String, String>{'subject': 'App Feedback'}),
    );

    await launchUrl(emailLaunchUri);
  }

  static String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  static String userType(AppUserType type) {
    switch (type) {
      case AppUserType.student:
        return "Student";
      case AppUserType.parent:
        return "Parent";
      case AppUserType.teacher:
        return "Teacher";
    }
  }
}

enum AppUserType { student, parent, teacher }
