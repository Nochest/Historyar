
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorPalette.cream,
      appBar: AppBar(
        backgroundColor: _colorPalette.darkBlue,
        title:
        Text('Mis Historias', style: TextStyle(fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) => Profile(id: widget.id, type: widget.type)),
                    (Route<dynamic> route) => false);
          },
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: _storyProvider.getByUserId(widget.id, widget.type),
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
                              onTap: () {
                                //createAlert(context, snapshot.data[i].id);
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (BuildContext context) => StoryDetail(id: widget.id, historiaId: snapshot.data[i].id, type: widget.type)),
                                        (Route<dynamic> route) => false);
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
}
