import 'package:flutter/material.dart';
import 'package:historyar_app/pages/main_menu_pages/home_holder.dart';
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

  ColorPalette _colorPalette = ColorPalette();
  InputText _inputText = InputText();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  FocusNode focus_email = FocusNode();
  FocusNode focus_password = FocusNode();

  var _usuarioProvider =  UserProvider();

  var _guestProvide = GuestProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: _colorPalette.lightBlue,
        child: Stack(
            children: [
        Padding(
        padding: EdgeInsets.only(top: 180.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: _colorPalette.cream,
              borderRadius: BorderRadius.only(
                topRight: const Radius.circular(25.0),
                topLeft: const Radius.circular(25.0),
              )
          ),
          width: MediaQuery.of(context).size.width,
          height:double.maxFinite,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 24, left: 24.0),
                child: Container(
                  width: double.infinity,
                  child: Text(
                    'Iniciar sesión',
                    style: TextStyle(fontWeight: FontWeight.w700, color: _colorPalette.yellow, fontSize: 32.0),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
                child: _inputText.defaultIText(
                    focus_email,
                    _emailController,
                    TextInputType.emailAddress,
                    'Correo',
                    '',
                    false,
                    'Correo ',
                    signIn
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 12.0),
                child: _inputText.defaultIText(
                    focus_password,
                    _passwordController,
                    TextInputType.text,
                    'Contraseña',
                    '',
                    true,
                    'Contraseña',
                    pass
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 12.0),
                child: Container(
                  alignment: Alignment.centerRight,
                  width: double.maxFinite,
                  child: TextButton(
                    child: Text('Olvidaste tu contraseña?', style: TextStyle(color: _colorPalette.darkBlue, fontWeight: FontWeight.w400, fontSize: 16.0)),
                    onPressed: (){
                      //TODO: Password recover page

                      Navigator.of(context).
                      pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => ForgetPassword()),
                              (Route<dynamic> route) => false);
                    },
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 16.0), child: _loginButton(context)),
              Padding(padding: EdgeInsets.only(top: 8.0),child: _register_text_button(context)),
              Padding(padding: EdgeInsets.only(top:3.0), child:guestlogin(context))
            ],
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 16.0 ), child: Align(alignment: Alignment.topCenter,child: Image.asset('assets/logo.png', width: 240.0, height: 240.0,))),
      ]),
    )
    );
  }
  Widget _loginButton(BuildContext context){
    return Center(
      child: MaterialButton(
          height: 48.0,
          minWidth: 170.0,
          color: _colorPalette.yellow,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)
          ),
          child: Text('Iniciar sesión', style: TextStyle(color: _colorPalette.darkBlue, fontWeight: FontWeight.bold)),
          onPressed: (){
            if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty){

              _usuarioProvider.signIn(_emailController.text, _passwordController.text, context);
    /*
              Navigator.of(context).
              pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomeHolder()),
                      (Route<dynamic> route) => false);

     */
            }else{
              setState(() {
                if(_emailController.text.isEmpty) signIn = true;
                if(_passwordController.text.isEmpty) pass = true;
              });
            }
          }
      ),
    );
  }
  Widget _register_text_button(BuildContext context){
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No tienes una cuenta?', style: TextStyle(color: _colorPalette.text, fontWeight: FontWeight.w400, fontSize: 16.0)),
          TextButton(
            child: Text('Registrate ahora', style: TextStyle(color: _colorPalette.darkBlue, fontWeight: FontWeight.w400, fontSize: 16.0)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            title: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Center(child: Text('Tipo de Usuario', style: TextStyle(color: _colorPalette.darkBlue,fontWeight: FontWeight.w700, fontSize: 24.0)))),
            content: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Elija el tipo de usuario que desea crear', style: TextStyle(color: _colorPalette.text,fontWeight: FontWeight.w400, fontSize: 14.0), textAlign: TextAlign.justify),
                  SizedBox(height: 24.0),
                  teacherButton(context, 'Docente'),
                  SizedBox(height: 8.0),
                  studentbutton(context, 'Estudiante'),
                ],
              ),
            ),
          );
        }
    );
  }
 Widget teacherButton(BuildContext context, String text){
    return MaterialButton(
        height: 36.0,
        minWidth: 126.0,
        color: _colorPalette.lightBlue,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0)
        ),
        child: Text(text, style: TextStyle(color: _colorPalette.yellow, fontWeight: FontWeight.w600)),
        onPressed: (){
          Navigator.of(context).
          pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => TeacherRegister()),
                  (Route<dynamic> route) => true);
        }
    );
  }
  Widget studentbutton(BuildContext context, String text){
    return MaterialButton(
        height: 36.0,
        minWidth: 126.0,
        color: _colorPalette.lightBlue,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0)
        ),
        child: Text(text, style: TextStyle(color: _colorPalette.yellow, fontWeight: FontWeight.w600)),
        onPressed: (){
          Navigator.of(context).
          pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => StudentRegister()),
                  (Route<dynamic> route) => true);
        }
    );
  }

  void guestAlert(BuildContext context){
    showDialog(
        barrierColor: _colorPalette.lightBlue.withOpacity(0.6),
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            backgroundColor: _colorPalette.cream,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            title: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Center(child: Text('Tipo de Usuario', style: TextStyle(color: _colorPalette.darkBlue,fontWeight: FontWeight.w700, fontSize: 24.0)))),
            content: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Elija el tipo de invitado que desea ser', style: TextStyle(color: _colorPalette.text,fontWeight: FontWeight.w400, fontSize: 14.0), textAlign: TextAlign.justify),
                  SizedBox(height: 24.0),
                  guestStudentButton(context, 'Estudiante'),
                  SizedBox(height: 8.0),
                  guestTeacherButton(context, 'Docente'),
                ],
              ),
            ),
          );
        });

  }
  Widget guestStudentButton(BuildContext context, String text){
    return MaterialButton(
        height: 36.0,
        minWidth: 126.0,
        color: _colorPalette.lightBlue,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0)
        ),
        child: Text(text, style: TextStyle(color: _colorPalette.yellow, fontWeight: FontWeight.w600)),
        onPressed: (){
         _guestProvide.guestSinginStudent(context);
        }
    );
  }

  Widget guestTeacherButton(BuildContext context, String text){
   return MaterialButton(
        height: 36.0,
        minWidth: 126.0,
        color: _colorPalette.lightBlue,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0)
        ),
        child: Text(text, style: TextStyle(color: _colorPalette.yellow, fontWeight: FontWeight.w600)),
        onPressed: (){
           _guestProvide.guestSinginDocente(context);
        }
    );
  }
  Widget guestlogin(BuildContext context){
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Text('No tienes una cuenta?', style: TextStyle(color: _colorPalette.text, fontWeight: FontWeight.w400, fontSize: 16.0)),
          TextButton(
            child: Text('Continue as a guest', style: TextStyle(color: _colorPalette.darkBlue, fontWeight: FontWeight.w400, fontSize: 16.0)),
            onPressed: () {
             guestAlert(context);
            },
          )
        ],
      ),
    
    );

  }
}
