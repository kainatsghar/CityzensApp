import 'package:flutter/material.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';

import '../../Utils/app_constants.dart';

class ShowError extends StatelessWidget {
  final String errorText;
  final bool showRetryOption;
  final bool showErrorMsg;

  final VoidCallback onTap;

  const ShowError(
      {Key key,
      this.errorText,
      this.showRetryOption = false,
      this.showErrorMsg = false,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(25),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset('images/error-found.png',
              height: size.width * 0.5,
              width: size.width * 0.7,
              fit: BoxFit.cover),
          Visibility(
            visible: showErrorMsg,
            child: Text(errorText ?? AppConstants.exceptionMessage,
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
          ),
          if (showRetryOption)
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomAppButton(onTap: onTap, buttonTitle: 'Retry'))
        ]));
  }
}
