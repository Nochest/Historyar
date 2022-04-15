import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:historyar_app/helpers/constant_helpers.dart';
import 'package:historyar_app/pages/story_pages/story_detail.dart';
import 'package:historyar_app/providers/story_provider.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/video_player.dart';
import 'package:video_player/video_player.dart';

class StoryVisualizer extends StatefulWidget {
  final int id;
  final int historiaId;
  final String url;
  final int type;

  const StoryVisualizer({required this.id,
    required this.historiaId,
    required this.url,
    required this.type, Key? key})
      : super(key: key);

  @override
  _StoryVisualizerState createState() => _StoryVisualizerState();
}

class _StoryVisualizerState extends State<StoryVisualizer> {
  late VideoPlayerController controller;

  ColorPalette _colorPalette = ColorPalette();
  var _storyProvider = StoryProvider();
  String asset = "";
  
  @override
  void initState(){
    //final asset = "${Constants.URL}/api/historias/download/${widget.historiaId.toString()}";
    controller = VideoPlayerController.network(widget.url)
      ..addListener(() => setState(() {}))
      ..initialize().then((_) => controller.play());
    super.initState();
  }
  
  @override
  void dispose (){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = controller.value.volume == 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colorPalette.lightBlue,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Mi Historia',
          style: TextStyle(color: _colorPalette.yellow),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) => StoryDetail(id: widget.id, historiaId: widget.historiaId, type: widget.type)),
                    (Route<dynamic> route) => false);
          },
        ),
      ),
      backgroundColor: _colorPalette.cream,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
              children: [
              VideoPlayerWidget(controller: controller)
            ]
          ),
        ),
      )
    );
  }

}