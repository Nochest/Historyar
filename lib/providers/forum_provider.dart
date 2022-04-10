
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:historyar_app/helpers/constant_helpers.dart';
import 'package:historyar_app/model/comment.dart';
import 'package:historyar_app/model/forum_holder.dart';
import 'package:historyar_app/pages/forum_pages/my_forums.dart';
import 'package:historyar_app/pages/main_menu_pages/community.dart';
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

  Future<ForumHolder?> getById(int id,
      int type,
      int userId) async {
    var response = await http.get(
        Uri.parse("${Constants.URL}/api/publicaciones/${id}"));

    print("0");
    print(response.statusCode);

    var jsonData = json.decode(response.body);

    if(response.statusCode == 200){
      ForumHolder foro = ForumHolder(id: jsonData["id"],
          imagUrl: "",
          title: jsonData["tema"],
          description: jsonData["descripcion"]);

      return foro;
    } else{
      return null;
    }
  }

  Future<List<Comment>> getCommments(int id, int userId) async {

    var response = await http.get(
        Uri.parse("${Constants.URL}/api/comentarios/publicacion/${id}"));

    var jsonData = json.decode(response.body);

    List<Comment> comentarios = [];

    for(var aux in jsonData) {
      var usuario = aux["usuario"]["nombres"];

      if(userId == aux["usuario"]["id"])
        usuario = "Yo";

      Comment comentario = Comment(aux["id"],
          aux["descripcion"],
          aux["reaccion"],
          usuario);

      comentarios.add(comentario);
    }

    return comentarios;
  }

  Future<List<ForumHolder>> getByUserId(int id, int type) async {
    var response = await http.get(
        Uri.parse("${Constants.URL}/api/publicaciones/listar/usuario/${id}"));

    print(response.statusCode);
    print(id);

    var jsonData = json.decode(response.body);

    List<ForumHolder> foros = [];

    for(var aux in jsonData) {
      ForumHolder foro = ForumHolder(id: aux["id"],
          imagUrl: "",
          title: aux["tema"],
          description: aux["descripcion"]);

      foros.add(foro);
    }

    return foros;
  }

  publicar(String tema,
      String descripcion,
      int usuarioId,
      int type,
      BuildContext context) async{

    Map data = {
      'descripcion': descripcion,
      'tema': tema,
      'usuario' : {
        'id' : usuarioId
      }
    };
    var bodyRequest = json.encode(data);

    var response = await http.post(
        Uri.parse("${Constants.URL}/api/publicaciones/crear"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);

    if (response.statusCode == 201) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context) => Community(id: usuarioId, type: type)), (
          Route<dynamic> route) => false);
    } else {
      _alert.createAlert(
          context, "Algo salió mal", "No se ha podido publicar.",
          "aceptar");
    }
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

  borrarPublicacion(
      int id,
      int type,
      int userId,
      BuildContext context) async {
    var response = await http.delete(
        Uri.parse("${Constants.URL}/api/publicaciones/${id}"));

    print(response.statusCode);

    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context) =>
              MyForums(id: userId, type: type)), (
          Route<dynamic> route) => false);
    } else {
      _alert.createAlert(
          context, "Algo salió mal", "No se ha podido borrar.",
          "aceptar");
    }
  }

  editarPublicacion(int id,
      String tema,
      String descripcion,
      int usuarioId,
      int type,
      BuildContext context) async{

    Map data = {
      'descripcion': descripcion,
      'tema': tema
    };
    var bodyRequest = json.encode(data);

    var response = await http.put(
        Uri.parse("${Constants.URL}/api/publicaciones/editar/${id}"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);

    print(response.statusCode);

    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (BuildContext context) => MyForums(id: usuarioId, type: type)), (
          Route<dynamic> route) => false);
    } else {
      _alert.createAlert(
          context, "Algo salió mal", "No se ha podido editar.",
          "aceptar");
    }
  }

}