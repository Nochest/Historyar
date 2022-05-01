import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_elegant_number_button/flutter_elegant_number_button.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:historyar_app/model/story.dart';
import 'package:historyar_app/pages/story_pages/story_visualizer.dart';
import 'package:historyar_app/providers/story_provider.dart';
import 'package:historyar_app/utils/color_palette.dart';

class LoungeStoryRate extends StatefulWidget {
  final int id;
  final int historiaId;
  final int salaId;
  final String salaName;
  final int type;
  final bool isguest;

  const LoungeStoryRate({required this.id,
    required this.historiaId,
    required this.salaId,
    required this.salaName,
    required this.isguest,
    required this.type, Key? key})
      : super(key: key);

  @override
  _LoungeStoryRateState createState() => _LoungeStoryRateState();
}

class _LoungeStoryRateState extends State<LoungeStoryRate> {

  final focus_comment = FocusNode();

  bool comment = false;
  Historia? historia;

  TextEditingController _commentController = TextEditingController();
  int puntaje = 0;

  getData() async {
    historia = await _storyProvider.getById(widget.historiaId);
    puntaje = historia!.puntaje;
    _commentController.text = historia!.comentario;
  }

  var _storyProvider = StoryProvider();

  ColorPalette _colorPalette = ColorPalette();

  @override
  void initState() {
    getData();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          backgroundColor: _colorPalette.lightBlue,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Calificar Historia',
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
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Calificar',
                          style: TextStyle(
                              color: _colorPalette.yellow,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.left,
                        ),

                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Puntaje',
                          style: TextStyle(
                              color: _colorPalette.darkBlue,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.left,
                        ),
                        TextButton(
                          onPressed: () {
                          },
                          child: ElegantNumberButton(
                            initialValue: puntaje,
                            buttonSizeWidth: 30,
                            buttonSizeHeight: 25,
                            color: _colorPalette.lightBlue,
                            minValue: 0,
                            maxValue: 5,
                            step: 1,
                            decimalPlaces: 0,
                            onChanged: (value){
                              setState(() {
                                puntaje = value.toInt();
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: TextField(
                            controller: _commentController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            focusNode: focus_comment,
                            decoration: InputDecoration(labelText: 'Descripción')
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 22.0, bottom: 40.0),
                        child: _saveButton(context)),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _saveButton(BuildContext context) {
    return Center(
      child: MaterialButton(
          height: 48.0,
          minWidth: 170.0,
          color: _colorPalette.lightBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0)),
          child: Text('Guardar',
              style: TextStyle(
                  color: _colorPalette.yellow, fontWeight: FontWeight.bold)),
          onPressed: () {
            _storyProvider.calificar(widget.id, widget.historiaId, widget.salaId, widget.salaName, widget.type, puntaje, _commentController.text, widget.isguest, context);
          }),
    );
  }

}
