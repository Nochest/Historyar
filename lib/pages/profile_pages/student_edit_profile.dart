import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:historyar_app/pages/main_menu_pages/home_holder.dart';
import 'package:historyar_app/pages/main_menu_pages/profile_page.dart';
import 'package:historyar_app/pages/sign_in_pages/sign_in.dart';
import 'package:historyar_app/providers/user_provider.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/utils/data_picker.dart';
import 'package:historyar_app/widgets/input_text.dart';

import 'package:intl/intl.dart';

class StudentEditProfile extends StatefulWidget {

  final int id;
  final int type;

  const StudentEditProfile({
    required this.id,
    required this.type,
    Key? key
  }) : super(key: key);

  @override
  _StudentEditProfile createState() => _StudentEditProfile();
}

class _StudentEditProfile extends State<StudentEditProfile> {

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

  FocusNode focus_email_parent = FocusNode();
  FocusNode focus_names = FocusNode();
  FocusNode focus_surnames = FocusNode();
  FocusNode focus_email = FocusNode();
  FocusNode focus_password = FocusNode();
  FocusNode focus_password_confirm = FocusNode();

  TextEditingController _emailParentController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();

  var selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    focus_email_parent.addListener(() {
      setState(() {});
    });
    focus_names.addListener(() {
      setState(() {});
    });
    focus_surnames.addListener(() {
      setState(() {});
    });
    focus_email.addListener(() {
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
        Text('Actualizar Datos', style: TextStyle(fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) => Profile(id: widget.id, type: widget.type)),
                    (Route<dynamic> route) => false);
          },
        ),
      ),
      body: FutureBuilder(
        future: _usuarioProvider.getUserByType(widget.id, widget.type),

        builder: (BuildContext context, AsyncSnapshot snapshot){

          if(snapshot.data == null){
            return Center(child: CircularProgressIndicator());
          } else {

            _emailParentController.text = snapshot.data.correoApoderado;
            _emailController.text = snapshot.data.email;
            _nameController.text = snapshot.data.nombres;
            _surnameController.text = snapshot.data.apellidos;
            _birthDateController.text = snapshot.data.fechaNacimiento;
            selectedDate = DateTime.parse(snapshot.data.fechaNacimiento);

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 24.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 40.0),
                        child: _inputText.defaultIText(
                            focus_names,
                            _nameController,
                            TextInputType.text,
                            'Nombres',
                            '',
                            false,
                            'Nombres',
                            names),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 40.0),
                        child: _inputText.defaultIText(
                            focus_surnames,
                            _surnameController,
                            TextInputType.text,
                            'Apellidos',
                            '',
                            false,
                            'Apellidos',
                            surnames),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 30.0, left: 30.0),
                        child: _createFechaNac(context),
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
            );
          }
        },
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
          child: Text('Guardar',
              style: TextStyle(
                  color: _colorPalette.yellow, fontWeight: FontWeight.bold)),
          onPressed: () {
            if (_emailParentController.text.isNotEmpty &&
                _nameController.text.isNotEmpty &&
                _surnameController.text.isNotEmpty &&
                _birthDateController.text.isNotEmpty &&
                _emailController.text.isNotEmpty) {
              _usuarioProvider.actualizarEstudiante(
                  widget.id,
                  widget.type,
                  _nameController.text,
                  _surnameController.text,
                  _emailController.text,
                  _birthDateController.text,
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
                  passwordConfirmed = true;
              });
            }
          }),
    );
  }

  Widget _createFechaNac(BuildContext context) {
    return TextFormField(
      controller: _birthDateController,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        print("terrible");

        await _selectDate(context);
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _birthDateController.text = formatter.format(picked);
      });
    }
  }
}
