import 'package:flutter/material.dart';
import 'package:historyar_app/providers/quiz_provider.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/input_text.dart';

class QuizCreation extends StatefulWidget {

  final int id;
  final int salaId;
  final String salaName;
  final int type;
  final bool isguest;

  const QuizCreation({
    required this.id,
    required this.salaId,
    required this.salaName,
    required this.type,
    required this.isguest,
    Key? key
  }) : super(key: key);

  @override
  _QuizCreationState createState() => _QuizCreationState();
}

class _QuizCreationState extends State<QuizCreation> {

  ColorPalette _colorPalette = ColorPalette();
  InputText _inputText = InputText();
  Alert _alert = Alert();
  var _cuestionarioProvider = QuizProvider();

  bool title = false;
  bool description = false;

  FocusNode focus_title = FocusNode();
  FocusNode focus_description = FocusNode();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    focus_title.addListener(() {
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
          Text('Nuevo Cuestionario', style: TextStyle(fontWeight: FontWeight.w700))
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 24.0),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: _inputText.defaultIText(
                      focus_title,
                      _titleController,
                      TextInputType.text,
                      'Tema',
                      '',
                      false,
                      'Tema',
                      title),
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
                SizedBox(height: 15.0),
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
          child: Text('Crear',
              style: TextStyle(
                  color: _colorPalette.yellow, fontWeight: FontWeight.bold, fontSize: 18)),
          onPressed: () {
            if (_titleController.text.isNotEmpty &&
                _descriptionController.text.isNotEmpty) {
              _cuestionarioProvider.crear(_titleController.text,
                  _descriptionController.text,
                  widget.salaId, widget.salaName,
                  widget.id, widget.type,widget.isguest, context);
              //Navigator.of(context).pushReplacement(MaterialPageRoute(
              //   builder: (BuildContext context) => SignIn()));
            } else {
              setState(() {
                if (_titleController.text.isEmpty) title = true;
                if (_descriptionController.text.isEmpty) description = true;
              });
            }
          }),
    );
  }
}
