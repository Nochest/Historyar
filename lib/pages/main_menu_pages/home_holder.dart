import 'package:flutter/material.dart';
import 'package:historyar_app/pages/forum_pages/forum_detail.dart';
import 'package:historyar_app/providers/forum_provider.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/app_bar.dart';
import 'package:historyar_app/widgets/button_app_bar.dart';
import 'package:historyar_app/widgets/card.dart';

//TODO: Home holder for sprint 2
class HomeHolder extends StatefulWidget {

  final int id;
  final int type;

  const HomeHolder({
    required this.id,
    required this.type,
    Key? key
  }) : super(key: key);

  @override
  _HomeHolderState createState() => _HomeHolderState();
}

class _HomeHolderState extends State<HomeHolder> {

  var _forumProvider = ForumProvider();

  ColorPalette _colorPalette = ColorPalette();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colorPalette.lightBlue,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Bienvenido',
          style: TextStyle(color: _colorPalette.yellow),
        ),
      ),
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
                                      Text('Crear Sala Rápida', style: TextStyle(color: _colorPalette.yellow, fontWeight: FontWeight.w700, fontSize: 24.0))
                                    ],
                                  ),
                                ),
                              ),
                              onTap: (){

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
                                          push(MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  ForumDetail(title: snapshot.data[i].title, id: snapshot.data[i].id, description: snapshot.data[i].description,
                                                      type: widget.type, userId: widget.id)
                                          )
                                          );
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
      bottomNavigationBar: historyarBottomAppBar(context, true, false, false, false, widget.id, widget.type),
    );
  }
}
