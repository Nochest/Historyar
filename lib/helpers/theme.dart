import 'package:flutter/material.dart';

class AppTheme {
  ThemeData themeDataLight = ThemeData.light().copyWith(
      primaryColor: Color(0xff11a0d9),
      scaffoldBackgroundColor: Color(0xfff2e5d5),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Color(0xff1f82bf))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Color(0xff1f82bf))),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Color(0xff1f82bf))),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: Color(0xff1f82bf))),
      ));
}
