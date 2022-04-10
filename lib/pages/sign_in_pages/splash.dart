import 'dart:async';

import 'package:flutter/material.dart';
import 'package:historyar_app/pages/sign_in_pages/sign_in.dart';

import 'package:historyar_app/utils/color_palette.dart';

class Splash extends StatelessWidget {
  final _colors = ColorPalette();

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => SignIn())));
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: _colors.lightBlue,
      child: Padding(
        padding: const EdgeInsets.only(top: 48),
        child: Image(
          image: AssetImage('assets/logo.png'),
          height: 300,
          width: 300,
        ),
      ),
    );
  }
}
