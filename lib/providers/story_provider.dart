

import 'package:historyar_app/helpers/constant_helpers.dart';
import 'package:historyar_app/model/story.dart';
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

    var jsonData = json.decode(response.body);

    List<Historia> historias = [];

    for (var aux in jsonData) {
      Historia historia = Historia(aux["id"],
          aux["nombre"],
          aux["url"],
          aux["descripcion"]);

      historias.add(historia);
    }

    return historias;
  }

  Future<Historia?> getById(int id) async {
    var response = await http.get(
        Uri.parse("${Constants.URL}/api/historias/${id}"));

    var jsonData = json.decode(response.body);

    print(response.statusCode);

    if (response.statusCode == 200) {
      Historia historia = Historia(
          jsonData["id"],
          jsonData["nombre"],
          jsonData["url"],
          jsonData["descripcion"]);

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

    return 0;
  }

}