import 'package:flutter/material.dart';
import 'package:historyar_app/pages/register_pages/teacher_register.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/app_bar.dart';
import 'package:historyar_app/widgets/button_app_bar.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  ColorPalette _colorPalette = ColorPalette();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorPalette.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: _colorPalette.lightBlue,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0), bottomRight:  Radius.circular(25.0))
                  ),
                  child: Text('Perfil', style: TextStyle(color: _colorPalette.yellow, fontWeight: FontWeight.w700, fontSize: 24.0)),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Image.asset('assets/profile.png', width: 160.0, height: 160.0)
                ),
                Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: Text('Usuario_holder', style: TextStyle(color: _colorPalette.yellow, fontSize: 24.0, fontWeight: FontWeight.w700))
                ),
                Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text('ID de usuario: 12131231312312312', style: TextStyle(color: _colorPalette.darkBlue, fontSize: 16.0, fontWeight: FontWeight.w700))
                ),
                Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: Container(
                      height: 56.0,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: _colorPalette.lightBlue,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: _colorPalette.yellow, width: 2.0)
                      ),
                      child: GestureDetector(
                        child: ListTile(
                          leading: Icon(Icons.event_note, color: _colorPalette.yellow),
                          title: Text('Mis notas', style: TextStyle(color: _colorPalette.yellow, fontSize: 24.0, fontWeight: FontWeight.w700)),
                        ),
                        onTap: () {
                          //TODO: do list of notes
                        },
                      ),
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Text('Información personal', style: TextStyle(color: _colorPalette.yellow, fontSize: 24.0, fontWeight: FontWeight.w700)),
                            Spacer(),
                            Text('Editar', style: TextStyle(color: _colorPalette.lightBlue, fontSize: 12.0, fontWeight: FontWeight.w500)),
                          ],
                        )
                    ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: 24.0),
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: _colorPalette.yellow, width: 2.0)
                      ),
                      child:  Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center ,
                          children: [
                            Text('Nombre completo', style: TextStyle(color: _colorPalette.text, fontSize: 14.0, fontWeight: FontWeight.w400)),
                            Text('Josealdo Camogliano Württele', style: TextStyle(color: _colorPalette.yellow, fontSize: 16.0, fontWeight: FontWeight.w600)),
                            SizedBox(height: 8.0),
                            Text('Correo electronico', style: TextStyle(color: _colorPalette.text, fontSize: 14.0, fontWeight: FontWeight.w400)),
                            Text('test@gmail.com', style: TextStyle(color: _colorPalette.yellow, fontSize: 16.0, fontWeight: FontWeight.w600)),
                            SizedBox(height: 8.0),
                            Text('Numero de celular', style: TextStyle(color: _colorPalette.text, fontSize: 14.0, fontWeight: FontWeight.w400)),
                            Text('99999999', style: TextStyle(color: _colorPalette.yellow, fontSize: 16.0, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    )
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: historyarButtonApp(context, false),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: historyarBottomAppBar(context, false, false, false, true),
    );
  }
}
