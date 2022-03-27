import 'package:flutter/material.dart';
import 'package:historyar_app/pages/sign_in_pages/sign_in.dart';
import 'package:historyar_app/utils/color_palette.dart';

class SuccessReset extends StatefulWidget {
  @override
  _SuccessResetState createState() => _SuccessResetState();
}

class _SuccessResetState extends State<SuccessReset> {

  ColorPalette _colorPalette = ColorPalette();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        color: _colorPalette.cream,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 24.0, left: 25.0),
                child: Text(
                  'Contraseña Recuperada',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: _colorPalette.yellow,
                      fontSize: 32.0),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 24.0),
              child: Text(
                'Se ha enviado su nueva contraseña a su correo.\nGracias',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: _colorPalette.darkBlue,
                    fontSize: 15.0),
                textAlign: TextAlign.start,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 22.0, bottom: 40.0),
                child: Center(
                  child: MaterialButton(
                      height: 48.0,
                      minWidth: 170.0,
                      color: _colorPalette.lightBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0)),
                      child: Text('Continuar',
                          style: TextStyle(
                              color: _colorPalette.yellow, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => SignIn()));

                      }),
                )
            )
          ],
        ),
      ),
    );
  }
}
