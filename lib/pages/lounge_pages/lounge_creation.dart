import 'package:flutter/material.dart';
import 'package:flutter_elegant_number_button/flutter_elegant_number_button.dart';
import 'package:historyar_app/providers/lounge_provider.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/input_text.dart';

class LoungeCreation extends StatefulWidget {

  final int id;
  final int type;

  const LoungeCreation({
    required this.id,
    required this.type,
    Key? key
  }) : super(key: key);

  @override
  _LoungeCreationState createState() => _LoungeCreationState();
}

class _LoungeCreationState extends State<LoungeCreation> {

  ColorPalette _colorPalette = ColorPalette();
  InputText _inputText = InputText();
  Alert _alert = Alert();
  var _salaProvider = LoungeProvider();

  bool title = false;
  bool description = false;

  FocusNode focus_title = FocusNode();
  FocusNode focus_description = FocusNode();
  FocusNode focus_password = FocusNode();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  int _numberController = 20;

  @override
  Widget build(BuildContext context) {
    focus_title.addListener(() {
      setState(() {});
    });
    focus_description.addListener(() {
      setState(() {});
    });
    focus_password.addListener(() {
      setState(() {});
    });

    return Scaffold(
      backgroundColor: _colorPalette.cream,
      appBar: AppBar(
          backgroundColor: _colorPalette.darkBlue,
          title:
          Text('Nueva Sala', style: TextStyle(fontWeight: FontWeight.w700))
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cantidad Participantes',
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
                        initialValue: _numberController,
                        buttonSizeWidth: 30,
                        buttonSizeHeight: 25,
                        color: _colorPalette.lightBlue,
                        minValue: 2,
                        maxValue: 50,
                        step: 1,
                        decimalPlaces: 0,
                        onChanged: (value){
                          setState(() {
                            _numberController = value.toInt();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: _inputText.defaultIText(
                      focus_password,
                      _passwordController,
                      TextInputType.text,
                      'Contraseña (Opcional)',
                      '',
                      false,
                      'Contraseña (Opcional)',
                      false),
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
          child: Text('Crear',
              style: TextStyle(
                  color: _colorPalette.yellow, fontWeight: FontWeight.bold, fontSize: 18)),
          onPressed: () {
            if (_titleController.text.isNotEmpty &&
                _descriptionController.text.isNotEmpty) {
              _salaProvider.crear(_titleController.text,
                  _descriptionController.text,
                  _passwordController.text,
                  widget.id, widget.type, context);
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
