import 'package:flutter/material.dart';
import 'package:tcs_app/Routes/app_navigation.dart';

class SuccessDialogBox extends StatefulWidget {
  final String title, description, buttonText;
  final Image image;

  SuccessDialogBox({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.image,
  });

  @override
  _SuccessDialogBoxState createState() => _SuccessDialogBoxState();
}

class _SuccessDialogBoxState extends State<SuccessDialogBox> {
  @override
  Widget build(BuildContext context) {
    dialogContent(BuildContext context) {
      return Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              top: Const.avatarRadius + Const.padding,
              bottom: Const.padding,
              left: Const.padding,
              right: Const.padding,
            ),
            margin: EdgeInsets.only(top: Const.avatarRadius),
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(Const.padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () => AppNavigation.goBack(),
                    child: Text(
                      widget.buttonText,
                      style: TextStyle(fontSize: 16.0),
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
              child: Image.asset('images/icon_success.png'),
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
