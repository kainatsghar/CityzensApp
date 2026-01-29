import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tcs_app/utils/app_colors.dart';

dynamic showToast(String message, {Color? color}) => Fluttertoast.showToast(
  msg: message,
  toastLength: Toast.LENGTH_LONG,
  gravity: ToastGravity.BOTTOM,
  backgroundColor: color ?? AppColors.successGreenColor,
  textColor: AppColors.whiteColor,
);
