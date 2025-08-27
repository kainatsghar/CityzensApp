import 'package:flutter/material.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class SuccessDialogBox extends StatefulWidget {
  final String title, description, buttonText;
  final Image? image;

  const SuccessDialogBox({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    this.image,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SuccessDialogBoxState createState() => _SuccessDialogBoxState();
}

class _SuccessDialogBoxState extends State<SuccessDialogBox> {
  @override
  Widget build(BuildContext context) {
    dialogContent(BuildContext context) {
      return Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              top: Const.avatarRadius + Const.padding,
              bottom: Const.padding,
              left: Const.padding,
              right: Const.padding,
            ),
            margin: const EdgeInsets.only(top: Const.avatarRadius),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Const.padding),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () => AppNavigation.goBack(),
                    child: Text(
                      widget.buttonText,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: Const.padding,
            right: Const.padding,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: Const.avatarRadius,
              child: Image.asset('assets/images/icon_success.png'),
            ),
          ),
        ],
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Const.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

class Const {
  Const._();

  static const double padding = 16.0;
  static const double avatarRadius = 50.0;
}
