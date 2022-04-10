import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:historyar_app/pages/forum_pages/forum_edit.dart';
import 'package:historyar_app/pages/main_menu_pages/community.dart';
import 'package:historyar_app/pages/main_menu_pages/home_holder.dart';
import 'package:historyar_app/pages/sign_in_pages/sign_in.dart';
import 'package:historyar_app/providers/forum_provider.dart';
import 'package:historyar_app/providers/user_provider.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/utils/data_picker.dart';
import 'package:historyar_app/widgets/input_text.dart';

import 'package:intl/intl.dart';

class MyForums extends StatefulWidget {

  final int id;
  final int type;

  const MyForums({
    required this.id,
    required this.type,
    Key? key
  }) : super(key: key);

  @override
  _MyForumsState createState() => _MyForumsState();
}

class _MyForumsState extends State<MyForums> {

  ColorPalette _colorPalette = ColorPalette();
  InputText _inputText = InputText();
  Alert _alert = Alert();
  var _foroProvider = ForumProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorPalette.cream,
      appBar: AppBar(
        backgroundColor: _colorPalette.darkBlue,
        title:
        Text('Mis Publicaciones', style: TextStyle(fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) => Community(id: widget.id, type: widget.type)),
                    (Route<dynamic> route) => false);
          },
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: _foroProvider.getByUserId(widget.id, widget.type),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int i){
                  return Column(
                      children:[
                        Divider(color: Colors.black),
                        Padding(
                          padding: EdgeInsets.only(right: 10.0, left: 10.0),
                          child: ListTile(
                            title: Text(snapshot.data[i].title,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: _colorPalette.darkBlue),
                                textAlign: TextAlign.justify),
                            subtitle: Text(snapshot.data[i].description,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: _colorPalette.text),
                                textAlign: TextAlign.justify),
                            onTap: () {
                                createAlert(context, snapshot.data[i].id);
                            },
                          )
                        ),
                      ]
                  );
                },
              );
            }
          },
        ),
      ),
    );


  }

  void createAlert(BuildContext context, int id) {
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
                child: Center(child: Text('Opciones', style: TextStyle(color: _colorPalette.darkBlue,fontWeight: FontWeight.w700, fontSize: 24.0)))),
            content: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Elija la opción', style: TextStyle(color: _colorPalette.text,fontWeight: FontWeight.w400, fontSize: 14.0), textAlign: TextAlign.justify),
                  SizedBox(height: 24.0),
                  editButton(context, id),
                  SizedBox(height: 8.0),
                  deleteButton(context, id),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget editButton(BuildContext context, int id){
    return MaterialButton(
        height: 36.0,
        minWidth: 126.0,
        color: _colorPalette.lightBlue,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0)
        ),
        child: Text("Editar", style: TextStyle(color: _colorPalette.yellow, fontWeight: FontWeight.w600)),
        onPressed: (){
          Navigator.of(context).
          pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => ForumEdit(id: id, type: widget.type, userId: widget.id)),
                  (Route<dynamic> route) => true);
        }
    );
  }

  Widget deleteButton(BuildContext context, int id){
    return MaterialButton(
        height: 36.0,
        minWidth: 126.0,
        color: _colorPalette.lightBlue,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0)
        ),
        child: Text("Eliminar", style: TextStyle(color: _colorPalette.yellow, fontWeight: FontWeight.w600)),
        onPressed: (){
          _foroProvider.borrarPublicacion(id, widget.type, widget.id, context);
        }
    );
  }
}
