import 'package:flutter/material.dart';
import 'package:flutter_elegant_number_button/flutter_elegant_number_button.dart';
import 'package:historyar_app/providers/quiz_provider.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/input_text.dart';

class QuestionCreation extends StatefulWidget {

  final int id;
  final int salaId;
  final String salaName;
  final int cuestionarioId;
  final int type;

  const QuestionCreation({
    required this.id,
    required this.salaId,
    required this.salaName,
    required this.cuestionarioId,
    required this.type,
    Key? key
  }) : super(key: key);

  @override
  _QuestionCreationState createState() => _QuestionCreationState();
}

class _QuestionCreationState extends State<QuestionCreation> {

  ColorPalette _colorPalette = ColorPalette();
  InputText _inputText = InputText();
  Alert _alert = Alert();
  var _cuestionarioProvider = QuizProvider();

  bool description = false;
  bool descriptionA = false;
  bool descriptionB = false;
  bool descriptionC = false;
  bool descriptionD = false;

  FocusNode focus_description = FocusNode();
  FocusNode focus_descriptionA = FocusNode();
  FocusNode focus_descriptionB = FocusNode();
  FocusNode focus_descriptionC = FocusNode();
  FocusNode focus_descriptionD = FocusNode();

  TextEditingController _descriptionController = TextEditingController();
  int _puntajeController = 5;
  TextEditingController _descriptionControllerA = TextEditingController();
  bool correctoA = false;
  TextEditingController _descriptionControllerB = TextEditingController();
  bool correctoB = false;
  TextEditingController _descriptionControllerC = TextEditingController();
  bool correctoC = false;
  TextEditingController _descriptionControllerD = TextEditingController();
  bool correctoD = false;


  @override
  Widget build(BuildContext context) {
    focus_description.addListener(() {
      setState(() {});
    });
    focus_descriptionA.addListener(() {
      setState(() {});
    });
    focus_descriptionB.addListener(() {
      setState(() {});
    });
    focus_descriptionC.addListener(() {
      setState(() {});
    });
    focus_descriptionD.addListener(() {
      setState(() {});
    });

    return Scaffold(
      backgroundColor: _colorPalette.cream,
      appBar: AppBar(
          backgroundColor: _colorPalette.darkBlue,
          title:
          Text('Nueva Pregunta', style: TextStyle(fontWeight: FontWeight.w700))
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 24.0),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pregunta',
                      style: TextStyle(
                          color: _colorPalette.darkBlue,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'Puntaje',
                      style: TextStyle(
                          color: _colorPalette.darkBlue,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextField(
                          controller: _descriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          focusNode: focus_description,
                          decoration: InputDecoration(labelText: 'Pregunta')
                      ),
                    ),
                    ElegantNumberButton(
                      initialValue: _puntajeController,
                      buttonSizeWidth: 30,
                      buttonSizeHeight: 25,
                      color: _colorPalette.lightBlue,
                      minValue: 2,
                      maxValue: 50,
                      step: 1,
                      decimalPlaces: 0,
                      onChanged: (value){
                        setState(() {
                          _puntajeController = value.toInt();
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Alternativas',
                      style: TextStyle(
                          color: _colorPalette.darkBlue,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      'Válida',
                      style: TextStyle(
                          color: _colorPalette.darkBlue,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'A) ',
                      style: TextStyle(
                          color: _colorPalette.darkBlue,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                    Flexible(
                      child: TextField(
                          controller: _descriptionControllerA,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          focusNode: focus_descriptionA,
                          decoration: InputDecoration(labelText: 'Alternativa A')
                      ),
                    ),
                    Checkbox(
                      value: correctoA,
                      onChanged: (newValue) {
                        setState(() {
                          correctoA = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'B) ',
                      style: TextStyle(
                          color: _colorPalette.darkBlue,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                    Flexible(
                      child: TextField(
                          controller: _descriptionControllerB,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          focusNode: focus_descriptionB,
                          decoration: InputDecoration(labelText: 'Alternativa B')
                      ),
                    ),
                    Checkbox(
                      value: correctoB,
                      onChanged: (newValue) {
                        setState(() {
                          correctoB = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'C) ',
                      style: TextStyle(
                          color: _colorPalette.darkBlue,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                    Flexible(
                      child: TextField(
                          controller: _descriptionControllerC,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          focusNode: focus_descriptionC,
                          decoration: InputDecoration(labelText: 'Alternativa C')
                      ),
                    ),
                    Checkbox(
                      value: correctoC,
                      onChanged: (newValue) {
                        setState(() {
                          correctoC = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'D) ',
                      style: TextStyle(
                          color: _colorPalette.darkBlue,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.left,
                    ),
                    Flexible(
                      child: TextField(
                          controller: _descriptionControllerD,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          focusNode: focus_descriptionD,
                          decoration: InputDecoration(labelText: 'Alternativa D')
                      ),
                    ),
                    Checkbox(
                      value: correctoD,
                      onChanged: (newValue) {
                        setState(() {
                          correctoD = newValue!;
                        });
                      },
                    ),
                  ],
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
            if (_descriptionController.text.isNotEmpty
            && _descriptionControllerA.text.isNotEmpty
            && _descriptionControllerB.text.isNotEmpty
            && _descriptionControllerC.text.isNotEmpty
            && _descriptionControllerD.text.isNotEmpty) {
              _cuestionarioProvider.crearPregunta(_descriptionController.text,
                  _puntajeController, widget.cuestionarioId,
                  widget.salaId, widget.salaName,
                  widget.id, widget.type,
                  _descriptionControllerA.text,
                  correctoA,
                  _descriptionControllerB.text,
                  correctoB,
                  _descriptionControllerC.text,
                  correctoC,
                  _descriptionControllerD.text,
                  correctoD,
                  context);
              //Navigator.of(context).pushReplacement(MaterialPageRoute(
              //   builder: (BuildContext context) => SignIn()));
            } else {
              setState(() {
                if (_descriptionController.text.isEmpty) description = true;
                if (_descriptionControllerA.text.isEmpty) description = true;
                if (_descriptionControllerB.text.isEmpty) description = true;
                if (_descriptionControllerC.text.isEmpty) description = true;
                if (_descriptionControllerD.text.isEmpty) description = true;
              });
            }
          }),
    );
  }
}