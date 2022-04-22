import 'package:flutter/material.dart';
import 'package:historyar_app/pages/main_menu_pages/create_history.dart';
import 'package:historyar_app/utils/color_palette.dart';

ColorPalette _colorPalette = ColorPalette();

Widget historyarButtonApp(BuildContext context, bool isActive, int id, int type) => Padding(
    padding: EdgeInsets.only(top: 23.0),
    child: GestureDetector(
      child: Container(
        height: 56.0,
        width: 56.0,
        decoration: BoxDecoration(
          color: _colorPalette.lightBlue,
          border: Border.all(color: _colorPalette.lightBlue, width: 5.0),
          shape: BoxShape.circle,
        ),
        child: Container(
          height: 48.0,
          width: 48.0,
          decoration: BoxDecoration(
            color: isActive ? _colorPalette.yellow : _colorPalette.lightBlue,
            shape: BoxShape.circle,
          ),
          child: Image.asset('assets/logo.png', fit: BoxFit.cover),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateHistory(id: id, type: type),
            ));
      },
    ));
