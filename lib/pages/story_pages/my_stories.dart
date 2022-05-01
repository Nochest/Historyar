import 'package:flutter/material.dart';
import 'package:historyar_app/pages/main_menu_pages/profile_page.dart';
import 'package:historyar_app/pages/story_pages/story_detail.dart';
import 'package:historyar_app/providers/story_provider.dart';
import 'package:historyar_app/utils/color_palette.dart';

class MyStories extends StatefulWidget {

  final int id;
  final int type;

  const MyStories({
    required this.id,
    required this.type,
    Key? key
  }) : super(key: key);

  @override
  _MyStoriesState createState() => _MyStoriesState();
}

class _MyStoriesState extends State<MyStories> {

  ColorPalette _colorPalette = ColorPalette();
  var _storyProvider = StoryProvider();

  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {

        Navigator.of(context).push(
          MaterialPageRoute(builder:
              (BuildContext context) => Profile(id: widget.id, type: widget.type)
          ),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: _colorPalette.cream,
        appBar: AppBar(
          backgroundColor: _colorPalette.darkBlue,
          title:
          Text('Mis Historias', style: TextStyle(fontWeight: FontWeight.w700))
        ),
        body: Container(
          child: FutureBuilder(
            future: _storyProvider.getByUserId(widget.id, widget.type),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int i) {
                    if((_currentIndex == 0 && snapshot.data[i].favorito == true) ||
                        (_currentIndex == 1) || (_currentIndex == 2 && snapshot.data[i].favorito == false)) {
                      return Column(
                          children: [
                            Divider(color: Colors.black),
                            Padding(
                                padding: EdgeInsets.only(
                                    right: 10.0, left: 10.0),
                                child: ListTile(
                                  title: Text(snapshot.data[i].nombre,
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: _colorPalette.darkBlue),
                                      textAlign: TextAlign.justify),
                                  subtitle: Text(snapshot.data[i].descripcion,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: _colorPalette.text),
                                      textAlign: TextAlign.justify),
                                  trailing: Wrap(
                                      spacing: 12,
                                      children: <Widget>[
                                        IconButton(
                                            onPressed: () {
                                              favoriteAlert(
                                                  context, snapshot.data[i].id,
                                                  snapshot.data[i].favorito);
                                            },
                                            icon: snapshot.data[i].favorito
                                                ? Icon(Icons.favorite,
                                                color: Colors.red)
                                                : Icon(
                                                Icons.favorite_border_outlined)
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              createAlert(
                                                  context, snapshot.data[i].id);
                                            },
                                            icon: Icon(Icons.delete)
                                        )
                                      ]
                                  ),
                                  onTap: () {
                                    //createAlert(context, snapshot.data[i].id);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                StoryDetail(id: widget.id,
                                                    historiaId: snapshot.data[i]
                                                        .id,
                                                    type: widget.type)
                                        )
                                    );
                                  },
                                )
                            ),
                          ]
                      );
                    } else {
                      return
                        SizedBox(height: 0);
                    }
                  },
                );
              }
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items:[
            new BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favoritos',
              backgroundColor: Colors.red,

            ),
            new BottomNavigationBarItem(
                icon: Icon(Icons.supervisor_account_rounded),
                label:'Todos',
                backgroundColor: Colors.blue
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),
              label: 'No Favoritos',
              backgroundColor: Colors.green,
            )
          ],
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  void createAlert(BuildContext context, int historiaId) {
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
                  Text('El siguiente video será eliminado de forma permanente', style: TextStyle(color: _colorPalette.text,fontWeight: FontWeight.w400, fontSize: 14.0), textAlign: TextAlign.justify),
                  SizedBox(height: 24.0),
                  MaterialButton(
                      height: 36.0,
                      minWidth: 126.0,
                      color: _colorPalette.lightBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0)
                      ),
                      child: Text("Cancelar", style: TextStyle(color: _colorPalette.yellow, fontWeight: FontWeight.w600)),
                      onPressed: (){
                        Navigator.of(context).pop();
                      }
                  ),
                  SizedBox(height: 8.0),
                  MaterialButton(
                      height: 36.0,
                      minWidth: 126.0,
                      color: _colorPalette.lightBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0)
                      ),
                      child: Text("Eliminar", style: TextStyle(color: _colorPalette.yellow, fontWeight: FontWeight.w600)),
                      onPressed: (){
                        _storyProvider.deleteHistoria(widget.id, historiaId, widget.type, context);
                      }
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  void favoriteAlert(BuildContext context, int historiaId, bool favorito) {

    String pregunta = "La siguiente historia se marcará como favorita";

    if(favorito == false) {
      pregunta = "La siguiente historia se desmarcará como favorita";
    }

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
                  Text(pregunta, style: TextStyle(color: _colorPalette.text,fontWeight: FontWeight.w400, fontSize: 14.0), textAlign: TextAlign.justify),
                  SizedBox(height: 24.0),
                  MaterialButton(
                      height: 36.0,
                      minWidth: 126.0,
                      color: _colorPalette.lightBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0)
                      ),
                      child: Text("Cancelar", style: TextStyle(color: _colorPalette.yellow, fontWeight: FontWeight.w600)),
                      onPressed: (){
                        Navigator.of(context).pop();
                      }
                  ),
                  SizedBox(height: 8.0),
                  MaterialButton(
                      height: 36.0,
                      minWidth: 126.0,
                      color: _colorPalette.lightBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0)
                      ),
                      child: Text("Aceptar", style: TextStyle(color: _colorPalette.yellow, fontWeight: FontWeight.w600)),
                      onPressed: (){
                        _storyProvider.favorito(widget.id, historiaId, widget.type, context);
                      }
                  )
                ],
              ),
            ),
          );
        }
    );
  }
}
