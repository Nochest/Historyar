import 'package:flutter/material.dart';

import 'alert.dart';
import 'color_palette.dart';

class DataPicker {
  String _fecha = '';
  var _alert = Alert();

  selectDate(BuildContext context) async {
    DateTime? pick = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime(2050),
      locale: Locale('es', 'ES'),
    );
  }

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
