import 'package:flutter/material.dart';
import 'package:tcs_app/CustomWidgets/CustomLoader/custom_loading_widget.dart';
import '../../Routes/app_navigation.dart';

class DialogBuilder {
  static showLoadingIndicator() => showDialog(
        context: AppNavigation.currentContext!,
        barrierDismissible: false,
        // ignore: deprecated_member_use
        builder: (BuildContext context) => WillPopScope(
          onWillPop: () async => false,
          child: const CustomLoadingWidget(),
        ),
      );

  static void hideOpenDialog() => AppNavigation.goBack();
}
