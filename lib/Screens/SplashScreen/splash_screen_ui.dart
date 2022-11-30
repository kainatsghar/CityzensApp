import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';

class SplashScreenUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SplashScreenUIState();
  }
}

class SplashScreenUIState extends State<SplashScreenUI>
    with SingleTickerProviderStateMixin {
  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;

  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    _iconAnimation = new CurvedAnimation(
        parent: _iconAnimationController, curve: Curves.linear);
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
    Future.delayed(Duration(seconds: 3),
        () => AppNavigation.pushReplacementTo(AppNavRoutes.authWrapperRoute));
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
        backgroundColor: Color.fromRGBO(48, 63, 159, 1.0),
        body: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Container(
              child: new Center(
                  child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Image.asset(
                    'images/logo.png',
                    width: _iconAnimation.value * size.width / 2.2,
                    height: _iconAnimation.value * size.width / 2.2,
                  ),
                  new Text(
                    ' W E L C O M E ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500),
                  )
                ],
              )),
            ),
          ],
        ));
  }
}
