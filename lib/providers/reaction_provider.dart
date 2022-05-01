import 'package:historyar_app/helpers/constant_helpers.dart';
import 'package:historyar_app/model/attendance.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_participants_story_detail.dart';
import 'package:historyar_app/pages/main_menu_pages/lounge_page.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReactionProvider {
  Alert _alert = Alert();

  Future<List<int>> getReactionsByHistoriaId(int historiaId) async {
    var response = await http.get(
        Uri.parse("${Constants.URL}/api/reacciones/historia/${historiaId}"));

    var jsonData = json.decode(
        Utf8Decoder().convert(response.bodyBytes).toString()
    );

    List<int> reacciones = [0, 0, 0, 0, 0];

    for(var aux in jsonData) {
      if(aux["reaccion"] == 1)
        reacciones[0]++;
      else if(aux["reaccion"] == 2)
        reacciones[1]++;
      else if(aux["reaccion"] == 3)
        reacciones[2]++;
      else if(aux["reaccion"] == 4)
        reacciones[3]++;
      else
        reacciones[4]++;
    }

    return reacciones;
  }

  Future<int> getReactionByUserIdAndHistoriaId(int usuarioId,
      int historiaId) async {
    var response = await http.get(
        Uri.parse("${Constants.URL}/api/reacciones/usuario-historia?usuarioId=${usuarioId}&historiaId=${historiaId}"));

    print(usuarioId);
    print(historiaId);
    print(response.statusCode);

    if (response.statusCode == 200) {

      var jsonData = json.decode(
          Utf8Decoder().convert(response.bodyBytes).toString()
      );


      return jsonData["reaccion"];
    } else {
      return 3;
    }
  }

  guardar(int usuarioId,
      int historiaId,
      int type,
      int reaccion,
      int salaId,
      String salaName,
      int asistenciaId,
      bool isguest,
      BuildContext context) async{

    var get = await http.get(
        Uri.parse("${Constants.URL}/api/reacciones/usuario-historia?usuarioId=${usuarioId}&historiaId=${historiaId}"));

    if (get.statusCode == 200) {
      Map data = {
        'reaccion': reaccion,
      };

      var bodyRequest = json.encode(data);

      var jsonData = json.decode(
          Utf8Decoder().convert(get.bodyBytes).toString()
      );

      var response = await http.put(
          Uri.parse("${Constants.URL}/api/reacciones/editar/${jsonData["id"]}"),
          headers: {"Content-Type": "application/json"},
          body: bodyRequest);

      if (response.statusCode == 200) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => LoungeParticipantStoryDetail(id: usuarioId,
              type: type, historiaId: historiaId, salaId: salaId, asistenciaId: asistenciaId, salaName: salaName, isguest: isguest,))
        );
      } else {
        _alert.createAlert(
            context, "Algo salió mal", "No se ha podido editar reacción.",
            "aceptar");
      }
    } else {
      Map data = {
        'usuario' : {
          'id' : usuarioId
        },
        'historia' : {
          'id' : historiaId
        },
        'reaccion': reaccion,
      };

      var bodyRequest = json.encode(data);

      var response = await http.post(
          Uri.parse("${Constants.URL}/api/reacciones/crear"),
          headers: {"Content-Type": "application/json"},
          body: bodyRequest);

      if (response.statusCode == 201) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => LoungeParticipantStoryDetail(id: usuarioId,
              type: type, historiaId: historiaId, salaId: salaId, asistenciaId: asistenciaId, salaName: salaName,isguest: isguest,))
        );
      } else {
        _alert.createAlert(
            context, "Algo salió mal", "No se ha podido reaccionar.",
            "aceptar");
      }
    }

  }

}