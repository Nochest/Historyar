
import 'package:flutter/material.dart';
import 'package:historyar_app/pages/main_menu_pages/home_holder.dart';
import 'package:historyar_app/pages/sign_in_pages/sign_in.dart';
import 'package:historyar_app/providers/user_provider.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/input_text.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final snackBar = SnackBar(content: Text('Password must match'));

  ColorPalette _colorPalette = ColorPalette();
  InputText _inputText = InputText();
  Alert _alert = Alert();
  var _usuarioProvider = UserProvider();

  bool email = false;
  FocusNode focus_email = FocusNode();

  TextEditingController _emailController = TextEditingController();

  var selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    focus_email.addListener(() {
      setState(() {});
    });

    return Scaffold(
      backgroundColor: _colorPalette.cream,
      appBar: AppBar(
        backgroundColor: _colorPalette.darkBlue,
        title:
        Text('¿Olvidó su contraseña?', style: TextStyle(fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) => SignIn()),
                    (Route<dynamic> route) => false);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 24.0),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: Text(
                      'Ingrese su correo para recuperar su contraseña',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _colorPalette.yellow,
                          fontSize: 32.0),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: _inputText.defaultIText(
                      focus_email,
                      _emailController,
                      TextInputType.text,
                      'Correo electrónico',
                      '',
                      false,
                      'Correo electrónico',
                      email),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 22.0, bottom: 40.0),
                    child: _registerButton(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerButton(BuildContext context) {
    return Center(
      child: MaterialButton(
          height: 48.0,
          minWidth: 170.0,
          color: _colorPalette.lightBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)),
          child: Text('Recuperar',
              style: TextStyle(
                  color: _colorPalette.yellow, fontWeight: FontWeight.bold)),
          onPressed: () {
            if (_emailController.text.isNotEmpty) {
              _usuarioProvider.recuperarCuenta(_emailController.text, context);
              //Navigator.of(context).push(MaterialPageRoute(
              //  builder: (BuildContext context) => HomeHolder()));
            } else {
              setState(() {
                if (_emailController.text.isEmpty) email = true;
              });
            }
          }),
    );
  }
}