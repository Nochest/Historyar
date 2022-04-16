import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:historyar_app/model/forum_holder.dart';
import 'package:historyar_app/pages/forum_pages/my_forums.dart';
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

class ForumEdit extends StatefulWidget {

  final int id;
  final int type;
  final int userId;

  const ForumEdit({
    required this.id,
    required this.type,
    required this.userId,
    Key? key
  }) : super(key: key);

  @override
  _ForumEditState createState() => _ForumEditState();
}

class _ForumEditState extends State<ForumEdit> {

  ColorPalette _colorPalette = ColorPalette();
  InputText _inputText = InputText();
  Alert _alert = Alert();
  var _foroProvider = ForumProvider();

  bool topic = false;
  bool description = false;
  bool isLoading = true;

  FocusNode focus_topic = FocusNode();
  FocusNode focus_description = FocusNode();

  ForumHolder? foro;

  TextEditingController _topicController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  getData() async {
    foro = await _foroProvider.getById(widget.id, widget.type, widget.userId);
    _topicController.text = foro!.title;
    _descriptionController.text = foro!.description;
  }

  @override
  void initState() {
    getData();
    inspect(foro);
    isLoading = false;
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500))
        .then((_) => setState(() {}));

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
        Text('Editar Publicación', style: TextStyle(fontWeight: FontWeight.w700))
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
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
      )
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
            if (_topicController.text.isNotEmpty &&
                _descriptionController.text.isNotEmpty) {
              _foroProvider.editarPublicacion(widget.id ,_topicController.text,
                  _descriptionController.text,
                  widget.userId, widget.type, context);
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
