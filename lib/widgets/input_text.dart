import 'package:flutter/material.dart';
import 'package:historyar_app/utils/color_palette.dart';

class InputText {
  ColorPalette _colorPalette = ColorPalette();

  Widget defaultIText(
      FocusNode focus,
      TextEditingController controller,
      TextInputType type,
      String label,
      String submited,
      bool lock,
      String field,
      bool submit) {
    return TextFormField(
      focusNode: focus,
      controller: controller,
      obscureText: lock,
      keyboardType: type,
      style: TextStyle(
        color: _colorPalette.text,
      ),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: _colorPalette.darkBlue)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: _colorPalette.darkBlue)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: _colorPalette.error)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: BorderSide(color: _colorPalette.error)),
        errorText: submit ? validate(controller.text, field) : null,
        labelText: label,
        labelStyle: TextStyle(
          color: focus.hasFocus || controller.text.isNotEmpty
              ? _colorPalette.yellow
              : _colorPalette.text,
          fontWeight: focus.hasFocus || controller.text.isNotEmpty
              ? FontWeight.w600
              : FontWeight.normal,
        ),
      ),
      onChanged: (valor) {
        submited = valor;
      },
    );
  }
}

String validate(String value, String field) {
  if (value.isEmpty) return '$field no debe estar vacío';
  return '';
}
