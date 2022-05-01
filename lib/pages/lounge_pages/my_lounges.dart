import 'package:flutter/material.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_detail.dart';
import 'package:historyar_app/pages/main_menu_pages/lounge_page.dart';
import 'package:historyar_app/providers/lounge_provider.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/input_text.dart';

class MyLounges extends StatefulWidget {

  final int id;
  final int type;
  final bool isguest;
  const MyLounges({
    required this.id,
    required this.type,
    required this.isguest,
    Key? key
  }) : super(key: key);

  @override
  _MyLoungesState createState() => _MyLoungesState();
}

class _MyLoungesState extends State<MyLounges> {

  ColorPalette _colorPalette = ColorPalette();
  InputText _inputText = InputText();
  Alert _alert = Alert();
  var _salaProvider = LoungeProvider();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {

        Navigator.of(context).push(
          MaterialPageRoute(builder:
              (BuildContext context) => Lounge(id: widget.id, type: widget.type,isguest: widget.isguest,)
          ),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: _colorPalette.cream,
        appBar: AppBar(
          backgroundColor: _colorPalette.darkBlue,
          title:
          Text('Mis Salas', style: TextStyle(fontWeight: FontWeight.w700)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder:
                    (BuildContext context) => Lounge(id: widget.id, type: widget.type,isguest: widget.isguest,)
                ),
              );
            },
          ),
        ),
        body: Container(
          child: FutureBuilder(
            future: _salaProvider.getByUserId(widget.id, widget.type),
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
                                title: Text(snapshot.data[i].titulo,
                                    style: TextStyle(
                                        fontSize: 20.0,
                                        color: _colorPalette.darkBlue),
                                    textAlign: TextAlign.justify),
                                subtitle: Text(snapshot.data[i].descripcion,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: _colorPalette.text),
                                    textAlign: TextAlign.justify),
                                isThreeLine: true,
                                trailing: Text(snapshot.data[i].fechaCreacion,
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        color: _colorPalette.text),
                                    textAlign: TextAlign.justify),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder:
                                        (BuildContext context) => LoungeDetail(id: widget.id, type: widget.type, salaId: snapshot.data[i].id, salaName: snapshot.data[i].titulo,isguest: widget.isguest,)
                                    ),
                                  );
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
      ),
    );


  }

}
