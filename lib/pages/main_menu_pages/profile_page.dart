import 'package:flutter/material.dart';
import 'package:historyar_app/helpers/constant_helpers.dart';
import 'package:historyar_app/model/user.dart';
import 'package:historyar_app/pages/profile_pages/student_edit_profile.dart';
import 'package:historyar_app/pages/profile_pages/teacher_edit_profile.dart';
import 'package:historyar_app/pages/register_pages/teacher_register.dart';
import 'package:historyar_app/providers/user_provider.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/app_bar.dart';
import 'package:historyar_app/widgets/button_app_bar.dart';
import 'package:historyar_app/widgets/input_text.dart';

class Profile extends StatefulWidget {
  final int id;
  final int type;

  const Profile({required this.id, required this.type, Key? key})
      : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var _usuarioProvider = UsuarioProvider();

  InputText _inputText = InputText();
  ColorPalette _colorPalette = ColorPalette();

  bool password = false;

  FocusNode focus_password = FocusNode();

  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    focus_password.addListener(() {
      setState(() {});
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colorPalette.lightBlue,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Perfil',
          style: TextStyle(color: _colorPalette.yellow),
        ),
      ),
      backgroundColor: _colorPalette.cream,
      body: FutureBuilder(
        future: _usuarioProvider.getUser(widget.id),
        builder: (BuildContext context, AsyncSnapshot<Usuario?> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/profile.png',
                      width: 160.0,
                      height: 160.0,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.data!.nombres,
                      style: TextStyle(
                        color: _colorPalette.yellow,
                        fontSize: 24.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'ID de usuario: ${snapshot.data!.id.toString()}',
                      style: TextStyle(
                        color: _colorPalette.darkBlue,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: _colorPalette.lightBlue,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: _colorPalette.yellow,
                          width: 2.0,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.event_note,
                          color: _colorPalette.yellow,
                        ),
                        title: Text(
                          'Mis Historias',
                          style: TextStyle(
                              color: _colorPalette.yellow,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Información personal',
                          style: TextStyle(
                              color: _colorPalette.yellow,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.left,
                        ),
                        TextButton(
                          onPressed: () {
                            if (widget.type == Constants.ALUMNO_USUARIO)
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => StudentEditProfile(
                                    id: widget.id,
                                    type: widget.type,
                                  ),
                                ),
                              );
                            else
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => TeacherEditProfile(
                                    id: widget.id,
                                    type: widget.type,
                                  ),
                                ),
                              );
                          },
                          child: Text('Editar',
                              style: TextStyle(
                                  color: _colorPalette.lightBlue,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 24.0),
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: _colorPalette.yellow, width: 2.0)),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Nombre completo',
                                    style: TextStyle(
                                        color: _colorPalette.text,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400)),
                                Text(
                                    snapshot.data!.nombres +
                                        " " +
                                        snapshot.data!.apellidos,
                                    style: TextStyle(
                                        color: _colorPalette.yellow,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 8.0),
                                Text('Correo electronico',
                                    style: TextStyle(
                                        color: _colorPalette.text,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400)),
                                Text(snapshot.data!.email,
                                    style: TextStyle(
                                        color: _colorPalette.yellow,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 8.0),
                                Text('Fecha de nacimiento',
                                    style: TextStyle(
                                        color: _colorPalette.text,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400)),
                                Text(snapshot.data!.fechaNacimiento,
                                    style: TextStyle(
                                        color: _colorPalette.yellow,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 50.0),
                        child: _eliminarButton(context)),
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: historyarButtonApp(context, false),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: historyarBottomAppBar(
          context, false, false, false, true, widget.id, widget.type),
    );
  }

  Widget _eliminarButton(BuildContext context) {
    return Center(
      child: MaterialButton(
          height: 48.0,
          minWidth: 170.0,
          color: _colorPalette.lightBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)),
          child: Text('Eliminar Cuenta',
              style: TextStyle(
                  color: _colorPalette.yellow, fontWeight: FontWeight.bold)),
          onPressed: () {
            createAlert(context);
          }),
    );
  }

  void createAlert(BuildContext context) {
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
                    child: Text("Eliminar cuenta",
                        style: TextStyle(
                            color: _colorPalette.darkBlue,
                            fontWeight: FontWeight.w700,
                            fontSize: 24.0)))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: SingleChildScrollView(
                        child: Text(
                            "Ingrese su contraseña para eliminar su cuenta.",
                            style: TextStyle(
                                color: _colorPalette.text,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.0),
                            textAlign: TextAlign.justify))),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: _inputText.defaultIText(
                      focus_password,
                      _passwordController,
                      TextInputType.text,
                      'Ingrese su contraeña',
                      '',
                      true,
                      'Ingrese su contraeña',
                      password),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
                    child: default_button(context)),
                Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: accept_button(context))
              ],
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
          setState(() {
            _passwordController.text = "";
          });
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
          if (_passwordController.text.isNotEmpty) {
            _usuarioProvider.borrarCuenta(
                widget.id, _passwordController.text, context);
          } else {
            setState(() {
              _passwordController.text = "";
              password = true;
            });
          }
        });
  }
}
