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

class TeacherEditProfile extends StatefulWidget {

  final int id;
  final int type;

  const TeacherEditProfile({
    required this.id,
    required this.type,
    Key? key
  }) : super(key: key);

  @override
  _TeacherEditProfile createState() => _TeacherEditProfile();
}

class _TeacherEditProfile extends State<TeacherEditProfile> {

  ColorPalette _colorPalette = ColorPalette();
  InputText _inputText = InputText();
  Alert _alert = Alert();
  var _usuarioProvider = UsuarioProvider();

  bool names = false;
  bool surnames = false;
  bool email = false;
  bool mobile = false;
  bool school = false;
  bool birthDate = false;
  bool celularVisible = false;
  bool emailVisible = false;

  DateFormat formatter = DateFormat('yyyy-MM-dd');

  FocusNode focus_names = FocusNode();
  FocusNode focus_surnames = FocusNode();
  FocusNode focus_email = FocusNode();
  FocusNode focus_mobile = FocusNode();
  FocusNode focus_school = FocusNode();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _schoolController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();

  var selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    focus_names.addListener(() {
      setState(() {});
    });
    focus_surnames.addListener(() {
      setState(() {});
    });
    focus_email.addListener(() {
      setState(() {});
    });
    focus_mobile.addListener(() {
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

            print(snapshot.data);
            _emailController.text = snapshot.data.email;
            _nameController.text = snapshot.data.nombres;
            _surnameController.text = snapshot.data.apellidos;
            _birthDateController.text = snapshot.data.fechaNacimiento;
            _schoolController.text = snapshot.data.institucionEducativa;
            _mobileController.text = snapshot.data.celular;
            celularVisible = snapshot.data.celularVisible;
            emailVisible = snapshot.data.emailVisible;

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
                        padding: EdgeInsets.only(top: 24.0),
                        child: _inputText.defaultIText(
                            focus_mobile,
                            _mobileController,
                            TextInputType.phone,
                            'Número de celular',
                            '',
                            false,
                            'Número de celular',
                            mobile),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24.0),
                        child: _inputText.defaultIText(
                            focus_school,
                            _schoolController,
                            TextInputType.text,
                            'Institución Educativa',
                            '',
                            false,
                            'Institución Educativa',
                            school),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 24.0),
                          child: Row(
                            children: <Widget>[
                              Checkbox(
                                  value: celularVisible, 
                                  onChanged: (newValue){
                                    setState((){
                                      celularVisible = newValue!;
                                    });
                                  },
                              ),
                              Text("Celular Visible para otros usuarios")
                            ],
                          )
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 24.0),
                          child: Row(
                            children: <Widget>[
                              Checkbox(
                                value: emailVisible,
                                onChanged: (newValue){
                                  setState((){
                                    emailVisible = newValue!;
                                  });
                                },
                              ),
                              Text("Correo Visible para otros usuarios")
                            ],
                          )
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
            if (_nameController.text.isNotEmpty &&
                _surnameController.text.isNotEmpty &&
                _birthDateController.text.isNotEmpty &&
                _mobileController.text.isNotEmpty &&
                _schoolController.text.isNotEmpty &&
                _emailController.text.isNotEmpty) {
              _usuarioProvider.actualizarDocente(
                  widget.id,
                  widget.type,
                  _mobileController.text,
                  _schoolController.text,
                  _nameController.text,
                  _surnameController.text,
                  _emailController.text,
                  _birthDateController.text,
                  celularVisible,
                  emailVisible,
                  context);
              //Navigator.of(context).pushReplacement(MaterialPageRoute(
              //   builder: (BuildContext context) => SignIn()));
            } else {
              setState(() {
                if (_nameController.text.isEmpty) names = true;
                if (_surnameController.text.isEmpty) surnames = true;
                if (_birthDateController.text.isEmpty) birthDate = true;
                if (_mobileController.text.isEmpty) mobile = true;
                if (_schoolController.text.isEmpty) school = true;
                if (_emailController.text.isEmpty) email = true;
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
