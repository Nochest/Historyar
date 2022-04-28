import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:historyar_app/model/story.dart';
import 'package:historyar_app/pages/story_pages/story_visualizer.dart';
import 'package:historyar_app/providers/story_provider.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StoryDetail extends StatefulWidget {
  final int id;
  final int historiaId;
  final int type;

  const StoryDetail({required this.id,
    required this.historiaId,
    required this.type, Key? key})
      : super(key: key);

  @override
  _StoryDetailState createState() => _StoryDetailState();
}

class _StoryDetailState extends State<StoryDetail> {
  var _storyProvider = StoryProvider();

  ColorPalette _colorPalette = ColorPalette();

  ReceivePort receivePort = ReceivePort();
  int progress = 0;

  @override
  void initState() {
    IsolateNameServer.registerPortWithName(receivePort.sendPort, "donwloadingvideo");

    receivePort.listen((message) {
      setState(() {
        progress = message;
      });
    });

    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  static downloadCallback(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName("donwloadingvideo");
    sendPort!.send(progress);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colorPalette.lightBlue,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Detalle Historia',
          style: TextStyle(color: _colorPalette.yellow),
        )
      ),
      backgroundColor: _colorPalette.cream,
      body: FutureBuilder(
        future: _storyProvider.getById(widget.historiaId),
        builder: (BuildContext context, AsyncSnapshot<Historia?> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) => StoryVisualizer(id: widget.id, historiaId: widget.historiaId,
                                url:  snapshot.data!.url, type: widget.type)
                            )
                        );
                      }, // Image tapped
                      child: Image.asset(
                        'assets/video.png',
                        fit: BoxFit.cover, // Fixes border issues
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Detalles',
                          style: TextStyle(
                              color: _colorPalette.yellow,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.left,
                        ),
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
                                Text('Nombre',
                                    style: TextStyle(
                                        color: _colorPalette.text,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400)),
                                Text(
                                    snapshot.data!.nombre,
                                    style: TextStyle(
                                        color: _colorPalette.yellow,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 8.0),
                                Text('Anotaciones',
                                    style: TextStyle(
                                        color: _colorPalette.text,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400)),
                                Text(snapshot.data!.descripcion,
                                    style: TextStyle(
                                        color: _colorPalette.yellow,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10.0, bottom: 50.0),
                        child: _descargarButton(context, snapshot.data!.url)),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _descargarButton(BuildContext context, String url) {
    return Center(
      child: MaterialButton(
          height: 48.0,
          minWidth: 170.0,
          color: _colorPalette.lightBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)),
          child: Text('Descargar',
              style: TextStyle(
                  color: _colorPalette.yellow, fontWeight: FontWeight.bold)),
          onPressed: () async {
            final stasus = await Permission.storage.request();

            const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
            Random _rnd = Random();

            String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
                length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

            if(stasus.isGranted) {
              final baseStorage = await getExternalStorageDirectory();
              
              await FlutterDownloader.enqueue(url: url,
                  savedDir: baseStorage!.path,
                  fileName: getRandomString(5) + ".mp4",
                  showNotification: true,
                  openFileFromNotification: false,
                  saveInPublicStorage: true);

            } else {
              print("Nel");
            }
          }),
    );
  }
}
