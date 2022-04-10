import 'package:flutter/material.dart';
import 'package:historyar_app/model/forum_holder.dart';
import 'package:historyar_app/pages/forum_pages/forum_creation.dart';
import 'package:historyar_app/pages/forum_pages/forum_detail.dart';
import 'package:historyar_app/pages/forum_pages/my_forums.dart';
import 'package:historyar_app/providers/forum_provider.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/app_bar.dart';
import 'package:historyar_app/widgets/button_app_bar.dart';
import 'package:historyar_app/widgets/card.dart';

class Community extends StatefulWidget {

  final int id;
  final int type;

  const Community({
    required this.id,
    required this.type,
    Key? key
  }) : super(key: key);

  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {

  var _forumProvider = ForumProvider();

  ColorPalette _colorPalette = ColorPalette();

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: _colorPalette.cream,
        body: FutureBuilder(
          future: _forumProvider.getAll(widget.type),

          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Center(child: CircularProgressIndicator());
            } else {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                          children: [
                            Container(
                              width: double.maxFinite,
                              height: 48.0,
                              decoration: BoxDecoration(
                                  color: _colorPalette.lightBlue,
                                  border: Border.all(color: _colorPalette.yellow, width: 2.0),
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.0))
                              ),
                              child: Center(
                                child: Text('Comunidad', style: TextStyle(color: _colorPalette.yellow, fontWeight: FontWeight.w700, fontSize: 24.0)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 24.0),
                              child: GestureDetector(
                                child: Container(
                                  width: double.maxFinite,
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                    color: _colorPalette.lightBlue,
                                    border: Border.all(color: _colorPalette.yellow, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child:Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.add, color: _colorPalette.yellow, size: 24.0,),
                                        SizedBox(width: 20.0),
                                        Text('Crear Publicación', style: TextStyle(color: _colorPalette.yellow, fontWeight: FontWeight.w700, fontSize: 24.0))
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  //TODO: Go to my notes

                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                      builder: (BuildContext context) => ForumCreation(id: widget.id, type: widget.type)), (
                                      Route<dynamic> route) => false);
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 24.0),
                              child: GestureDetector(
                                child: Container(
                                  width: double.maxFinite,
                                  height: 48.0,
                                  decoration: BoxDecoration(
                                    color: _colorPalette.lightBlue,
                                    border: Border.all(color: _colorPalette.yellow, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child:Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.notes_sharp, color: _colorPalette.yellow, size: 24.0,),
                                        SizedBox(width: 20.0),
                                        Text('Mis publicaciones', style: TextStyle(color: _colorPalette.yellow, fontWeight: FontWeight.w700, fontSize: 24.0))
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  //TODO: Go to my notes

                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                                      builder: (BuildContext context) => MyForums(id: widget.id, type: widget.type)), (
                                      Route<dynamic> route) => false);
                                },
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 24.0),
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Text('Foro destacado', style: TextStyle(color: _colorPalette.yellow, fontWeight: FontWeight.w700, fontSize: 24.0))
                                )
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 24.0),
                              child: GestureDetector(
                                child: VerticalCardItem(0, snapshot.data),
                                onTap: (){
                                  Navigator.of(context).
                                  pushAndRemoveUntil(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ForumDetail(title: snapshot.data[0].title, id: snapshot.data[0].id, description: snapshot.data[0].description,
                                              type: widget.type, userId: widget.id)),
                                          (Route<dynamic> route) => true);
                                },
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 24.0),
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    child: Text('Foros', style: TextStyle(color: _colorPalette.yellow, fontWeight: FontWeight.w700, fontSize: 24.0))
                                )
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 24.0),
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: SizedBox(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, i){
                                        return GestureDetector(
                                          child: VerticalCardItem(i, snapshot.data),
                                          onTap: (){
                                            //TODO: Go to journey detail passing data

                                            Navigator.of(context).
                                            pushAndRemoveUntil(MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    ForumDetail(title: snapshot.data[i].title, id: snapshot.data[i].id, description: snapshot.data[i].description,
                                                        type: widget.type, userId: widget.id)),
                                                    (Route<dynamic> route) => true);
                                          },
                                        );
                                      }
                                  ),
                                ),
                              ),
                            ),
                          ]
                      )
                  ),
                ),
              );
            }
          },
        ),
      floatingActionButton: historyarButtonApp(context, false),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: historyarBottomAppBar(context, false, false, true, false, widget.id, widget.type),
    );
  }
}
