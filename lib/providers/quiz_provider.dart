import 'package:historyar_app/helpers/constant_helpers.dart';
import 'package:historyar_app/model/alternatives.dart';
import 'package:historyar_app/model/question.dart';
import 'package:historyar_app/model/quiz.dart';
import 'package:historyar_app/model/quiz_models/quiz_model.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_detail.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_participants.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class QuizProvider {
  Alert _alert = Alert();

  Future<Cuestionario?> getQuizByLoungeId(int id) async {
    var response = await http
        .get(Uri.parse("${Constants.URL}/api/cuestionarios/sala/${id}"));

    var jsonData =
        json.decode(Utf8Decoder().convert(response.bodyBytes).toString());

    if (response.statusCode == 200) {
      Cuestionario cuestionario = Cuestionario(
          jsonData["id"], jsonData["tema"], jsonData["descripcion"]);

      return cuestionario;
    } else {
      return null;
    }
  }

  Future<Quiz> getQuiz(int id) async {
    Quiz? quiz;
    final response = await http
        .get(Uri.parse("${Constants.URL}/api/cuestionarios/sala/${id}"));
    if (response.statusCode == 200) {
      quiz = Quiz.fromJson(Utf8Decoder().convert(response.bodyBytes));
      return quiz;
    } else {
      throw Exception('Failed to find a quiz for this lounge');
    }
  }

  crear(String tema, String descripcion, int salaId, String salaName,
      int usuarioId, int type, bool isguest, BuildContext context) async {
    var date = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    Map data = {
      'tema': tema,
      'descripcion': descripcion,
      'sala': {'id': salaId}
    };

    var bodyRequest = json.encode(data);

    var response = await http.post(
        Uri.parse("${Constants.URL}/api/cuestionarios/crear"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);

    if (response.statusCode == 201) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => LoungeDetail(
                id: usuarioId,
                type: type,
                salaName: salaName,
                salaId: salaId,
                isguest: isguest,
              )));
    } else {
      _alert.createAlert(
          context, "Algo salió mal", "No se ha podido publicar.", "aceptar");
    }
  }

  Future<List<Pregunta>> getQuestionsByQuizId(int id) async {
    var response = await http
        .get(Uri.parse("${Constants.URL}/api/preguntas/cuestionario/${id}"));

    var jsonData =
        json.decode(Utf8Decoder().convert(response.bodyBytes).toString());

    print(response.statusCode);

    List<Pregunta> preguntas = [];
    try {
      for (var aux in jsonData) {
        List<Alternativa> alternativas = [];
        for (var aux2 in aux["alternativas"]) {
          alternativas.add(
              Alternativa(aux2["id"], aux2["descripcion"], aux2["correcto"]));
        }
        preguntas.add(Pregunta(
            aux["id"], aux["descripcion"], aux["puntaje"], alternativas));
      }
    } on Exception catch (exception) {
      print(exception);
    } catch (error) {
      print(error);
    }

    return preguntas;
  }

  crearPregunta(
      String descripcion,
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
      bool isguest,
      BuildContext context) async {
    var date = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');

    Map data = {
      'descripcion': descripcion,
      'puntaje': puntaje,
      'cuestionario': {'id': cuestionarioId},
      'alternativas': [
        {"descripcion": alternativaA, "correcto": correctoA},
        {"descripcion": alternativaB, "correcto": correctoB},
        {"descripcion": alternativaC, "correcto": correctoC},
        {"descripcion": alternativaD, "correcto": correctoD}
      ]
    };

    var bodyRequest = json.encode(data);

    var response = await http.post(
        Uri.parse("${Constants.URL}/api/preguntas/crear"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);

    if (response.statusCode == 201) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => LoungeDetail(
                id: usuarioId,
                type: type,
                salaName: salaName,
                salaId: salaId,
                isguest: isguest,
              )));
    } else {
      _alert.createAlert(context, "Algo salió mal",
          "No se ha podido cargar la pregunta.", "aceptar");
    }
  }

  responder(
      int id,
      List<int> respuestas,
      int usuarioId,
      int type,
      int salaId,
      String salaName,
      int asistenciaId,
      bool isguest,
      BuildContext context) async {

    var getAsistente = await http.get(
        Uri.parse("${Constants.URL}/api/asistencias/${asistenciaId}"));

    var dataAsistente = json.decode(
        Utf8Decoder().convert(getAsistente.bodyBytes).toString()
    );

    double nota = 0;

    var response = await http
        .get(Uri.parse("${Constants.URL}/api/preguntas/cuestionario/${id}"));

    var jsonData =
    json.decode(Utf8Decoder().convert(response.bodyBytes).toString());

    List<Alternativa> alternativas = [];

    for (var aux in jsonData) {
      for (var aux2 in aux["alternativas"]) {
        alternativas.add(
            Alternativa(aux2["id"], aux["puntaje"].toString(), aux2["correcto"]));
      }
    }

    for (var aux in alternativas) {
      if(respuestas.contains(aux.id) && aux.correcto == true)
        nota += double.parse(aux.descripcion);

    }
    print(nota);

    Map data = {
      'numeroGrupo': dataAsistente["numeroGrupo"],
      'nota': nota,
    };

    var bodyRequest = json.encode(data);

    var editar = await http.put(
        Uri.parse("${Constants.URL}/api/asistencias/editar/${asistenciaId}"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);

    if (editar.statusCode == 200) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => LoungeParticipant(
            id: usuarioId,
            type: type,
            salaName: salaName,
            salaId: salaId,
            asistenciaId: asistenciaId,
            isguest: isguest,
          )));
    } else {
      _alert.createAlert(context, "Algo salió mal",
          "No se ha responder el cuestionario.", "aceptar");
    }
  }


}
