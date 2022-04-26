import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:historyar_app/model/story.dart';
import 'package:historyar_app/pages/story_pages/story_visualizer.dart';
import 'package:historyar_app/providers/story_provider.dart';
import 'package:historyar_app/utils/color_palette.dart';

class LoungeParticipantStoryDetail extends StatefulWidget {
  final int id;
  final int historiaId;
  final int type;

  const LoungeParticipantStoryDetail({required this.id,
    required this.historiaId,
    required this.type, Key? key})
      : super(key: key);

  @override
  _LoungeParticipantStoryDetailState createState() => _LoungeParticipantStoryDetailState();
}

class _LoungeParticipantStoryDetailState extends State<LoungeParticipantStoryDetail> {
  var _storyProvider = StoryProvider();

  ColorPalette _colorPalette = ColorPalette();

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
                                SizedBox(height: 8.0),
                                Text('Puntaje',
                                    style: TextStyle(
                                        color: _colorPalette.text,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400)),
                                RatingBarIndicator(
                                  rating: snapshot.data!.puntaje.toDouble(),
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  itemCount: 5,
                                  itemSize: 20.0,
                                  direction: Axis.horizontal,
                                ),
                                Text('Comentarios',
                                    style: TextStyle(
                                        color: _colorPalette.text,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400)),
                                Text(snapshot.data!.comentario,
                                    style: TextStyle(
                                        color: _colorPalette.yellow,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        )
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

}
