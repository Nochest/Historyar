import 'package:historyar_app/helpers/constant_helpers.dart';
import 'package:historyar_app/model/lounge.dart';
import 'package:historyar_app/model/story.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_participants.dart';
import 'package:historyar_app/pages/main_menu_pages/lounge_page.dart';
import 'package:historyar_app/pages/story_pages/my_stories.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoungeProvider {
  Alert _alert = Alert();

  Future<List<Sala>> getByUserId(int id, int type) async {
    var response = await http.get(
        Uri.parse("${Constants.URL}/api/salas/usuario/${id}"));

    var jsonData = json.decode(
        Utf8Decoder().convert(response.bodyBytes).toString()
    );

    List<Sala> salas = [];

    for (var aux in jsonData) {
      Sala sala = Sala(aux["id"],
          aux["titulo"],
          aux["descripcion"],
          aux["codigo"],
          aux["password"],
          aux["fechaCreacion"],
          aux["fechaFin"]);

      salas.add(sala);
    }

    return salas;
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

  getByCode(String code,
      String password,
      int usuarioId,
      int type,
      BuildContext context
      ) async {

    var existe = false;
    var asistenciaId = 0;
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    var selectedDate = DateTime.now();

    var response = await http.get(
        Uri.parse("${Constants.URL}/api/salas/code?code=${code}"));

    if(response.statusCode == 200) {

      var jsonData = json.decode(
          Utf8Decoder().convert(response.bodyBytes).toString()
      );

      if(password == jsonData["password"]) {

        for (var aux in jsonData["asistencias"]) {
          if (aux["usuario"]["id"] == usuarioId) {
            existe = true;
            asistenciaId = aux["id"];
          }
        }

        if (existe == false) {

          Map data = {
            "fecha": formatter.format(selectedDate),
            "numeroGrupo": 1,
            "usuario": {
              "id": usuarioId
            },
            "sala": {
              "id": jsonData["id"]
            }
          };

          var bodyRequest = json.encode(data);

          var asistencia = await http.post(
              Uri.parse("${Constants.URL}/api/asistencias/crear"),
              headers: {"Content-Type": "application/json"},
              body: bodyRequest);

          var asistenciaData = json.decode(
              Utf8Decoder().convert(asistencia.bodyBytes).toString()
          );

          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => LoungeParticipant(id: usuarioId, type: type,
                asistenciaId: asistenciaData["id"], salaId: jsonData["id"], salaName: jsonData["titulo"],))
          );

        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => LoungeParticipant(id: usuarioId, type: type,
                asistenciaId: asistenciaId, salaId: jsonData["id"], salaName: jsonData["titulo"],))
          );
        }

      } else {
        _alert.createAlert(
            context, "Algo salió mal", "la contraseña es incorrecta",
            "aceptar");
      }

    } else if (response.statusCode == 404) {
      _alert.createAlert(
          context, "No se encontró", "La sala con el código ${code} no existe",
          "aceptar");
    } else {
      _alert.createAlert(
          context, "Algo salió mal", "No se pudo encontrar la sala.",
          "aceptar");
    }

  }

}