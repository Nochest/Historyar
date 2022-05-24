import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:math' hide log;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_elegant_number_button/flutter_elegant_number_button.dart';
import 'package:historyar_app/helpers/constant_helpers.dart';
import 'package:historyar_app/main.dart';
import 'package:historyar_app/model/attendance.dart';
import 'package:historyar_app/model/lounge.dart';
import 'package:historyar_app/model/story.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_send_mail.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_story_list.dart';
import 'package:historyar_app/pages/lounge_pages/my_lounges.dart';
import 'package:historyar_app/pages/main_menu_pages/create_history/create_history_screen.dart';
import 'package:historyar_app/pages/main_menu_pages/lounge_page.dart';
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
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoungeDetail extends StatefulWidget {
  final int id;
  final int salaId;
  final String salaName;
  final int type;

  const LoungeDetail(
      {required this.id,
      required this.salaId,
      required this.salaName,
      required this.type,
      Key? key})
      : super(key: key);

  @override
  _LoungeDetailState createState() => _LoungeDetailState();
}

class _LoungeDetailState extends State<LoungeDetail> {
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  ReceivePort receivePort = ReceivePort();
  int progress = 0;
  int _numberController = 2;
  int maxGrupo = 1;

  String? pathStorage;
  String? fileName;
  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err, _) {
      log("Cannot get download folder path");
    }
    return directory?.path;
  }

  getPath() async {
    pathStorage = await getDownloadPath();
    setState(() {});
  }

  Future _requestDownload(String link, String fileName) async {
    inspect('${widget.salaName}_$fileName');
    await FlutterDownloader.enqueue(
      url: link,
      savedDir: '$pathStorage/',
      fileName: '${widget.salaName}_$fileName',
      showNotification: true,
      openFileFromNotification: false,
      saveInPublicStorage: true,
    );
  }

  String getDocName() {
    String doc = '';
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    doc = getRandomString(5) + '.xlsx';
    return doc;
  }

  @override
  void initState() {
    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, "donwloadingexcel");

    receivePort.listen((message) {
      setState(() {
        progress = message;
      });
    });
    FlutterDownloader.registerCallback(downloadCallback);
    fileName = getDocName();
    getPath().then((value) => isLoading.value = false);
    super.initState();
  }

  static downloadCallback(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName("donwloadingexcel");
    sendPort!.send(progress);
  }

  Widget _buildIcon(int index, String name, int grupo) {
    List colors = [
      Colors.black,
      Colors.brown,
      Colors.amber,
      Colors.blueAccent,
      Colors.cyan,
      Colors.purple
    ];

    if (grupo > maxGrupo) {
      maxGrupo = grupo;
    }

    return Container(
      height: 95.0,
      width: 80.0,
      child: Column(
        children: [
          Center(
              child: Text(
            "G${grupo}",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.0),
          )),
          GestureDetector(
            child: Icon(
              Icons.attribution_rounded,
              size: 60.0,
              color: colors[grupo],
            ),
            onTap: () {
              createAlert(index, name, context);
            },
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
  InputText _inputText = InputText();
  Alert _alert = Alert();
  var _salaProvider = LoungeProvider();
  var _atencionProvider = AttendanceProvider();
  var _cuestionarioProvider = QuizProvider();
  var _storyProvider = StoryProvider();

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  MyLounges(id: widget.id, type: widget.type)),
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
                          MyLounges(id: widget.id, type: widget.type)),
                );
              },
            ),
          ),
          body: ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, value, _) {
              if (value) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Credenciales',
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
                            future: _salaProvider.getById(widget.salaId),
                            builder: (BuildContext context,
                                AsyncSnapshot<Sala?> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Código: ${snapshot.data?.codigo}',
                                      style: TextStyle(
                                          color: _colorPalette.darkBlue,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      'Contraseña: ${snapshot.data?.password}',
                                      style: TextStyle(
                                          color: _colorPalette.darkBlue,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                );
                              }
                            }),
                        const SizedBox(height: 24),
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
                              print(widget.id);
                              print(widget.salaId);

                              if (!snapshot.hasData) {
                                return MaterialButton(
                                    height: 30.0,
                                    minWidth: 100.0,
                                    color: _colorPalette.lightBlue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100.0)),
                                    child: Text("Subir Historia",
                                        style: TextStyle(
                                            color: _colorPalette.text,
                                            fontWeight: FontWeight.w600)),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                CreateHistory(
                                                  id: widget.id,
                                                  type: widget.type,
                                                  salaId: widget.salaId,
                                                  caso: Constants.MI_SALA,
                                                  salaName: widget.salaName,
                                                )),
                                      );
                                    });
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                StoryVisualizer(
                                                    id: widget.id,
                                                    historiaId:
                                                        snapshot.data!.id,
                                                    url: snapshot.data!.url,
                                                    type: widget.type)));
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
                                            LoungeStoryList(
                                                id: widget.id,
                                                type: widget.type,
                                                salaId: widget.salaId,
                                                salaName: widget.salaName)),
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
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        FutureBuilder(
                            future: _atencionProvider
                                .getAttendancesByLoungeId(widget.salaId),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Asistencia>> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else {
                                return Container(
                                    child: Wrap(
                                  direction: Axis.horizontal,
                                  spacing: 5.0,
                                  runSpacing: 5.0,
                                  children: snapshot.data!
                                      .map((e) => _buildIcon(
                                          e.id, e.nombres, e.numeroGrupo))
                                      .toList(),
                                ));
                              }
                            }),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: ElegantNumberButton(
                                initialValue: _numberController,
                                buttonSizeWidth: 30,
                                buttonSizeHeight: 25,
                                color: _colorPalette.lightBlue,
                                minValue: 1,
                                maxValue: 5,
                                step: 1,
                                decimalPlaces: 0,
                                onChanged: (value) {
                                  setState(() {
                                    _numberController = value.toInt();
                                  });
                                },
                              ),
                            ),
                            MaterialButton(
                                height: 30.0,
                                minWidth: 100.0,
                                color: _colorPalette.lightBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0)),
                                child: Text("Partir",
                                    style: TextStyle(
                                        color: _colorPalette.text,
                                        fontWeight: FontWeight.w600)),
                                onPressed: () {
                                  partir(widget.salaId, _numberController,
                                      context);
                                })
                          ],
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
                                future: _cuestionarioProvider
                                    .getQuizByLoungeId(widget.salaId),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.data == null) {
                                    return MaterialButton(
                                        height: 30.0,
                                        minWidth: 100.0,
                                        color: _colorPalette.lightBlue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0)),
                                        child: Text("Crear",
                                            style: TextStyle(
                                                color: _colorPalette.text,
                                                fontWeight: FontWeight.w600)),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        QuizCreation(
                                                            id: widget.id,
                                                            type: widget.type,
                                                            salaId:
                                                                widget.salaId,
                                                            salaName: widget
                                                                .salaName)),
                                          );
                                        });
                                  } else {
                                    return MaterialButton(
                                        height: 30.0,
                                        minWidth: 100.0,
                                        color: _colorPalette.lightBlue,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100.0)),
                                        child: Text("Ver",
                                            style: TextStyle(
                                                color: _colorPalette.text,
                                                fontWeight: FontWeight.w600)),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        QuizDetail(
                                                          id: widget.id,
                                                          type: widget.type,
                                                          salaId: widget.salaId,
                                                          salaName:
                                                              widget.salaName,
                                                        )),
                                          );
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
                              'Descargar Notas',
                              style: TextStyle(
                                  color: _colorPalette.yellow,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.left,
                            ),
                            IconButton(
                                onPressed: () async {
                                  inspect(widget.salaId);
                                  await _salaProvider
                                      .updateExcelAssitance(widget.salaId)
                                      .then((value) async {
                                    if (value == 200) {
                                      final stasus =
                                          await Permission.storage.request();

                                      if (stasus.isGranted) {
                                        _requestDownload(
                                          'https://historyar-bucket.s3.amazonaws.com/archivos/${widget.salaId}.xlsx',
                                          getDocName(),
                                        );
                                      } else {
                                        print("Nel");
                                      }
                                    } else {
                                      _alert.createAlert(
                                          context,
                                          'Error',
                                          'No se ha podido descargar las notas',
                                          'Ok');
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.file_download,
                                  color: Colors.green,
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
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0)),
                                child: Text("Ir",
                                    style: TextStyle(
                                        color: _colorPalette.text,
                                        fontWeight: FontWeight.w600)),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            LoungeSendMail(
                                                id: widget.id,
                                                type: widget.type,
                                                salaId: widget.salaId,
                                                salaName: widget.salaName)),
                                  );
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
            },
          )),
    );
  }

  partir(int id, int cantidad, BuildContext context) async {
    var response = await http.put(
        Uri.parse(
            "${Constants.URL}/api/asistencias/sala/grupos/${id}?cantidad=${cantidad}"),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context) => LoungeDetail(
                id: widget.id,
                type: widget.type,
                salaId: widget.salaId,
                salaName: widget.salaName)),
      );
    } else {
      _alert.createAlert(context, "Algo salió mal",
          "No se ha podido partir las salas.", "Aceptar");
    }
  }

  void createAlert(int id, String nombre, BuildContext context) {
    showDialog(
        barrierColor: _colorPalette.lightBlue.withOpacity(0.6),
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            backgroundColor: _colorPalette.cream,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Center(
                    child: Text('Mover a ${nombre} al',
                        style: TextStyle(
                            color: _colorPalette.darkBlue,
                            fontWeight: FontWeight.w700,
                            fontSize: 24.0)))),
            content: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(maxGrupo, (index) {
                  return MaterialButton(
                      height: 30.0,
                      minWidth: 100.0,
                      color: _colorPalette.lightBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0)),
                      child: Text("Grupo ${(index + 1)}",
                          style: TextStyle(
                              color: _colorPalette.text,
                              fontWeight: FontWeight.w600)),
                      onPressed: () {
                        mover(id, (index + 1), context);
                      });
                }),
              ),
            ),
          );
        });
  }

  mover(int id, int grupo, BuildContext context) async {
    var response = await http.put(
        Uri.parse(
            "${Constants.URL}/api/asistencias/grupo/${id}?grupo=${grupo}"),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (BuildContext context) => LoungeDetail(
                id: widget.id,
                type: widget.type,
                salaId: widget.salaId,
                salaName: widget.salaName)),
      );
    } else {
      _alert.createAlert(context, "Algo salió mal",
          "No se ha podido partir las salas.", "Aceptar");
    }
  }
}
