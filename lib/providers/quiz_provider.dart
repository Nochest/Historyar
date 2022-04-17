import 'package:historyar_app/helpers/constant_helpers.dart';
import 'package:historyar_app/model/attendance.dart';
import 'package:historyar_app/model/lounge.dart';
import 'package:historyar_app/model/quiz.dart';
import 'package:historyar_app/model/story.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_detail.dart';
import 'package:historyar_app/pages/main_menu_pages/lounge_page.dart';
import 'package:historyar_app/pages/story_pages/my_stories.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizProvider {
  Alert _alert = Alert();

  Future<Cuestionario?> getQuizByLoungeId(int id) async {
    var response = await http.get(
        Uri.parse("${Constants.URL}/api/cuestionarios/sala/${id}"));

    var jsonData = json.decode(
        Utf8Decoder().convert(response.bodyBytes).toString()
    );

    if (response.statusCode == 200) {
      Cuestionario cuestionario = Cuestionario(
          jsonData["id"],
          jsonData["tema"],
          jsonData["descripcion"]);

      return cuestionario;
    } else {
      return null;
    }
  }

  crear(String titulo,
      String descripcion,
      int salaId,
      String salaName,
      int usuarioId,
      int type,
      BuildContext context) async{

    var date = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    Map data = {
      'titulo': titulo,
      'descripcion': descripcion,
      'sala' : {
        'id' : salaId
      }
    };

    var bodyRequest = json.encode(data);

    var response = await http.post(
        Uri.parse("${Constants.URL}/api/cuestionarios/crear"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);

    print(response.statusCode);

    if (response.statusCode == 201) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => LoungeDetail(id: usuarioId, type: type, salaName: salaName, salaId: salaId,))
      );
    } else {
      _alert.createAlert(
          context, "Algo salió mal", "No se ha podido publicar.",
          "aceptar");
    }
  }

}