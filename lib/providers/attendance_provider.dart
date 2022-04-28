import 'package:historyar_app/helpers/constant_helpers.dart';
import 'package:historyar_app/model/attendance.dart';
import 'package:historyar_app/pages/main_menu_pages/lounge_page.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceProvider {
  Alert _alert = Alert();

  Future<List<Asistencia>> getAttendancesByLoungeId(int id) async {
    var response = await http.get(
        Uri.parse("${Constants.URL}/api/asistencias/sala/${id}"));

    var jsonData = json.decode(
        Utf8Decoder().convert(response.bodyBytes).toString()
    );

    List<Asistencia> asistencias = [];

    for (var aux in jsonData) {

      Asistencia asistencia = Asistencia(aux["id"],
          aux["usuario"]["nombres"],
          aux["numeroGrupo"],
          aux["nota"]);

      asistencias.add(asistencia);
    }

    return asistencias;
  }

  crear(String titulo,
      String descripcion,
      String password,
      int usuarioId,
      int type,
      BuildContext context) async{

    var date = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    Map data = {
      'titulo': titulo,
      'descripcion': descripcion,
      'password': password,
      'fechaCreacion': formatter.format(date),
      'usuario' : {
        'id' : usuarioId
      }
    };

    var bodyRequest = json.encode(data);

    var response = await http.post(
        Uri.parse("${Constants.URL}/api/salas/crear"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);

    if (response.statusCode == 201) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => Lounge(id: usuarioId, type: type))
      );
    } else {
      _alert.createAlert(
          context, "Algo salió mal", "No se ha podido publicar.",
          "aceptar");
    }
  }

}