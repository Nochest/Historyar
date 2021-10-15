import 'dart:async';

import 'package:flutter/material.dart';
import 'package:historyar_app/pages/sign_in_pages/sign_in.dart';
import 'package:historyar_app/utils/color_palette.dart';

class Splash extends StatelessWidget {
  ColorPalette _colorPalette = ColorPalette();

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 5), () => Navigator.of(context).pushReplacement(MaterialPageRoute( builder: (BuildContext context) => SignIn()))
    );
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: double.maxFinite,
          height: double.maxFinite,
          color: _colorPalette.lightBlue,
          child: Image.asset('assets/logo.png', width: MediaQuery.of(context).size.width  - 180.0 , height: MediaQuery.of(context).size.height  - 240.0)
        )
      )
    );
  }
}
