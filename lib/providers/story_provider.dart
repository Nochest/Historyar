import 'dart:developer';
import 'dart:io';

import 'package:historyar_app/helpers/constant_helpers.dart';
import 'package:historyar_app/model/story.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_story_list.dart';
import 'package:historyar_app/pages/story_pages/my_stories.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoryProvider {
  Alert _alert = Alert();

  Future<List<Historia>> getByUserId(int id, int type) async {
    var response = await http.get(
        Uri.parse("${Constants.URL}/api/historias/usuario/${id}"));

    print(response.statusCode);
    print(id);

    var jsonData = json.decode(
        Utf8Decoder().convert(response.bodyBytes).toString()
    );

    List<Historia> historias = [];

    for (var aux in jsonData) {
      Historia historia = Historia(aux["id"],
          aux["nombre"],
          aux["url"],
          aux["descripcion"],
          aux["favorito"],
          "",
          0,
          "");

      historias.add(historia);
    }

    return historias;
  }

  Future<List<Historia>> getByLoungeId(int salaId, int type) async {
    var response = await http.get(
        Uri.parse("${Constants.URL}/api/historias/sala/${salaId}"));

    var jsonData = json.decode(
        Utf8Decoder().convert(response.bodyBytes).toString()
    );

    List<Historia> historias = [];

    print(response.statusCode);

    for (var aux in jsonData) {
      Historia historia = Historia(aux["id"],
          aux["nombre"],
          aux["url"],
          aux["descripcion"],
          aux["favorito"],
          aux["usuario"]["nombres"] + " " + aux["usuario"]["apellidos"],
          0,
          "");

      historias.add(historia);
    }

    return historias;
  }

  Future<Historia?> getById(int id) async {
    var response = await http.get(
        Uri.parse("${Constants.URL}/api/historias/${id}"));

    var jsonData = json.decode(
        Utf8Decoder().convert(response.bodyBytes).toString()
    );

    print(response.statusCode);

    if (response.statusCode == 200) {

      var puntaje = 0;
      var comentario = "";

      if(jsonData["puntaje"] != null)
        puntaje = jsonData["puntaje"];

      if(jsonData["comentario"] != null)
        comentario = jsonData["comentario"];

      Historia historia = Historia(
          jsonData["id"],
          jsonData["nombre"],
          jsonData["url"],
          jsonData["descripcion"],
          false,
          "",
          puntaje,
          comentario);

      return historia;
    } else {
      return null;
    }
  }

  Future<String> getUrl(int id) async  {

    var response = await http.get(
        Uri.parse("${Constants.URL}/api/historias/url/${id}"));

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {

      return response.body;
    } else {
      return "hola";
    }
  }

  deleteHistoria(int id,
      int historiaId,
      int type,
      BuildContext context) async {
    print(historiaId);

    var response = await http.delete(
        Uri.parse("${Constants.URL}/api/historias/eliminar/${historiaId}"));

    print(response.statusCode);

    if (response.statusCode == 200) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => MyStories(id: id, type: type))
      );
    } else{
      _alert.createAlert(
          context, "Algo salió mal", "No se ha podido eliminar la historia.",
          "Aceptar");
    }
  }

  registerS3(int usuarioId, int? salaId, String nombre, String descripcion, File video, BuildContext context) async {

    print(salaId);

    if(salaId == null)
      salaId = 0;

    try {
      var request = http.MultipartRequest("POST",
          Uri.parse("${Constants.URL}/api/historias/crear-s3/?usuarioId=${usuarioId}&salaId=${salaId}"));

      //request.fields["usuarioId"] = usuarioId.toString();
      //request.fields["salaId"] = salaId.toString();

      request.fields["nombre"] = nombre;
      request.fields["descripcion"] = descripcion;

      var pic = await http.MultipartFile.fromPath("file", video.path);

      request.files.add(pic);

      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      log("respuesta " + responseString);
      log("estado " + response.statusCode.toString());
      _alert.createAlert(
          context, response.statusCode.toString(), responseString,
          "Aceptar");
    } catch (error) {
      log(error.toString());
    }
  }

  favorito(int id,
      int historiaId,
      int type,
      BuildContext context) async {
    print(historiaId);

    var response = await http.put(
        Uri.parse("${Constants.URL}/api/historias/favorito/${historiaId}"));

    print(response.statusCode);

    if (response.statusCode == 200) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => MyStories(id: id, type: type))
      );
    } else{
      _alert.createAlert(
          context, "Algo salió mal", "No se ha podido marcar la historia.",
          "Aceptar");
    }
  }


  Future<Historia?> getByUserIdAndLoungeId(int usuarioId, int salaId) async {
    var response = await http.get(
        Uri.parse("${Constants.URL}/api/historias/usuario-sala?usuarioId=${usuarioId}&salaId=${salaId}"));

    var jsonData = json.decode(
        Utf8Decoder().convert(response.bodyBytes).toString()
    );

    print(response.statusCode);

    if (response.statusCode == 200) {

      var puntaje = 0;
      var comentario = "";

      if(jsonData["puntaje"] != null)
        puntaje = jsonData["puntaje"];

      if(jsonData["comentario"] != null)
        comentario = jsonData["comentario"];

      Historia historia = Historia(
          jsonData["id"],
          jsonData["nombre"],
          jsonData["url"],
          jsonData["descripcion"],
          false,
          "",
          puntaje,
          comentario);

      return historia;
    } else {
      return null;
    }
  }

  calificar(int id,
      int historiaId,
      int salaId,
      String salaName,
      int type,
      int puntaje,
      String descripcion,
      BuildContext context) async {
    print(historiaId);

    Map data = {
      'comentario': descripcion,
      'puntaje': puntaje
    };

    var bodyRequest = json.encode(data);

    var response = await http.put(
        Uri.parse("${Constants.URL}/api/historias/calificar/${historiaId}"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);

    print(response.statusCode);

    if (response.statusCode == 200) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => LoungeStoryList(id: id, type: type, salaId: salaId,
              salaName: salaName)
      ));
    } else{
      _alert.createAlert(
          context, "Algo salió mal", "No se ha podido marcar la historia.",
          "Aceptar");
    }
  }

}