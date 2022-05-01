import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:historyar_app/model/attendance.dart';
import 'package:historyar_app/model/story.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_participants_story_list.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_send_mail.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_story_list.dart';
import 'package:historyar_app/pages/lounge_pages/my_lounges.dart';
import 'package:historyar_app/pages/main_menu_pages/create_history.dart';
import 'package:historyar_app/pages/quiz_pages/quiz_creation.dart';
import 'package:historyar_app/pages/quiz_pages/quiz_detail.dart';
import 'package:historyar_app/pages/story_pages/story_visualizer.dart';
import 'package:historyar_app/providers/attendance_provider.dart';
import 'package:historyar_app/providers/lounge_provider.dart';
import 'package:historyar_app/providers/quiz_provider.dart';
import 'package:historyar_app/providers/story_provider.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/input_text.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class LoungeDetail extends StatefulWidget {

  final int id;
  final int salaId;
  final String salaName;
  final int type;

  const LoungeDetail({
    required this.id,
    required this.salaId,
    required this.salaName,
    required this.type,
    Key? key
  }) : super(key: key);

  @override
  _LoungeDetailState createState() => _LoungeDetailState();
}

class _LoungeDetailState extends State<LoungeDetail> {

  ReceivePort receivePort = ReceivePort();
  int progress = 0;

  @override
  void initState() {
    IsolateNameServer.registerPortWithName(receivePort.sendPort, "donwloadingexcel");

    receivePort.listen((message) {
      setState(() {
        progress = message;
      });
    });

    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  static downloadCallback(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName("donwloadingexcel");
    sendPort!.send(progress);
  }

  Widget _buildIcon(int index, String name){
    return Container(
      height: 80.0,
      width: 80.0,
      child: Column(
        children: [
          GestureDetector(
            child: Icon(Icons.attribution_rounded, size: 60.0),
            onTap: (){

            },
          ),
          Center(child: Text(name,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.0),
              overflow: TextOverflow.clip,
              maxLines: 1,
              softWrap: false,
            )
          )
        ],
      ),
    );
  }

  ColorPalette _colorPalette = ColorPalette();
  InputText _inputText = InputText();
  Alert _alert = Alert();
  var _salaProvider = LoungeProvider();
  var _atencionProvider = AttendanceProvider();
  var _cuestionarioProvider = QuizProvider();
  var _storyProvider = StoryProvider();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {

        Navigator.of(context).push(
          MaterialPageRoute(builder:
              (BuildContext context) => MyLounges(id: widget.id, type: widget.type)
          ),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: _colorPalette.cream,
        appBar: AppBar(
          backgroundColor: _colorPalette.darkBlue,
          title:
          Text('Sala ${widget.salaName}', style: TextStyle(fontWeight: FontWeight.w700)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder:
                    (BuildContext context) => MyLounges(id: widget.id, type: widget.type)
                ),
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
                    future: _storyProvider.getByUserIdAndLoungeId(widget.id, widget.salaId),
                    builder: (BuildContext context, AsyncSnapshot<Historia?> snapshot) {

                      print(widget.id);
                      print(widget.salaId);

                      if (!snapshot.hasData) {
                        return MaterialButton(
                            height: 30.0,
                            minWidth: 100.0,
                            color: _colorPalette.lightBlue,
                            shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                            child: Text("Subir Historia",
                                style: TextStyle(
                                    color: _colorPalette.text, fontWeight: FontWeight.w600)),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder:
                                    (BuildContext context) => CreateHistory(id: widget.id, type: widget.type, salaId: widget.salaId)
                                ),
                              );
                            }
                        );
                      } else {
                        return
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (BuildContext context) => StoryVisualizer(id: widget.id, historiaId: snapshot.data!.id,
                                      url:  snapshot.data!.url, type: widget.type)
                                  )
                              );
                            }, // Image tapped
                            child: Image.asset(
                              'assets/video.png',
                              fit: BoxFit.cover, // Fixes border issues
                            ),
                          );
                      }
                    }
                ),
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
                        shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                        child: Text("Ver",
                            style: TextStyle(
                                color: _colorPalette.text, fontWeight: FontWeight.w600)),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder:
                                (BuildContext context) => LoungeStoryList(id: widget.id, type: widget.type, salaId: widget.salaId,
                              salaName: widget.salaName)
                            ),
                          );
                        }
                    )
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
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                FutureBuilder(
                    future: _atencionProvider.getAttendancesByLoungeId(widget.salaId),
                    builder: (BuildContext context, AsyncSnapshot<List<Asistencia>> snapshot) {

                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return Container(
                            child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 5.0,
                              runSpacing: 5.0,
                              children:
                              snapshot.data!.map((e) =>
                                  _buildIcon(e.id, e.nombres)).toList()
                              ,
                            )
                        );
                      }
                    }
                ),
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
                    future: _cuestionarioProvider.getQuizByLoungeId(widget.salaId),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return
                          MaterialButton(
                              height: 30.0,
                              minWidth: 100.0,
                              color: _colorPalette.lightBlue,
                              shape:
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                              child: Text("Crear",
                                  style: TextStyle(
                                      color: _colorPalette.text, fontWeight: FontWeight.w600)),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder:
                                      (BuildContext context) => QuizCreation(id: widget.id, type: widget.type, salaId: widget.salaId,
                                        salaName: widget.salaName)
                                  ),
                                );
                              }
                          );
                      } else {
                        return
                          MaterialButton(
                              height: 30.0,
                              minWidth: 100.0,
                              color: _colorPalette.lightBlue,
                              shape:
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                              child: Text("Ver",
                                  style: TextStyle(
                                      color: _colorPalette.text, fontWeight: FontWeight.w600)),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder:
                                      (BuildContext context) => QuizDetail(id: widget.id, type: widget.type, salaId: widget.salaId, salaName: widget.salaName,)
                                  ),
                                );
                              }
                          );
                      }
                    }),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Descargar Notas',
                      style: TextStyle(
                          color: _colorPalette.yellow,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.left,
                    ),
                    IconButton(
                        onPressed: () async {
                          final stasus = await Permission.storage.request();

                          const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
                          Random _rnd = Random();

                          String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
                              length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

                          if(stasus.isGranted) {
                            final baseStorage = await getExternalStorageDirectory();

                            await FlutterDownloader.enqueue(url: "http://historyarapi10-env.eba-5jcfb6i8.us-east-1.elasticbeanstalk.com/api/salas/asistencias/${widget.salaId}",
                                savedDir: baseStorage!.path,
                                fileName: getRandomString(5) + ".xlsx",
                                showNotification: true,
                                openFileFromNotification: false,
                                saveInPublicStorage: true);

                          } else {
                            print("Nel");
                          }
                        },
                        icon: Icon(
                          Icons.file_download,
                          color: Colors.green ,
                        ))
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notificar',
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
                        shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                        child: Text("Ir",
                            style: TextStyle(
                                color: _colorPalette.text, fontWeight: FontWeight.w600)),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder:
                                (BuildContext context) => LoungeSendMail(id: widget.id, type: widget.type, salaId: widget.salaId,
                                salaName: widget.salaName)
                            ),
                          );
                        }
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ),
    );


  }

}
