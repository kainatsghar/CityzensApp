import 'package:flutter/material.dart';

class CustomDashboardButton extends StatelessWidget {
  final VoidCallback onTap;
  final String imageName;
  final String buttonTitle;

  const CustomDashboardButton(
      {Key key, this.onTap, this.imageName, this.buttonTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/$imageName',
                  height: size.width * 0.22,
                  width: size.width * 0.22,
                ),
                Padding(padding: EdgeInsets.all(5.0)),
                Text('$buttonTitle',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600))
              ]),
        ),
      ),
    );
  }
}
