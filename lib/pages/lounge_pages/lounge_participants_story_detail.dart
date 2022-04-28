import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:historyar_app/model/story.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_participants_story_list.dart';
import 'package:historyar_app/pages/story_pages/story_visualizer.dart';
import 'package:historyar_app/providers/reaction_provider.dart';
import 'package:historyar_app/providers/story_provider.dart';
import 'package:historyar_app/utils/color_palette.dart';

class LoungeParticipantStoryDetail extends StatefulWidget {
  final int id;
  final int historiaId;
  final int salaId;
  final int asistenciaId;
  final String salaName;
  final int type;

  const LoungeParticipantStoryDetail({required this.id,
    required this.historiaId,
    required this.salaId,
    required this.salaName,
    required this.asistenciaId,
    required this.type, Key? key})
      : super(key: key);

  @override
  _LoungeParticipantStoryDetailState createState() => _LoungeParticipantStoryDetailState();
}

class _LoungeParticipantStoryDetailState extends State<LoungeParticipantStoryDetail> {
  var _storyProvider = StoryProvider();
  var _reaccionProvider = ReactionProvider();

  int reaccion = 3;

  getData() async {
    reaccion = await _reaccionProvider
        .getReactionByUserIdAndHistoriaId(widget.id, widget.historiaId);
  }

  ColorPalette _colorPalette = ColorPalette();

  @override
  void initState() {
    getData();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {

        Navigator.of(context).push(
          MaterialPageRoute(builder:
              (BuildContext context) => LoungeParticipantStoryList(id: widget.id, type: widget.type, salaId: widget.salaId,
            salaName: widget.salaName, asistenciaId: widget.asistenciaId,)
          ),
        );
        return true;
      },
      child: Scaffold(
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
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reacciones',
                            style: TextStyle(
                                color: _colorPalette.yellow,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.sentiment_very_dissatisfied,
                                  color: (reaccion == 1) ? Colors.red : Colors.grey ,
                                ),
                                iconSize: 50,
                                onPressed: () {
                                  _reaccionProvider.guardar(widget.id, widget.historiaId, widget.type, 1,
                                      widget.salaId, widget.salaName, widget.asistenciaId,context);
                                }
                              ),
                              Text("Aburrido"),
                              Text("(1)")
                            ]
                          ),
                          Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.sentiment_dissatisfied,
                                    color: (reaccion == 2) ? Colors.redAccent : Colors.grey ,
                                  ),
                                  iconSize: 50,
                                  onPressed: () {
                                    _reaccionProvider.guardar(widget.id, widget.historiaId, widget.type, 2,
                                        widget.salaId, widget.salaName, widget.asistenciaId,context);
                                  },
                                ),
                                Text("Confundido"),
                                Text("(1)")
                              ]
                          ),
                          Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.sentiment_neutral,
                                    color: (reaccion == 3) ? Colors.amber : Colors.grey ,
                                  ),
                                  iconSize: 50,
                                  onPressed: () {
                                    _reaccionProvider.guardar(widget.id, widget.historiaId, widget.type, 3,
                                        widget.salaId, widget.salaName, widget.asistenciaId,context);
                                  },
                                ),
                                Text("Neutral"),
                                Text("(1)")
                              ]
                          ),
                          Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.sentiment_satisfied,
                                    color: (reaccion == 4) ? Colors.lightGreen : Colors.grey ,
                                  ),
                                  iconSize: 50,
                                  onPressed: () {
                                    _reaccionProvider.guardar(widget.id, widget.historiaId, widget.type, 4,
                                        widget.salaId, widget.salaName, widget.asistenciaId,context);
                                  },
                                ),
                                Text("Interesante"),
                                Text("(1)")
                              ]
                          ),
                          Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.sentiment_very_satisfied,
                                    color: (reaccion == 5) ? Colors.green : Colors.grey ,
                                  ),
                                  iconSize: 50,
                                  onPressed: () {
                                    _reaccionProvider.guardar(widget.id, widget.historiaId, widget.type, 5,
                                        widget.salaId, widget.salaName, widget.asistenciaId,context);
                                  },
                                ),
                                Text("Entendido"),
                                Text("(1)")
                              ]
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

}
