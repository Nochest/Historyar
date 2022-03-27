import 'dart:io';

import 'package:historyar_app/helpers/constant_helpers.dart';
import 'package:historyar_app/pages/main_menu_pages/home_holder.dart';
import 'package:historyar_app/pages/register_pages/success_register.dart';
import 'package:historyar_app/pages/sign_in_pages/success_reset.dart';
import 'package:historyar_app/utils/alert.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioProvider {
  Alert _alert = Alert();

  signIn(String email, String password, BuildContext context) async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': email,
      'password': password,
    };
    var bodyRequest = json.encode(data);
    var jsonData;
    var response = await http.post(
        Uri.parse("${Constants.URL}/api/usuarios/login"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);

    print(response.statusCode);

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      if (jsonData != null) {
        sharedPreferences.setInt("id", jsonData['id']);
        sharedPreferences.setString("nombres", jsonData['nombres']);
        sharedPreferences.setString("email", jsonData['email']);
        sharedPreferences.setString("token", jsonData['password']);

        sharedPreferences.setInt("tipoUsuario", jsonData['tipoUsuario']);

        if (sharedPreferences.getInt("tipoUsuario") == 1) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeHolder()),
              (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeHolder()),
              (Route<dynamic> route) => false);
        }
      }
    } else {
      _alert.createAlert(context, 'Credenciales inválidas',
          'El usuario o contraseña ingresados son incorrectos', 'Aceptar');
    }
  }

  registerDocente(
      String celular,
      String institucionEducativa,
      String nombres,
      String apellidos,
      String email,
      String password,
      String fechaNacimiento,
      BuildContext context) async {

    Map data = {
      'celular': celular,
      'institucionEducativa': institucionEducativa,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'password': password,
      'fechaNacimiento': fechaNacimiento
    };
    var bodyRequest = json.encode(data);
    print("${Constants.URL}/api/docentes/crear");
    var response = await http.post(
        Uri.parse("${Constants.URL}/api/docentes/crear"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);

    print(response.statusCode);

    if(response.statusCode == 201) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (BuildContext context) => SuccessRegister()), (Route<dynamic> route) => false);
    }

    return 0;
  }

  registerAlumno(
      String emailApoderado,
      String nombres,
      String apellidos,
      String email,
      String password,
      String fechaNacimiento,
      BuildContext context) async {

    Map data = {
      'emailApoderado': emailApoderado,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'password': password,
      'fechaNacimiento': fechaNacimiento
    };
    var bodyRequest = json.encode(data);

    var response = await http.post(
        Uri.parse("${Constants.URL}/api/alumnos/crear"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);

    if(response.statusCode == 201) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (BuildContext context) => SuccessRegister()), (Route<dynamic> route) => false);
    }

    return 0;
  }

  recuperarCuenta(
      String email,
      BuildContext context) async{

    Map data = {
      'email': email
    };
    var bodyRequest = json.encode(data);

    var response = await http.put(
        Uri.parse("${Constants.URL}/api/usuarios/recuperar"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);

    print(response.statusCode);

    if(response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute( builder: (BuildContext context) => SuccessReset()), (Route<dynamic> route) => false);
    }else{
      _alert.createAlert(context, "Algo salió mal", "No se ha encontrado el correo.", "aceptar");
    }
  }
}
