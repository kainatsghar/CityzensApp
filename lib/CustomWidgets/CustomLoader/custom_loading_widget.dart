import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      const Opacity(
          opacity: 0.2,
          child: ModalBarrier(dismissible: false, color: Colors.transparent)),
      Center(
          child: SpinKitWave(
              size: 30,
              itemBuilder: (BuildContext context, int index) {
                return DecoratedBox(
                    decoration: BoxDecoration(color: Colors.amber));
              }))
    ]);
  }
}
