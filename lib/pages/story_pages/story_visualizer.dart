import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          'Ver Historia',
          style: TextStyle(color: _colorPalette.yellow),
        )
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