import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcs_app/Utils/helper_function.dart';

class PushNotificationsManager extends StatefulWidget {
  final Widget child;

  const PushNotificationsManager({@required this.child, Key key})
      : super(key: key);

  @override
  _PushNotificationsManagerState createState() =>
      _PushNotificationsManagerState();
}

class _PushNotificationsManagerState extends State<PushNotificationsManager> {
  @override
  void initState() {
    HelperFunction.initializePushNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
