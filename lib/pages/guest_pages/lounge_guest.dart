import 'package:flutter/material.dart';
import 'package:historyar_app/model/attendance.dart';
import 'package:historyar_app/model/story.dart';
import 'package:historyar_app/pages/guest_pages/create_history_guest.dart';
import 'package:historyar_app/pages/guest_pages/guiz_resolution_guest.dart';
import 'package:historyar_app/pages/guest_pages/story_list_guest.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_participants_story_list.dart';
import 'package:historyar_app/pages/main_menu_pages/create_history.dart';
import 'package:historyar_app/pages/main_menu_pages/lounge_page.dart';
import 'package:historyar_app/pages/quiz_pages/quiz_resolution.dart';
import 'package:historyar_app/pages/sign_in_pages/sign_in.dart';
import 'package:historyar_app/pages/story_pages/story_visualizer.dart';
import 'package:historyar_app/providers/attendance_provider.dart';
import 'package:historyar_app/providers/quiz_provider.dart';
import 'package:historyar_app/providers/story_provider.dart';
import 'package:historyar_app/utils/color_palette.dart';

class LoungeGuest extends StatefulWidget {
  final int id;
  final int salaId;
  final int asistenciaId;
  final String salaName;

  const LoungeGuest(
      {required this.id,
        required this.salaId,
        required this.salaName,
        required this.asistenciaId,
        Key? key})
      : super(key: key);

  @override
  _LoungeGuestState createState() => _LoungeGuestState();
}

class _LoungeGuestState extends State<LoungeGuest> {
  Widget _buildIcon(int index, String name) {
    return Container(
      height: 80.0,
      width: 80.0,
      child: Column(
        children: [
          GestureDetector(
            child: Icon(Icons.attribution_rounded, size: 60.0),
            onTap: () {},
          ),
          Center(
              child: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.0),
                overflow: TextOverflow.clip,
                maxLines: 1,
                softWrap: false,
              ))
        ],
      ),
    );
  }

  ColorPalette _colorPalette = ColorPalette();
  var _atencionProvider = AttendanceProvider();
  var _cuestionarioProvider = QuizProvider();
  var _storyProvider = StoryProvider();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  SignIn()),
        );
        return true;
      },
      child: Scaffold(
          backgroundColor: _colorPalette.cream,
          appBar: AppBar(
            backgroundColor: _colorPalette.darkBlue,
            title: Text('Sala ${widget.salaName}',
                style: TextStyle(fontWeight: FontWeight.w700)),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          SignIn()),
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mi Historia',
                        style: TextStyle(
                            color: _colorPalette.yellow,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  FutureBuilder(
                      future: _storyProvider.getByUserIdAndLoungeId(
                          widget.id, widget.salaId),
                      builder: (BuildContext context,
                          AsyncSnapshot<Historia?> snapshot) {
                        if (!snapshot.hasData) {
                          return MaterialButton(
                              height: 30.0,
                              minWidth: 100.0,
                              color: _colorPalette.lightBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100.0)),
                              child: Text("Subir Historia",
                                  style: TextStyle(
                                      color: _colorPalette.text,
                                      fontWeight: FontWeight.w600)),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          CreateHistoryGuest(
                                              id: widget.id,
                                              salaId: widget.salaId)),
                                );
                              });
                        } else {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      StoryVisualizer(
                                          id: widget.id,
                                          historiaId: snapshot.data!.id,
                                          url: snapshot.data!.url,
                                          type: 1)));
                            }, // Image tapped
                            child: Image.asset(
                              'assets/video.png',
                              fit: BoxFit.cover, // Fixes border issues
                            ),
                          );
                        }
                      }),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Historias',
                        style: TextStyle(
                            color: _colorPalette.yellow,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      ),
                      MaterialButton(
                          height: 30.0,
                          minWidth: 100.0,
                          color: _colorPalette.lightBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0)),
                          child: Text("Ver",
                              style: TextStyle(
                                  color: _colorPalette.text,
                                  fontWeight: FontWeight.w600)),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      StoryListGuest(
                                        id: widget.id,
                                        salaId: widget.salaId,
                                        salaName: widget.salaName,
                                        asistenciaId: widget.asistenciaId,
                                      )),
                            );
                          })
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Participantes',
                        style: TextStyle(
                            color: _colorPalette.yellow,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  FutureBuilder(
                      future: _atencionProvider
                          .getAttendancesByLoungeId(widget.salaId),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Asistencia>> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return Container(
                              child: Wrap(
                                direction: Axis.horizontal,
                                spacing: 5.0,
                                runSpacing: 5.0,
                                children: snapshot.data!
                                    .map((e) => _buildIcon(e.id, e.nombres))
                                    .toList(),
                              ));
                        }
                      }),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cuestionario',
                        style: TextStyle(
                            color: _colorPalette.yellow,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      ),
                      FutureBuilder(
                          future: _cuestionarioProvider
                              .getQuizByLoungeId(widget.salaId),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data == null) {
                              return Text(
                                'No Disponible',
                                style: TextStyle(
                                    color: _colorPalette.text,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              );
                            } else {
                              return FutureBuilder(
                                  future: _atencionProvider.getById(widget.asistenciaId),
                                  builder:
                                      (BuildContext context, AsyncSnapshot atencion) {
                                    print(atencion.data);
                                    if (atencion.data == null || atencion.data.nota == null) {
                                      return MaterialButton(
                                          height: 30.0,
                                          minWidth: 100.0,
                                          color: _colorPalette.lightBlue,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(100.0)),
                                          child: Text("Resolver",
                                              style: TextStyle(
                                                  color: _colorPalette.text,
                                                  fontWeight: FontWeight.w600)),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext context) =>
                                                      QuizResolutionGuest(
                                                        id: widget.id,
                                                        salaId: widget.salaId,
                                                        salaName: widget.salaName,
                                                        asistenciaId: widget.asistenciaId,
                                                      )),
                                            );
                                          });
                                    } else {
                                      return Text(
                                        "Realizado",
                                        style: TextStyle(
                                            color: _colorPalette.text,
                                            fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                      );
                                    }
                                  });
                            }
                          }),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nota',
                        style: TextStyle(
                            color: _colorPalette.yellow,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w700),
                        textAlign: TextAlign.left,
                      ),
                      FutureBuilder(
                          future: _atencionProvider.getById(widget.asistenciaId),
                          builder:
                              (BuildContext context, AsyncSnapshot atencion) {
                            print(atencion.data);
                            if (atencion.data == null || atencion.data.nota == null) {
                              return Text(
                                'Sin calificar',
                                style: TextStyle(
                                    color: _colorPalette.text,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              );
                            } else {
                              return Text(
                                atencion.data.nota.toString(),
                                style: TextStyle(
                                    color: _colorPalette.text,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              );
                            }
                          }),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
