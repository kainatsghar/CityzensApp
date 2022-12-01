import 'package:flutter/cupertino.dart';
import 'package:tcs_app/Utils/app_colors.dart';

class CustomAppButton extends StatelessWidget {
  final String buttonTitle;
  final VoidCallback onTap;

  const CustomAppButton({Key key, this.buttonTitle, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        color: AppColors.primaryColor,
        pressedOpacity: 0.8,
        child: Text('$buttonTitle',
            style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
                color: AppColors.whiteColor)),
        onPressed: onTap);
  }
}
