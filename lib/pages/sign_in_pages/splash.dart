import 'package:flutter/material.dart';

import 'package:historyar_app/utils/color_palette.dart';

class Splash extends StatelessWidget {
  final _colors = ColorPalette();

  @override
  Widget build(BuildContext context) {
    /* Timer(
        Duration(seconds: 20),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => SignIn())));*/
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: _colors.lightBlue,
      child: Padding(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/splash/historyar_name.png'),
              width: double.maxFinite,
              height: 300,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
