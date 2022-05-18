import 'package:flutter/material.dart';
import 'package:historyar_app/utils/color_palette.dart';

class Alert {
  ColorPalette _colorPalette = ColorPalette();

  void createAlert(
      BuildContext context, String cabezera, String body, String button_text) {
    showDialog(
        barrierColor: _colorPalette.lightBlue.withOpacity(0.6),
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: Padding(
                padding: EdgeInsets.only(top: 32),
                child: Center(
                    child: Text(cabezera,
                        style: TextStyle(
                            color: _colorPalette.darkBlue,
                            fontWeight: FontWeight.w700,
                            fontSize: 24.0)))),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: SingleChildScrollView(
                          child: Text(body,
                              style: TextStyle(
                                  color: _colorPalette.text,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0),
                              textAlign: TextAlign.justify))),
                  Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 16.0),
                      child: default_button(context, button_text))
                ],
              ),
            ),
          );
        });
  }

  Widget default_button(BuildContext context, String text) {
    return MaterialButton(
        height: 36.0,
        minWidth: 126.0,
        color: _colorPalette.lightBlue,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
        child: Text(text,
            style: TextStyle(
                color: _colorPalette.text, fontWeight: FontWeight.w600)),
        onPressed: () {
          Navigator.of(context).pop();
        });
  }
}
