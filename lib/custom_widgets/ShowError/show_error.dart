import 'package:flutter/material.dart';
import 'package:tcs_app/custom_widgets/CustomAppButton/custom_app_button.dart';

import '../../Utils/app_constants.dart';

class ShowError extends StatelessWidget {
  final String? errorText;
  final bool showRetryOption;
  final bool showErrorMsg;

  final VoidCallback? onTap;

  const ShowError({
    super.key,
    this.errorText,
    this.showRetryOption = false,
    this.showErrorMsg = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/error-found.png',
            height: size.width * 0.5,
            width: size.width * 0.7,
            fit: BoxFit.cover,
          ),
          Visibility(
            visible: showErrorMsg,
            child: Text(
              errorText ?? AppConstants.exceptionMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (showRetryOption) //if (showRetryOption && onTap != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomAppButton(onTap: onTap!, buttonTitle: 'Retry'),
            ),
        ],
      ),
    );
  }
}
