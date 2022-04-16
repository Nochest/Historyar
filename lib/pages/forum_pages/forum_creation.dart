import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:historyar_app/pages/main_menu_pages/community.dart';
import 'package:historyar_app/pages/main_menu_pages/home_holder.dart';
import 'package:historyar_app/pages/sign_in_pages/sign_in.dart';
import 'package:historyar_app/providers/forum_provider.dart';
import 'package:historyar_app/providers/user_provider.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/utils/data_picker.dart';
import 'package:historyar_app/widgets/input_text.dart';

import 'package:intl/intl.dart';

class ForumCreation extends StatefulWidget {

  final int id;
  final int type;

  const ForumCreation({
    required this.id,
    required this.type,
    Key? key
  }) : super(key: key);

  @override
  _ForumCreationState createState() => _ForumCreationState();
}

class _ForumCreationState extends State<ForumCreation> {

  ColorPalette _colorPalette = ColorPalette();
  InputText _inputText = InputText();
  Alert _alert = Alert();
  var _foroProvider = ForumProvider();

  bool topic = false;
  bool description = false;

  FocusNode focus_topic = FocusNode();
  FocusNode focus_description = FocusNode();

  TextEditingController _topicController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    focus_topic.addListener(() {
      setState(() {});
    });
    focus_description.addListener(() {
      setState(() {});
    });

    return Scaffold(
      backgroundColor: _colorPalette.cream,
      appBar: AppBar(
        backgroundColor: _colorPalette.darkBlue,
        title:
        Text('Nueva Publicación', style: TextStyle(fontWeight: FontWeight.w700))
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 24.0),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: Text(
                      'Ingrese el tema y descripción',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _colorPalette.yellow,
                          fontSize: 32.0),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: _inputText.defaultIText(
                      focus_topic,
                      _topicController,
                      TextInputType.text,
                      'Tema',
                      '',
                      false,
                      'Tema',
                      topic),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40.0),
                  child: TextField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    focusNode: focus_description,
                      decoration: InputDecoration(labelText: 'Descripción')
                  )
                ),
                Padding(
                    padding: EdgeInsets.only(top: 22.0, bottom: 40.0),
                    child: _saveButton(context)),
              ],
            ),
          ),
        ),
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
          child: Text('Publicar',
              style: TextStyle(
                  color: _colorPalette.yellow, fontWeight: FontWeight.bold)),
          onPressed: () {
            if (_topicController.text.isNotEmpty &&
                _descriptionController.text.isNotEmpty) {
              _foroProvider.publicar(_topicController.text,
                  _descriptionController.text,
                  widget.id, widget.type, context);
              //Navigator.of(context).pushReplacement(MaterialPageRoute(
              //   builder: (BuildContext context) => SignIn()));
            } else {
              setState(() {
                if (_topicController.text.isEmpty) topic = true;
                if (_descriptionController.text.isEmpty) description = true;
              });
            }
          }),
    );
  }
}
