import 'package:historyar_app/helpers/constant_helpers.dart';
import 'package:historyar_app/model/lounge.dart';
import 'package:historyar_app/model/story.dart';
import 'package:historyar_app/pages/main_menu_pages/lounge_page.dart';
import 'package:historyar_app/pages/story_pages/my_stories.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoungeProvider {
  Alert _alert = Alert();

  Future<List<Sala>> getAll(int id, int type) async {
    var response = await http.get(
        Uri.parse("${Constants.URL}/api/salas"));

    print(response.statusCode);
    print(id);

    var jsonData = json.decode(response.body);

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

}