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
    var response = await http.get(
        Uri.parse("${Constants.URL}/api/preguntas/cuestionario/${id}"));

    var jsonData = json.decode(
        Utf8Decoder().convert(response.bodyBytes).toString()
    );

    print(response.statusCode);

    List<Pregunta> preguntas = [];
    try{
    for (var aux in jsonData) {
      List<Alternativa> alternativas = [];
      for (var aux2 in aux["alternativas"]) {
        alternativas.add(Alternativa(aux2["id"],
            aux2["descripcion"],
            aux2["correcto"]));
      }
        preguntas.add(Pregunta(aux["id"],
            aux["descripcion"],
            aux["puntaje"],
            alternativas));

    } } on Exception catch (exception) {
  print(exception);
  } catch (error) {
      print(error);
  }


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


    var bodyRequest = json.encode(data);

    var response = await http.post(
        Uri.parse("${Constants.URL}/api/preguntas/crear"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);

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