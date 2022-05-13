import 'package:flutter/material.dart';
import 'package:historyar_app/pages/register_pages/student_register.dart';
import 'package:historyar_app/pages/register_pages/teacher_register.dart';
import 'package:historyar_app/pages/sign_in_pages/forget_password.dart';
import 'package:historyar_app/providers/user_provider.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/input_text.dart';

import '../../providers/guest_provider.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool signIn = false;
  bool pass = false;

  bool name = false;
  bool salaCode = false;
  bool salaPassword = false;

  ColorPalette _colorPalette = ColorPalette();
  InputText _inputText = InputText();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _salaCodeController = TextEditingController();
  TextEditingController _salaPasswordController = TextEditingController();

  FocusNode focus_email = FocusNode();
  FocusNode focus_password = FocusNode();

  FocusNode focus_name = FocusNode();
  FocusNode focus_sala_code = FocusNode();
  FocusNode focus_sala_password = FocusNode();


  var _usuarioProvider = UserProvider();

  var _guestProvider = GuestProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _colorPalette.lightBlue,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(children: [
            Positioned(
              top: 180,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 180,
                decoration: BoxDecoration(
                  color: _colorPalette.cream,
                  borderRadius: BorderRadius.only(
                    topRight: const Radius.circular(25.0),
                    topLeft: const Radius.circular(25.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        'Iniciar sesión',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: _colorPalette.yellow,
                            fontSize: 32.0),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 16),
                      _inputText.defaultIText(
                        focus_email,
                        _emailController,
                        TextInputType.emailAddress,
                        'Correo',
                        '',
                        false,
                        'Correo ',
                        signIn,
                      ),
                      const SizedBox(height: 8),
                      _inputText.defaultIText(
                          focus_password,
                          _passwordController,
                          TextInputType.text,
                          'Contraseña',
                          '',
                          true,
                          'Contraseña',
                          pass),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Spacer(),
                          TextButton(
                            child: Text('Olvidaste tu contraseña?',
                                style: TextStyle(
                                    color: _colorPalette.darkBlue,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.0)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgetPassword()));
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _loginButton(context),
                      const SizedBox(height: 20),
                      _register_text_button(context),
                      const SizedBox(height: 5),
                      guestlogin(context)
                    ],
                  ),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/logo.png',
                      width: 240.0,
                      height: 240.0,
                    ))),
          ]),
        ));
  }

  Widget _loginButton(BuildContext context) {
    return Center(
      child: MaterialButton(
          height: 48.0,
          minWidth: 170.0,
          color: _colorPalette.yellow,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)),
          child: Text('Iniciar sesión',
              style: TextStyle(
                  color: _colorPalette.darkBlue, fontWeight: FontWeight.bold)),
          onPressed: () {
            if (_emailController.text.isNotEmpty &&
                _passwordController.text.isNotEmpty) {
              _usuarioProvider.signIn(
                  _emailController.text, _passwordController.text, context);
              /*
              Navigator.of(context).
              pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomeHolder()),
                      (Route<dynamic> route) => false);

     */
            } else {
              setState(() {
                if (_emailController.text.isEmpty) signIn = true;
                if (_passwordController.text.isEmpty) pass = true;
              });
            }
          }),
    );
  }

  Widget _register_text_button(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No tienes una cuenta?',
              style: TextStyle(
                  color: _colorPalette.text,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.0)),
          TextButton(
            child: Text('Registrate ahora',
                style: TextStyle(
                    color: _colorPalette.darkBlue,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0)),
            onPressed: () {
              createAlert(context);
            },
          )
        ],
      ),
    );
  }

  void createAlert(BuildContext context) {
    showDialog(
        barrierColor: _colorPalette.lightBlue.withOpacity(0.6),
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            backgroundColor: _colorPalette.cream,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Center(
                    child: Text('Tipo de Usuario',
                        style: TextStyle(
                            color: _colorPalette.darkBlue,
                            fontWeight: FontWeight.w700,
                            fontSize: 24.0)))),
            content: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Elija el tipo de usuario que desea crear',
                      style: TextStyle(
                          color: _colorPalette.text,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0),
                      textAlign: TextAlign.justify),
                  SizedBox(height: 24.0),
                  teacherButton(context, 'Docente'),
                  SizedBox(height: 8.0),
                  studentbutton(context, 'Estudiante'),
                ],
              ),
            ),
          );
        });
  }

  Widget teacherButton(BuildContext context, String text) {
    return MaterialButton(
        height: 36.0,
        minWidth: 126.0,
        color: _colorPalette.lightBlue,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
        child: Text(text,
            style: TextStyle(
                color: _colorPalette.yellow, fontWeight: FontWeight.w600)),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => TeacherRegister()),
              (Route<dynamic> route) => true);
        });
  }

  Widget studentbutton(BuildContext context, String text) {
    return MaterialButton(
        height: 36.0,
        minWidth: 126.0,
        color: _colorPalette.lightBlue,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
        child: Text(text,
            style: TextStyle(
                color: _colorPalette.yellow, fontWeight: FontWeight.w600)),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => StudentRegister()),
              (Route<dynamic> route) => true);
        });
  }

  Widget guestlogin(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Text('No tienes una cuenta?', style: TextStyle(color: _colorPalette.text, fontWeight: FontWeight.w400, fontSize: 16.0)),
          TextButton(
            child: Text('Continuar como invitado',
                style: TextStyle(
                    color: _colorPalette.darkBlue,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0)),
            onPressed: () {
              guestAlert(context);
            },
          )
        ],
      ),
    );
  }


  void guestAlert(BuildContext context) {
    _nameController.text = "";
    _salaCodeController.text = "";
    _salaPasswordController.text = "";

    showDialog(
        barrierColor: _colorPalette.lightBlue.withOpacity(0.6),
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                    child: Text("Ingresar a una sala sin cuenta",
                        style: TextStyle(
                            color: _colorPalette.darkBlue,
                            fontWeight: FontWeight.w700,
                            fontSize: 24.0)))),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: _inputText.defaultIText(
                        focus_name,
                        _nameController,
                        TextInputType.text,
                        'Ingrese su nombre',
                        '',
                        false,
                        'Ingrese su nombre',
                        name),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: _inputText.defaultIText(
                        focus_sala_code,
                        _salaCodeController,
                        TextInputType.text,
                        'Ingrese el código',
                        '',
                        false,
                        'Ingrese el código',
                        salaCode),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: _inputText.defaultIText(
                        focus_sala_password,
                        _salaPasswordController,
                        TextInputType.text,
                        'Ingrese su contraeña',
                        '',
                        true,
                        'Ingrese su contraeña',
                        salaPassword),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
                      child: default_button(context)),
                  Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: accept_button(context))
                ],
              ),
            ),
          );
        });
  }

  Widget default_button(BuildContext context) {
    return MaterialButton(
        height: 36.0,
        minWidth: 126.0,
        color: _colorPalette.lightBlue,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
        child: Text("Cancelar",
            style: TextStyle(
                color: _colorPalette.text, fontWeight: FontWeight.w600)),
        onPressed: () {
          Navigator.of(context).pop();
        });
  }

  Widget accept_button(BuildContext context) {
    return MaterialButton(
        height: 36.0,
        minWidth: 126.0,
        color: _colorPalette.lightBlue,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
        child: Text("Aceptar",
            style: TextStyle(
                color: _colorPalette.text, fontWeight: FontWeight.w600)),
        onPressed: () {
          if (_nameController.text.isNotEmpty && _salaCodeController.text.isNotEmpty) {
            _guestProvider.SingIn(_salaCodeController.text, _salaPasswordController.text,
                _nameController.text, context);
          } else {
            setState(() {
              _salaCodeController.text = "";
              _salaPasswordController.text = "";
              salaCode = true;
              salaPassword = true;
            });
          }
        });
  }
}
