import 'package:flutter/material.dart';
import 'package:historyar_app/pages/main_menu_pages/community.dart';
import 'package:historyar_app/pages/main_menu_pages/home_holder.dart';
import 'package:historyar_app/pages/main_menu_pages/lounge_page.dart';
import 'package:historyar_app/pages/main_menu_pages/profile_page.dart';
import 'package:historyar_app/utils/color_palette.dart';

ColorPalette _colorPalette = ColorPalette();

Widget historyarBottomAppBar( BuildContext context, bool b1, bool b2, bool b3, bool b4, int id, int type){
  return BottomAppBar(
    color: _colorPalette.lightBlue,
    child: Container(
      height: 54.0,
      color: _colorPalette.lightBlue,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                GestureDetector(
                  child: Icon(Icons.home, color: b1? _colorPalette.yellow : _colorPalette.info, size: 32.0),
                  onTap: (){
                    Navigator.push(
                        context,
                        PageRouteBuilder(pageBuilder: (context, animation1, animation2) => HomeHolder(id: id, type: type), transitionDuration: Duration.zero)
                    );
                  },
                ),
                Center(child: Text('Menú', style: TextStyle(color: b1? _colorPalette.yellow : _colorPalette.info, fontWeight: FontWeight.w700, fontSize: 11.0)))
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 64.0),
              child: Column(
                children: [
                  GestureDetector(
                    child: Icon(Icons.meeting_room_rounded, color: b2? _colorPalette.yellow : _colorPalette.info, size: 32.0),
                    onTap: (){
                      Navigator.push(
                          context,
                          PageRouteBuilder(pageBuilder: (context, animation1, animation2) => Lounge(id: id, type: type), transitionDuration: Duration.zero)
                      );
                    },
                  ),
                  Center(child: Text('Salas', style: TextStyle(color: b2? _colorPalette.yellow : _colorPalette.info, fontWeight: FontWeight.w700, fontSize: 11.0)))
                ],
              ),
            ),
            Column(
              children: [
                GestureDetector(
                  child: Icon(Icons.event_note, color: b3? _colorPalette.yellow : _colorPalette.info, size: 32.0),
                  onTap: (){
                    Navigator.push(
                        context,
                        PageRouteBuilder(pageBuilder: (context, animation1, animation2) => Community(id: id, type: type), transitionDuration: Duration.zero)
                    );
                  },
                ),
                Center(child: Text('Comunidad', style: TextStyle(color: b3? _colorPalette.yellow : _colorPalette.info, fontWeight: FontWeight.w700, fontSize: 11.0)))
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  child: Icon(Icons.person, color: b4? _colorPalette.yellow : _colorPalette.info, size: 32.0),
                  onTap: (){
                    Navigator.push(
                        context,
                        PageRouteBuilder(pageBuilder: (context, animation1, animation2) => Profile(id: id, type: type), transitionDuration: Duration.zero)
                    );
                  },
                ),
                Center(child: Text('Mi Perfil', style: TextStyle(color: b4? _colorPalette.yellow : _colorPalette.info, fontWeight: FontWeight.w700, fontSize: 11.0)))
              ],
            )
          ],
        ),
      ),
    ),
  );
}