import 'package:flutter/material.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_participants.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_participants_story_detail.dart';
import 'package:historyar_app/providers/story_provider.dart';
import 'package:historyar_app/utils/color_palette.dart';

class LoungeParticipantStoryList extends StatefulWidget {

  final int id;
  final int salaId;
  final int asistenciaId;
  final String salaName;
  final int type;

  const LoungeParticipantStoryList({
    required this.id,
    required this.salaId,
    required this.salaName,
    required this.asistenciaId,
    required this.type,
    Key? key
  }) : super(key: key);

  @override
  _LoungeParticipantStoryListState createState() => _LoungeParticipantStoryListState();
}

class _LoungeParticipantStoryListState extends State<LoungeParticipantStoryList> {

  ColorPalette _colorPalette = ColorPalette();
  var _storyProvider = StoryProvider();

  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {

        Navigator.of(context).push(
          MaterialPageRoute(builder:
              (BuildContext context) => LoungeParticipant(id: widget.id, type: widget.type, salaId: widget.salaId,
              salaName: widget.salaName, asistenciaId: widget.asistenciaId,)
          ),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: _colorPalette.cream,
        appBar: AppBar(
            backgroundColor: _colorPalette.darkBlue,
            title:
            Text('Listado de Historias', style: TextStyle(fontWeight: FontWeight.w700))
        ),
        body: Container(
          child: FutureBuilder(
            future: _storyProvider.getByLoungeId(widget.salaId, widget.type),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int i) {
                      return Column(
                          children: [
                            Divider(color: Colors.black),
                            Padding(
                                padding: EdgeInsets.only(
                                    right: 10.0, left: 10.0),
                                child: ListTile(
                                  title: Text(snapshot.data[i].nombre,
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: _colorPalette.darkBlue),
                                      textAlign: TextAlign.justify),
                                  subtitle: Text(snapshot.data[i].usuario,
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: _colorPalette.text),
                                      textAlign: TextAlign.justify),
                                  onTap: () {
                                    //createAlert(context, snapshot.data[i].id);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                LoungeParticipantStoryDetail(id: widget.id,
                                                    historiaId: snapshot.data[i]
                                                        .id,
                                                    type: widget.type)
                                        )
                                    );
                                  },
                                )
                            ),
                          ]
                      );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
