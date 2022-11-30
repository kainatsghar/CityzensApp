import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;
  final String title;
  final double appBarHeight;

  const CustomAppBar(
      {Key key, this.actions, this.title = '', this.appBarHeight = 56.0})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(48, 63, 159, 1.0),
        centerTitle: true,
        title: new Text('$title',
            style: TextStyle(fontSize: 22.0, fontStyle: FontStyle.italic)),
        actions: actions ?? [ Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('images/logo_appbar.png')
        )]);
  }
}
