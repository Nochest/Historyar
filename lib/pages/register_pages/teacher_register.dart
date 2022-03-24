import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:historyar_app/pages/main_menu_pages/home_holder.dart';
import 'package:historyar_app/pages/sign_in_pages/sign_in.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/input_text.dart';

class TeacherRegister extends StatefulWidget {
  @override
  _TeacherRegisterState createState() => _TeacherRegisterState();
}

class _TeacherRegisterState extends State<TeacherRegister> {
  final snackBar = SnackBar(content: Text('Password must match'));
  final privacy =
      SnackBar(content: Text('You mus accept terms and conditions'));

  String lorem_ipsum =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
      'eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, '
      'quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. '
      'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. '
      'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est '
      'laborum.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
      'eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, '
      'quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. '
      'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. '
      'Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

  ColorPalette _colorPalette = ColorPalette();
  InputText _inputText = InputText();
  Alert _alert = Alert();

  bool name = false;
  bool email = false;
  bool mobile = false;
  bool password = false;
  bool passwordConfirmed = false;

  FocusNode focus_full_name = FocusNode();
  FocusNode focus_email = FocusNode();
  FocusNode focus_mobile = FocusNode();
  FocusNode focus_password = FocusNode();
  FocusNode focus_password_confirm = FocusNode();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  bool value = false;

  @override
  Widget build(BuildContext context) {
    focus_full_name.addListener(() {
      setState(() {});
    });
    focus_email.addListener(() {
      setState(() {});
    });
    focus_mobile.addListener(() {
      setState(() {});
    });
    focus_password.addListener(() {
      setState(() {});
    });
    focus_password_confirm.addListener(() {
      setState(() {});
    });

    return Scaffold(
      backgroundColor: _colorPalette.cream,
      appBar: AppBar(
        backgroundColor: _colorPalette.darkBlue,
        title:
            Text('Regístrate!', style: TextStyle(fontWeight: FontWeight.w700)),
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
          padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
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
                      'Bienvenido\nnuevo maestro!',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _colorPalette.yellow,
                          fontSize: 32.0),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: _inputText.defaultIText(
                      focus_full_name,
                      _fullNameController,
                      TextInputType.text,
                      'Nombre completo',
                      '',
                      false,
                      'Nombre completo',
                      name),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: _inputText.defaultIText(
                      focus_email,
                      _emailController,
                      TextInputType.text,
                      'Correo electronico',
                      '',
                      false,
                      'Correo electronico',
                      email),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: _inputText.defaultIText(
                      focus_mobile,
                      _mobileController,
                      TextInputType.phone,
                      'Numero de celular',
                      '',
                      false,
                      'Numero de celular',
                      mobile),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: _inputText.defaultIText(
                      focus_password,
                      _passwordController,
                      TextInputType.text,
                      'Contraseña',
                      '',
                      true,
                      'Contraseña',
                      password),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: _inputText.defaultIText(
                      focus_password_confirm,
                      _passwordConfirmController,
                      TextInputType.text,
                      'Ingrese nuevamente su contraeña',
                      '',
                      true,
                      'Ingrese nuevamente su contraeña',
                      passwordConfirmed),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: [
                        Checkbox(
                            value: this.value,
                            onChanged: (value) {
                              setState(() {
                                this.value = value!;
                              });
                            }),
                        Text.rich(
                          TextSpan(
                              text: 'Yo acepto los ',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: _colorPalette.text),
                              children: [
                                TextSpan(
                                    text: 'terminos y condiciones ',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                        color: _colorPalette.yellow),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _alert.createAlert(
                                            context,
                                            'Terminos y Condiciones',
                                            lorem_ipsum.toString(),
                                            'Cerrar');
                                      }),
                                TextSpan(
                                    text: 'de \nuso y la ',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        color: _colorPalette.text),
                                    children: [
                                      TextSpan(
                                          text: 'privacidad y politicas ',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600,
                                              color: _colorPalette.yellow),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              _alert.createAlert(
                                                  context,
                                                  'Privacidad y Politicas',
                                                  lorem_ipsum.toString(),
                                                  'Cerrar');
                                            }),
                                      TextSpan(
                                          text: 'de este sitio',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w400,
                                              color: _colorPalette.text))
                                    ])
                              ]),
                        )
                      ],
                    )),
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
          child: Text('Continuar',
              style: TextStyle(
                  color: _colorPalette.yellow, fontWeight: FontWeight.bold)),
          onPressed: () {
            if (value &&
                _fullNameController.text.isNotEmpty &&
                _emailController.text.isNotEmpty &&
                _mobileController.text.isNotEmpty &&
                _passwordController.text.isNotEmpty &&
                _passwordConfirmController.text.isNotEmpty &&
                (_passwordController.text == _passwordConfirmController.text)) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => HomeHolder()));
            } else {
              setState(() {
                if (_fullNameController.text.isEmpty) name = true;
                if (_emailController.text.isEmpty) email = true;
                if (_mobileController.text.isEmpty) mobile = true;
                if (_passwordController.text.isEmpty) password = true;
                if (_passwordConfirmController.text.isEmpty)
                  passwordConfirmed = true;
                if (_passwordController.text != _passwordConfirmController.text)
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                if (this.value == false)
                  ScaffoldMessenger.of(context).showSnackBar(privacy);
              });
            }
          }),
    );
  }
}
