
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:historyar_app/helpers/constant_helpers.dart';
import 'package:historyar_app/model/comment.dart';
import 'package:historyar_app/model/forum_holder.dart';
import 'package:historyar_app/utils/alert.dart';

import 'package:http/http.dart' as http;

class ForumProvider {
  Alert _alert = Alert();

  Future<List<ForumHolder>> getAll(int type) async {
    var response = await http.get(
        Uri.parse("${Constants.URL}/api/publicaciones"));

    var jsonData = json.decode(response.body);

    List<ForumHolder> foros = [];

    for(var aux in jsonData) {
      ForumHolder foro = ForumHolder(id: aux["id"],
          imagUrl: "https://historyar-bucket.s3.amazonaws.com/foros/cropped-851-315-459566.jpg",
          title: aux["tema"],
          description: aux["descripcion"]);

      foros.add(foro);
    }

    return foros;
  }

  Future<List<Comment>> getCommments(int id) async {

    var response = await http.get(
        Uri.parse("${Constants.URL}/api/comentarios/publicacion/${id}"));

    var jsonData = json.decode(response.body);

    List<Comment> comentarios = [];

    for(var aux in jsonData) {
      Comment comentario = Comment(aux["id"],
          aux["descripcion"],
          aux["reaccion"],
          aux["usuario"]["nombres"]);

      comentarios.add(comentario);
    }

    return comentarios;
  }


  Future<bool> comentar(String descripcion,
      int reaccion,
      int usuarioId,
      int publicacionId) async {
    Map data = {
      'descripcion': descripcion,
      'reaccion': reaccion,
      'usuario' : {
        'id' : usuarioId
      },
      'publicacion' : {
        'id' : publicacionId
      }
    };
    var bodyRequest = json.encode(data);

    var response = await http.post(
        Uri.parse("${Constants.URL}/api/comentarios/crear"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);

    print(response.statusCode);

    if (response.statusCode == 201) {
      return true;
    }else {
      return false;
    }
  }

}