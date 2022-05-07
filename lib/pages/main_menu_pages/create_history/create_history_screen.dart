import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ed_screen_recorder/ed_screen_recorder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:historyar_app/providers/story_provider.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class CreateHistory extends StatefulWidget {
  final int id;
  final int type;
  final int caso;
  final int? salaId;
  final String? salaName;
  final int? asistenciaId;

  const CreateHistory(
      {required this.id,
      required this.type,
      this.salaId,
      required this.caso,
      this.salaName,
      this.asistenciaId,
      Key? key})
      : super(key: key);

  @override
  State<CreateHistory> createState() => _CreateHistoryState();
}

class _CreateHistoryState extends State<CreateHistory> {
  EdScreenRecorder? screenRecorder;
  Map<String, dynamic>? _response;
  bool isRecording = false;
  bool expandModels = false;
  String? route;

  var _storyProvider = StoryProvider();

  //File file = File(route.toString());

  final palette = ColorPalette();

  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;

  List<ARHitTestResult> hitTestResults = [];
  List<ARNode> nodes = [];
  List<ARAnchor> anchors = [];

  Future<void> startRecord({required String fileName}) async {
    try {
      var startResponse = await screenRecorder?.startRecordScreen(
        fileName: fileName,
        audioEnable: true,
      );

      setState(() {
        _response = startResponse;
      });
      try {
        screenRecorder?.watcher?.events.listen(
          (event) {
            log(event.type.toString(), name: "Event: ");
          },
          onError: (e) => kDebugMode ? debugPrint('ERROR ON STREAM: $e') : null,
          onDone: () => kDebugMode ? debugPrint('Watcher closed!') : null,
        );
      } catch (e) {
        kDebugMode ? debugPrint('ERROR WAITING FOR READY: $e') : null;
      }
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while starting the recording!")
          : null;
    }
  }

  Future<void> stopRecord() async {
    try {
      var stopResponse = await screenRecorder?.stopRecord();
      setState(() {
        _response = stopResponse;
      });

      log("GRABADO");
    } on PlatformException {
      kDebugMode
          ? debugPrint("Error: An error occurred while stopping recording.")
          : null;
    }
  }

  @override
  void initState() {
    super.initState();
    screenRecorder = EdScreenRecorder();
  }

  @override
  void dispose() {
    super.dispose();
    arSessionManager!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: palette.lightBlue,
        title: Text(
          'Crea tu historia!',
          style: TextStyle(
            color: palette.yellow,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          isRecording
              ? const SizedBox.shrink()
              : Container(
                  width: double.maxFinite,
                  height: 120,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: palette.lightBlue,
                    border: Border.all(color: palette.yellow, width: 3),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: 'Escribe tu historia aquí'),
                    maxLines: 5,
                  ),
                ),
          isRecording
              ? const SizedBox.shrink()
              : Positioned(
                  top: 56,
                  left: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: palette.cream,
                      border: Border.all(color: palette.yellow, width: 3),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: () async {
                              File video = File(route.toString());
                              _storyProvider.registerS3(
                                  widget.id,
                                  widget.type,
                                  widget.salaId,
                                  widget.salaName,
                                  widget.asistenciaId,
                                  "aer",
                                  "descripcion",
                                  video,
                                  widget.caso,
                                  context);
                              print(route);
                            },
                            icon: Icon(Icons.save),
                          ),
                          const SizedBox(height: 4),
                          IconButton(
                            onPressed: () {
                              startRecord(fileName: 'PRUEBA01');
                              setState(() {
                                isRecording = true;
                              });
                            },
                            icon: Icon(Icons.play_arrow),
                          ),
                          const SizedBox(height: 4),
                          IconButton(
                              onPressed: () async {
                                List<String> videoPath = [];
                                videoPath.add(route.toString());
                                print('ruta');
                                print(videoPath);
                                //File video = File(route.toString());
                                if (videoPath == null) return;

                                await Share.shareFiles(videoPath);
                              },
                              icon: Icon(Icons.share)),
                          const SizedBox(height: 4),
                          IconButton(
                              onPressed: () {
                                expandModels = !expandModels;
                                setState(() {});
                              },
                              icon: Icon(Icons.burst_mode_outlined)),
                        ],
                      ),
                    ),
                  ),
                ),
          expandModels
              ? Positioned(
                  top: 225,
                  left: 50,
                  child: Container(
                    width: 250,
                    decoration: BoxDecoration(
                      color: palette.cream,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: palette.yellow, width: 3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text('Modelos 3D'),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 16,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: GestureDetector(
                                  child: Image.asset(
                                    'assets/3d_icons/fox.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  onTap: () {
                                    this.arSessionManager!.onPlaneOrPointTap =
                                        getFox;
                                    expandModels = false;
                                    log('Selected fox 01');
                                    setState(() {});
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: GestureDetector(
                                  child: Image.asset(
                                    'assets/3d_icons/duck.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  onTap: () {
                                    this.arSessionManager!.onPlaneOrPointTap =
                                        getDuck;
                                    expandModels = false;

                                    log('Selected duck 01');
                                    setState(() {});
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: GestureDetector(
                                  child: Image.asset(
                                    'assets/3d_icons/fox.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  onTap: () {
                                    log('Selected fox 03');
                                  },
                                ),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.h_mobiledata_rounded)),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.h_mobiledata_rounded)),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.h_mobiledata_rounded)),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.h_mobiledata_rounded)),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.h_mobiledata_rounded)),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.h_mobiledata_rounded)),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.h_mobiledata_rounded)),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.h_mobiledata_rounded)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ))
              : const SizedBox.shrink(),
          isRecording
              ? CircleAvatar(
                  child: IconButton(
                    onPressed: () {
                      stopRecord();
                      setState(() {
                        isRecording = false;
                      });
                      route = (_response?['file'] as File?)?.path;
                      log("File: ${route}");
                      log("Status: ${(_response?['success']).toString()}");
                      log("Event: ${_response?['eventname']}");
                      log("Progress: ${(_response?['progressing']).toString()}");
                      log("Message: ${_response?['message']}");
                      log("Video Hash: ${_response?['videohash']}");
                      log("Start Date: ${(_response?['startdate']).toString()}");
                      log("End Date: ${(_response?['enddate']).toString()}");
                    },
                    icon: Icon(Icons.stop),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: "Images/triangle.png",
          showWorldOrigin: false,
          handlePans: true,
          handleRotation: true,
        );
    this.arObjectManager!.onInitialize();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
  }

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
        (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    if (singleHitTestResult != null) {
      var newAnchor =
          ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        this.anchors.add(newAnchor);
        // Add note to anchor
        var newNode = ARNode(
            type: NodeType.webGLB,
            uri:
                "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Box/glTF-Binary/Box.glb",
            scale: Vector3(0.2, 0.2, 0.2),
            position: Vector3(0.0, 0.0, 0.0),
            rotation: Vector4(1.0, 0.0, 0.0, 0.0));
        bool? didAddNodeToAnchor = await this
            .arObjectManager!
            .addNode(newNode, planeAnchor: newAnchor);
        if (didAddNodeToAnchor!) {
          this.nodes.add(newNode);
        } else {
          this.arSessionManager!.onError("Adding Node to Anchor failed");
        }
      } else {
        this.arSessionManager!.onError("Adding Anchor failed");
      }
    }
  }

  Future<void> getFox(List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
        (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    if (singleHitTestResult != null) {
      var newAnchor =
          ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        this.anchors.add(newAnchor);
        // Add note to anchor
        var newNode = ARNode(
            type: NodeType.webGLB,
            uri:
                "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Fox/glTF-Binary/Fox.glb",
            scale: Vector3(0.2, 0.2, 0.2),
            position: Vector3(0.0, 0.0, 0.0),
            rotation: Vector4(1.0, 0.0, 0.0, 0.0));
        bool? didAddNodeToAnchor = await this
            .arObjectManager!
            .addNode(newNode, planeAnchor: newAnchor);
        if (didAddNodeToAnchor!) {
          this.nodes.add(newNode);
        } else {
          this.arSessionManager!.onError("Adding Node to Anchor failed");
        }
      } else {
        this.arSessionManager!.onError("Adding Anchor failed");
      }
    }
  }

  Future<void> getDuck(List<ARHitTestResult> hitTestResults) async {
    var singleHitTestResult = hitTestResults.firstWhere(
        (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);
    if (singleHitTestResult != null) {
      var newAnchor =
          ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
      bool? didAddAnchor = await this.arAnchorManager!.addAnchor(newAnchor);
      if (didAddAnchor!) {
        this.anchors.add(newAnchor);
        // Add note to anchor
        var newNode = ARNode(
            type: NodeType.webGLB,
            uri:
                "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
            scale: Vector3(0.2, 0.2, 0.2),
            position: Vector3(0.0, 0.0, 0.0),
            rotation: Vector4(1.0, 0.0, 0.0, 0.0));
        bool? didAddNodeToAnchor = await this
            .arObjectManager!
            .addNode(newNode, planeAnchor: newAnchor);
        if (didAddNodeToAnchor!) {
          this.nodes.add(newNode);
        } else {
          this.arSessionManager!.onError("Adding Node to Anchor failed");
        }
      } else {
        this.arSessionManager!.onError("Adding Anchor failed");
      }
    }
  }
}
