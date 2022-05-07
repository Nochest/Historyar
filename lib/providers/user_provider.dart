import 'dart:io';

import 'package:historyar_app/helpers/constant_helpers.dart';
import 'package:historyar_app/main.dart';
import 'package:historyar_app/model/reuser.dart';
import 'package:historyar_app/model/user.dart';
import 'package:historyar_app/model/user_models/login_request.dart';
import 'package:historyar_app/model/user_models/login_response.dart';
import 'package:historyar_app/pages/main_menu_pages/home_holder.dart';
import 'package:historyar_app/pages/main_menu_pages/profile_page.dart';
import 'package:historyar_app/pages/register_pages/success_register.dart';
import 'package:historyar_app/pages/sign_in_pages/sign_in.dart';
import 'package:historyar_app/pages/sign_in_pages/success_reset.dart';
import 'package:historyar_app/utils/alert.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class UserProvider {
  Alert _alert = Alert();

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    LoginResponse user;
    Map<String, dynamic> request = {
      'email': email,
      'password': password,
    };

    final bodyRequest = LoginRequest.fromMap(request).toJson();

    final response = await http.post(
        Uri.parse("${Constants.URL}/api/usuarios/login"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);
    if (response.statusCode == 200) {
      user = LoginResponse.fromJson(response.body);
      localStorage.setInt('user_type', user.tipoUsuario);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) =>
                HomeHolder(id: user.id, type: user.tipoUsuario),
          ),
          (Route<dynamic> route) => false);
    } else if (response.statusCode == 403) {
      _alert.createAlert(
        context,
        'Cuenta no verificada',
        'El usuario se encuentra registrado, pero no se ha verificado',
        'Aceptar',
      );
    } else if (response.statusCode == 401) {
      _alert.createAlert(
        context,
        'Cuenta no disponible',
        'El usuario ha eliminado su cuenta.',
        'Aceptar',
      );
    } else if (response.statusCode == 404) {
      _alert.createAlert(
        context,
        'Credenciales inválidas',
        'El usuario o contraseña ingresados son incorrectos',
        'Aceptar',
      );
    } else {
      _alert.createAlert(
        context,
        'Algo salió mal',
        'No se pudo procesar la solicitud, intente más tarde.',
        'Aceptar',
      );
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

    if (response.statusCode == 201) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => SuccessRegister()),
          (Route<dynamic> route) => false);
    } else {
      _alert.createAlert(
          context, "Algo salió mal", "No se ha crear la cuenta.", "aceptar");
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

    if (response.statusCode == 201) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => SuccessRegister()),
          (Route<dynamic> route) => false);
    } else {
      _alert.createAlert(
          context, "Algo salió mal", "No se ha crear la cuenta.", "aceptar");
    }

    return 0;
  }

  recuperarCuenta(String email, BuildContext context) async {
    Map data = {'email': email};
    var bodyRequest = json.encode(data);

    var response = await http.put(
        Uri.parse("${Constants.URL}/api/usuarios/recuperar"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);

    print(response.statusCode);

    if (response.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => SuccessReset()),
          (Route<dynamic> route) => false);
    } else {
      _alert.createAlert(context, "Algo salió mal",
          "No se ha encontrado el correo.", "Aceptar");
    }
  }

  Future<ReUsuario?> getUser(int id) async {
    var response =
        await http.get(Uri.parse("${Constants.URL}/api/usuarios/${id}"));

    var jsonData =
        json.decode(Utf8Decoder().convert(response.bodyBytes).toString());

    print('Este es el id:');
    print(id);

    if (response.statusCode == 200) {
      ReUsuario usuario = ReUsuario(
          jsonData["id"],
          jsonData["nombres"],
          jsonData["apellidos"],
          "",
          jsonData["email"],
          "",
          jsonData["fechaNacimiento"],
          jsonData["tipoUsuario"],
          "",
          "",
          false,
          false);

      return usuario;
    } else {
      return null;
    }
  }

  Future<Usuario?> getUserByType(int id, int type) async {
    var aux = "";

    if (type == Constants.ALUMNO_USUARIO)
      aux = "alumno";
    else
      aux = "docente";

    var response =
        await http.get(Uri.parse("${Constants.URL}/api/usuarios/${aux}/${id}"));

    var jsonData =
        json.decode(Utf8Decoder().convert(response.bodyBytes).toString());
    print("csmr");
    print(jsonData["id"]);
    //print(jsonData["usuario"]["nombres"]);

    //print(response.statusCode);
    // print(id);
    // print(type);

    if (response.statusCode == 200 && type == Constants.DOCENTE_USUARIO) {
      Usuario usuario = Usuario(
          jsonData["id"],
          jsonData["usuario"]["nombres"],
          jsonData["usuario"]["apellidos"],
          jsonData["celular"],
          jsonData["usuario"]["email"],
          "",
          jsonData["usuario"]["fechaNacimiento"],
          jsonData["usuario"]["tipoUsuario"],
          "",
          jsonData["institucionEducativa"],
          jsonData["celularVisible"],
          jsonData["emailVisible"],
          id = jsonData["usuario"]["id"]);

      return usuario;
    } else if (response.statusCode == 200 && type == Constants.ALUMNO_USUARIO) {
      Usuario usuario = Usuario(
          jsonData["id"],
          jsonData["usuario"]["nombres"],
          jsonData["usuario"]["apellidos"],
          "",
          jsonData["usuario"]["email"],
          jsonData["emailApoderado"],
          jsonData["usuario"]["fechaNacimiento"],
          jsonData["usuario"]["tipoUsuario"],
          "",
          "",
          false,
          false,
          id = jsonData["usuario"]["id"]);

      return usuario;
    } else {
      return null;
    }
  }

  actualizarEstudiante(
      int id,
      int userId,
      int type,
      String nombres,
      String apellidos,
      String email,
      String fechaNacimiento,
      BuildContext context) async {
    Map data = {
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'fechaNacimiento': fechaNacimiento
    };
    var bodyRequest = json.encode(data);

    var response = await http.put(
        Uri.parse("${Constants.URL}/api/alumnos/editar/${id}"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);

    //print('.............');
    print(id);
    print(data['nombres']);
    //print(response.statusCode);

    if (response.statusCode == 200) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => Profile(id: userId, type: type)));
      _alert.createAlert(
          context, data['nombres'], response.statusCode.toString(), "aceptar");
    } else {
      _alert.createAlert(
          context, "Algo salió mal", "No se ha podido actualizar.", "aceptar");
    }
  }

  actualizarDocente(
      int id,
      int userId,
      int type,
      String celular,
      String institucionEducativa,
      String nombres,
      String apellidos,
      String email,
      String fechaNacimiento,
      bool celularVisible,
      bool emailVisible,
      BuildContext context) async {
    Map data = {
      'celular': celular,
      'institucionEducativa': institucionEducativa,
      'nombres': nombres,
      'apellidos': apellidos,
      'email': email,
      'fechaNacimiento': fechaNacimiento,
      'celularVisible': celularVisible,
      'emailVisible': emailVisible
    };
    var bodyRequest = json.encode(data);

    var response = await http.put(
        Uri.parse("${Constants.URL}/api/docentes/editar/${id}"),
        headers: {"Content-Type": "application/json"},
        body: bodyRequest);

    print(id);
    print(data['nombres']);

    if (response.statusCode == 200) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => Profile(id: userId, type: type)));
    } else {
      _alert.createAlert(
          context, "Algo salió mal", "No se ha podido actualizar.", "aceptar");
    }
  }

  borrarCuenta(int id, String password, BuildContext context) async {
    var response =
        await http.get(Uri.parse("${Constants.URL}/api/usuarios/${id}"));

    print(response.statusCode);

    if (response.statusCode == 200) {
      var jsonData =
          json.decode(Utf8Decoder().convert(response.bodyBytes).toString());

      if (jsonData["password"] == password) {
        var response2 = await http.put(
            Uri.parse("${Constants.URL}/api/usuarios/eliminar-status/${id}"));

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => SignIn()),
            (Route<dynamic> route) => false);
      } else {
        _alert.createAlert(context, "Contraseña Inválida",
            "La contraseña ingresada no es válida.", "aceptar");
      }
    } else {
      _alert.createAlert(
          context, "Algo salió mal", "No se ha podido actualizar.", "aceptar");
    }
  }
}
