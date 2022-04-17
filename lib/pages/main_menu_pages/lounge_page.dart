import 'package:flutter/material.dart';
import 'package:historyar_app/model/lounge.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_creation.dart';
import 'package:historyar_app/pages/lounge_pages/my_lounges.dart';
import 'package:historyar_app/providers/lounge_provider.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/app_bar.dart';
import 'package:historyar_app/widgets/button_app_bar.dart';

class Lounge extends StatefulWidget {
  final int id;
  final int type;

  const Lounge({required this.id, required this.type, Key? key})
      : super(key: key);

  @override
  _LoungeState createState() => _LoungeState();
}

class _LoungeState extends State<Lounge> {

  ColorPalette _colorPalette = ColorPalette();
  var _salaProvider = LoungeProvider();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colorPalette.lightBlue,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Salas',
          style: TextStyle(color: _colorPalette.yellow),
        ),
      ),
      backgroundColor: _colorPalette.cream,
      body: FutureBuilder(
        future: _salaProvider.getByUserId(widget.id, widget.type),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: _colorPalette.lightBlue,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: _colorPalette.yellow,
                          width: 2.0,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.event_note,
                          color: _colorPalette.yellow,
                        ),
                        title: Text(
                          'Ingresar a Sala',
                          style: TextStyle(
                              color: _colorPalette.yellow,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700),
                        ),
                        onTap: () {

                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: _colorPalette.lightBlue,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: _colorPalette.yellow,
                          width: 2.0,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.event_note,
                          color: _colorPalette.yellow,
                        ),
                        title: Text(
                          'Mis Salas',
                          style: TextStyle(
                              color: _colorPalette.yellow,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder:
                                  (BuildContext context) => MyLounges(id: widget.id, type: widget.type)
                          ));
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: _colorPalette.lightBlue,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: _colorPalette.yellow,
                          width: 2.0,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.event_note,
                          color: _colorPalette.yellow,
                        ),
                        title: Text(
                          'Crear sala',
                          style: TextStyle(
                              color: _colorPalette.yellow,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder:
                                  (BuildContext context) => LoungeCreation(id: widget.id, type: widget.type)
                          ));
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Estadísticas',
                          style: TextStyle(
                              color: _colorPalette.yellow,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 24.0),
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: _colorPalette.yellow, width: 2.0)),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Salas creadas',
                                      style: TextStyle(
                                          color: _colorPalette.darkBlue,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.left,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                      },
                                      child: Text('25',
                                          style: TextStyle(
                                              color: _colorPalette.yellow,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Exámenes generados',
                                      style: TextStyle(
                                          color: _colorPalette.darkBlue,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.left,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                      },
                                      child: Text('10',
                                          style: TextStyle(
                                              color: _colorPalette.yellow,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Historias Creadas',
                                      style: TextStyle(
                                          color: _colorPalette.darkBlue,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.left,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                      },
                                      child: Text('100',
                                          style: TextStyle(
                                              color: _colorPalette.yellow,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Promedio de Notas',
                                      style: TextStyle(
                                          color: _colorPalette.darkBlue,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.left,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                      },
                                      child: Text('18.5',
                                          style: TextStyle(
                                              color: _colorPalette.yellow,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: historyarButtonApp(context, false),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: historyarBottomAppBar(
          context, false, true, false, false, widget.id, widget.type),
    );
  }

}
