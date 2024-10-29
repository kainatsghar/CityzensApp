import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Stack(children: <Widget>[
      Opacity(
          opacity: 0.2,
          child: ModalBarrier(dismissible: false, color: Colors.transparent)),
      Center(child: SpinKitWave(size: 30, color: AppColors.secondaryColor))
    ]);
  }
}
