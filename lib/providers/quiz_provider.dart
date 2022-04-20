import 'package:historyar_app/helpers/constant_helpers.dart';
import 'package:historyar_app/model/alternatives.dart';
import 'package:historyar_app/model/question.dart';
import 'package:historyar_app/model/quiz.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_detail.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  crear(String tema,
      String descripcion,
      int salaId,
      String salaName,
      int usuarioId,
      int type,
      BuildContext context) async{

    var date = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    Map data = {
      'tema': tema,
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

  Future<List<Pregunta>> getQuestionsByQuizId(
      int id
      ) async {

    print(id);

    var response = await http.get(
        Uri.parse("${Constants.URL}/api/preguntas/cuestionario/${id}"));

    print(response.statusCode);
    print(id);

    var jsonData = json.decode(
        Utf8Decoder().convert(response.bodyBytes).toString()
    );

    List<Pregunta> preguntas = [];

    for (var aux in jsonData) {
      List<Alternativa> alternativas = [];

      var jsonData2 = json.decode(
          Utf8Decoder().convert(aux["alternativas"]).toString()
      );

      for (var aux2 in jsonData2) {
        alternativas.add(Alternativa(aux["id"],
            aux["descripcion"],
            aux["correcto"]));
      }

      preguntas.add(Pregunta(aux["id"],
          aux["descripcion"],
          aux["correcto"],
          alternativas));
    }

    print(preguntas);
    return preguntas;
  }

  crearPregunta(String descripcion,
      int puntaje,
      int cuestionarioId,
      int salaId,
      String salaName,
      int usuarioId,
      int type,
      String alternativaA,
      bool correctoA,
      String alternativaB,
      bool correctoB,
      String alternativaC,
      bool correctoC,
      String alternativaD,
      bool correctoD,
      BuildContext context) async{

    var date = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    Map data = {
      'descripcion': descripcion,
      'puntaje': puntaje,
      'cuestionario' : {
        'id' : cuestionarioId
      },
      'alternativas': [
        {
          "descripcion": alternativaA,
          "correcto": correctoA
        },
        {
          "descripcion": alternativaB,
          "correcto": correctoB
        },
        {
          "descripcion": alternativaC,
          "correcto": correctoC
        },
        {
          "descripcion": alternativaD,
          "correcto": correctoD
        }
      ]
    };

    print(data);
    var bodyRequest = json.encode(data);

    var response = await http.post(
        Uri.parse("${Constants.URL}/api/preguntas/crear"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);

    print(response.statusCode);

    if (response.statusCode == 201) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => LoungeDetail(id: usuarioId, type: type, salaName: salaName, salaId: salaId,))
      );
    } else {
      _alert.createAlert(
          context, "Algo salió mal", "No se ha podido cargar la pregunta.",
          "aceptar");
    }
  }

}