import 'package:flutter/material.dart';
import 'package:historyar_app/model/forum_holder.dart';
import 'package:historyar_app/pages/main_menu_pages/forum_detail.dart';
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
                              Icon(Icons.notes_sharp, color: _colorPalette.yellow, size: 24.0,),
                              SizedBox(width: 20.0),
                              Text('Mis anotaciones', style: TextStyle(color: _colorPalette.yellow, fontWeight: FontWeight.w700, fontSize: 24.0))
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        //TODO: Go to my notes
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
                    child: VerticalCardItem(0),
                    onTap: (){
                      Navigator.of(context).
                      pushAndRemoveUntil(MaterialPageRoute(
                          builder: (BuildContext context) => ForumDetail(title: rowList[0].title, id: widget.id, type: widget.type,)), (Route<dynamic> route) => true);
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
                              itemCount: rowList.length,
                              itemBuilder: (context, i){
                                return GestureDetector(
                                  child: VerticalCardItem(i),
                                  onTap: (){
                                    //TODO: Go to journey detail passing data

                                  },
                                );
                              }
                          ),
                        ),
                    ),
                ),
              ],
            )
          ),
        ),
      ),
      floatingActionButton: historyarButtonApp(context, false),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: historyarBottomAppBar(context, false, false, true, false, widget.id, widget.type),
    );
  }
}
