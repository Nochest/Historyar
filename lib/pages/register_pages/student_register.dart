import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:historyar_app/pages/sign_in_pages/sign_in.dart';
import 'package:historyar_app/providers/user_provider.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/input_text.dart';

import 'package:intl/intl.dart';

class StudentRegister extends StatefulWidget {
  @override
  _StudentRegisterState createState() => _StudentRegisterState();
}

class _StudentRegisterState extends State<StudentRegister> {
  final snackBar = SnackBar(content: Text('Password must match'));
  final privacy =
      SnackBar(content: Text('You mus accept terms and conditions'));

  var lorem_ipsum =
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
  var _usuarioProvider = UserProvider();

  bool emailParent = false;
  bool names = false;
  bool surnames = false;
  bool email = false;
  bool password = false;
  bool passwordConfirmed = false;
  bool birthDate = false;

  DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateFormat formatterFront = DateFormat('dd/MM/yyyy');

  final focus_email_parent = FocusNode();
  final focus_names = FocusNode();
  final focus_surnames = FocusNode();
  final focus_email = FocusNode();
  final focus_password = FocusNode();
  final focus_password_confirm = FocusNode();
  final birthFocus = FocusNode();

  TextEditingController _emailParentController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _birthFrontDateController = TextEditingController();

  bool value = false;
  var selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    focus_email_parent.addListener(() => setState(() {}));
    focus_names.addListener(() => setState(() {}));
    focus_surnames.addListener(() => setState(() {}));
    focus_email.addListener(() => setState(() {}));
    focus_password.addListener(() => setState(() {}));
    focus_password_confirm.addListener(() => setState(() {}));

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
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: Text(
                    'Bienvenido nuevo estudiante!',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _colorPalette.yellow,
                        fontSize: 30.0),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _inputText.defaultIText(
                  focus_email_parent,
                  _emailParentController,
                  TextInputType.text,
                  'Correo electrónico apoderado',
                  '',
                  false,
                  'Correo electronico apoderado',
                  emailParent),
              const SizedBox(height: 16),
              _inputText.defaultIText(
                focus_names,
                _nameController,
                TextInputType.text,
                'Nombres',
                '',
                false,
                'Nombres',
                names,
              ),
              const SizedBox(height: 16),
              _inputText.defaultIText(
                  focus_surnames,
                  _surnameController,
                  TextInputType.text,
                  'Apellidos',
                  '',
                  false,
                  'Apellidos',
                  surnames),
              const SizedBox(height: 16),
              _createFechaNac(context),
              const SizedBox(height: 16),
              _inputText.defaultIText(
                  focus_email,
                  _emailController,
                  TextInputType.text,
                  'Correo electrónico',
                  '',
                  false,
                  'Correo electrónico',
                  email),
              const SizedBox(height: 16),
              _inputText.defaultIText(
                  focus_password,
                  _passwordController,
                  TextInputType.text,
                  'Contraseña',
                  '',
                  true,
                  'Contraseña',
                  password),
              const SizedBox(height: 16),
              _inputText.defaultIText(
                  focus_password_confirm,
                  _passwordConfirmController,
                  TextInputType.text,
                  'Ingrese nuevamente su contraeña',
                  '',
                  true,
                  'Ingrese nuevamente su contraeña',
                  passwordConfirmed),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                      value: value,
                      onChanged: (m) {
                        setState(() {
                          value = m!;
                        });
                      }),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                          text: 'Yo acepto los ',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: _colorPalette.text),
                          children: [
                            TextSpan(
                                text: 'términos y condiciones ',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: _colorPalette.yellow),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _alert.createAlert(
                                        context,
                                        'Términos y Condiciones',
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
                                      text: 'privacidad y políticas ',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: _colorPalette.yellow),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          _alert.createAlert(
                                              context,
                                              'Privacidad y Políticas',
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
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              _registerButton(context),
            ],
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
                _emailParentController.text.isNotEmpty &&
                _nameController.text.isNotEmpty &&
                _surnameController.text.isNotEmpty &&
                _birthDateController.text.isNotEmpty &&
                _emailController.text.isNotEmpty &&
                _passwordController.text.isNotEmpty &&
                _passwordConfirmController.text.isNotEmpty &&
                (_passwordController.text == _passwordConfirmController.text)) {
              _usuarioProvider.registerAlumno(
                  _emailParentController.text,
                  _nameController.text,
                  _surnameController.text,
                  _emailController.text,
                  _passwordController.text,
                  _birthFrontDateController.text,
                  context);
              //Navigator.of(context).pushReplacement(MaterialPageRoute(
              //   builder: (BuildContext context) => SignIn()));
            } else {
              setState(() {
                if (_emailParentController.text.isEmpty) emailParent = true;
                if (_nameController.text.isEmpty) names = true;
                if (_surnameController.text.isEmpty) surnames = true;
                if (_birthDateController.text.isEmpty) birthDate = true;
                if (_emailController.text.isEmpty) email = true;
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

  Widget _createFechaNac(BuildContext context) {
    return TextFormField(
      controller: _birthDateController,
      decoration: InputDecoration(
        label: Text('Fecha de nacimiento'),
        labelStyle: TextStyle(
          color: birthFocus.hasFocus || _birthDateController.text.isNotEmpty
              ? _colorPalette.yellow
              : _colorPalette.text,
          fontWeight:
              birthFocus.hasFocus || _birthDateController.text.isNotEmpty
                  ? FontWeight.w600
                  : FontWeight.normal,
        ),
      ),
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());

        await _selectDate(context);
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(2101));

    int calculateAge(DateTime birthDate) {
      DateTime currentDate = DateTime.now();
      print(currentDate.year);
      print(birthDate.year);
      int age = currentDate.year - birthDate.year;
      int month1 = currentDate.month;
      int month2 = birthDate.month;
      if (month2 > month1) {
        age--;
      } else if (month1 == month2) {
        int day1 = currentDate.day;
        int day2 = birthDate.day;
        if (day2 > day1) {
          age--;
        }
      }
      print(age);
      return age;
    }

    if (picked != null && picked != selectedDate) {

      if(calculateAge(picked) >= 10) {

        setState(() {
          selectedDate = picked;
          _birthDateController.text = formatterFront.format(picked);
          _birthFrontDateController.text = formatter.format(picked);
        });

      } else {
        _alert.createAlert(context, 'Alerta', 'Debes tener de 10 años a más para registrarte en el app como estudiante', "Aceptar");
      }
    }
  }
}
