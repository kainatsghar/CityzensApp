import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tcs_app/utils/app_colors.dart';

class CustomLoader extends StatelessWidget {
  final Color? color;

  const CustomLoader({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWave(size: 30, color: color ?? AppColors.primaryColor),
    );
  }
}
