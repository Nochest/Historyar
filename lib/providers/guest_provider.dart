import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:historyar_app/model/reuser.dart';
import 'package:historyar_app/pages/guest_pages/lounge_guest.dart';
import 'package:historyar_app/pages/main_menu_pages/home_holder.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:intl/intl.dart';

import '../helpers/constant_helpers.dart';
import 'package:http/http.dart' as http;
class GuestProvider {
  Alert _alert = Alert();
  Random _rnd = Random();
  var rng = new Random();
  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
  length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  SingIn(String code, String password, String name,BuildContext context) async {

    var sala = await http.get(
        Uri.parse("${Constants.URL}/api/salas/code?code=${code}"));
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    var selectedDate = DateTime.now();

    if(sala.statusCode == 200) {

      var salaData = json.decode(
          Utf8Decoder().convert(sala.bodyBytes).toString()
      );

      if(password == salaData["password"]) {

        Map datausuario = {
          'nombres': name,
          'apellidos': '',
          'email': getRandomString(5),
          'password': '',
          'fechaNacimiento': '2000-06-22',
          'tipoUsuario': 0,
        };

        var usuarioBody = json.encode(datausuario);

        var usuario = await http.post(
            Uri.parse("${Constants.URL}/api/usuarios/crear"),
            headers: {"Content-Type": "application/json"},
            body: usuarioBody);

        if(usuario.statusCode == 201) {

          var usuarioData = json.decode(
              Utf8Decoder().convert(usuario.bodyBytes).toString()
          );

          Map dataAsistencia = {
            "fecha": formatter.format(selectedDate),
            "numeroGrupo": 1,
            "usuario": {
              "id": usuarioData["id"]
            },
            "sala": {
              "id": salaData["id"]
            }
          };

          var asistenciaBody = json.encode(dataAsistencia);

          var asistencia = await http.post(
              Uri.parse("${Constants.URL}/api/asistencias/crear"),
              headers: {"Content-Type": "application/json"},
              body: asistenciaBody);

          var asistenciaData = json.decode(
              Utf8Decoder().convert(asistencia.bodyBytes).toString()
          );

          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => LoungeGuest(id: usuarioData["id"],
                asistenciaId: asistenciaData["id"], salaId: salaData["id"], salaName: salaData["titulo"],))
          );

        } else {
          _alert.createAlert(
              context, "Algo salió mal", "Ingresar a la sala.",
              "aceptar");
        }

      } else {
        _alert.createAlert(
            context, "Algo salió mal", "la contraseña es incorrecta",
            "aceptar");
      }

    } else if (sala.statusCode == 404) {
      _alert.createAlert(
          context, "No se encontró", "La sala con el código ${code} no existe",
          "aceptar");
    } else {
      _alert.createAlert(
          context, "Algo salió mal", "No se pudo encontrar la sala.",
          "aceptar");
    }

  }

  guestSinginDocente(BuildContext context) async{
    
      Map data = {
      'celular': 'unknow',
      'institucionEducativa': 'unknow',
      'nombres': 'unknow',
      'apellidos': 'unknow',
      'email': getRandomString(5)+'@'+getRandomString(2)+'hotmail.com',
      'password': 'unknow',
      'fechaNacimiento': '2000-06-22'
    };
    var bodyRequest = json.encode(data);
    print(bodyRequest.toString());
    var response = await http.post(
        Uri.parse("${Constants.URL}/api/docentes/crear"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);
        print(response.statusCode);
        print(data);
        print('vamos');

    if (response.statusCode == 201){
        print('entro aca papi');
        var response = await http.get(
        Uri.parse("${Constants.URL}/api/usuarios"));
    
        var jsonData = json.decode(
        Utf8Decoder().convert(response.bodyBytes).toString()
        );
        List<Object> users = [];
        for(var aux in jsonData){
            users.add(aux);
        }
       var list = users.last.toString();
      //ReUsuario user = list.cast<>Rz
       var id1 = list[5];
       var id2 = list[6];
       var supid = id1+id2;
       List<String> auxiliar = [];
       auxiliar.add(id1);
       auxiliar.add(id2);
       var res = int.parse(auxiliar.join());
       //var res = int.parse(supid);
       print('estes es el tipo de json');
       print(jsonData.runtimeType);
       print(auxiliar);
       print(auxiliar.join());
       if( users != null){
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    HomeHolder(
                        id: res, type: 2)),
                (Route<dynamic> route) => false);
       }
       //var id = int.parse(list['id']);
     
       
      

    }

  
  }
  
  guestSinginStudent(BuildContext context) async{
   Map data = {
      'emailApoderado': 'unknow',
      'nombres': 'unknow',
      'apellidos': 'unknow',
      'email': getRandomString(4)+'@'+getRandomString(3)+'gmail.com',
      'password': 'unknow',
      'fechaNacimiento': '2000-06-22'
   };
   var bodyRequest = json.encode(data);

    var response = await http.post(
        Uri.parse("${Constants.URL}/api/alumnos/crear"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);
        print(data);
        print(response.statusCode);
        print('vamos');
    if (response.statusCode == 201){
        print('entro aca papi');
        var response = await http.get(
        Uri.parse("${Constants.URL}/api/usuarios"));
    
        var jsonData = json.decode(
        Utf8Decoder().convert(response.bodyBytes).toString()
        );
        List<Object> users = [];
        for(var aux in jsonData){
            users.add(aux);
        }
       var list = users.last.toString();
      //ReUsuario user = list.cast<>Rz
       var id1 = list[5];
       var id2 = list[6];
       var supid = id1+id2;
       List<String> auxiliar = [];
       auxiliar.add(id1);
       auxiliar.add(id2);
       var res = int.parse(auxiliar.join());
       //var res = int.parse(supid);
       print('estes es el tipo de json');
       print(jsonData.runtimeType);
       print(auxiliar);
       print(auxiliar.join());
       if( users != null){
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    HomeHolder(
                        id: res, type: 1)),
                (Route<dynamic> route) => false);
      }
    }

  }
}