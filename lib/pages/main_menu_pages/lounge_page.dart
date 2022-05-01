import 'package:flutter/material.dart';
import 'package:historyar_app/model/lounge.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_creation.dart';
import 'package:historyar_app/pages/lounge_pages/my_lounges.dart';
import 'package:historyar_app/providers/lounge_provider.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/app_bar.dart';
import 'package:historyar_app/widgets/button_app_bar.dart';
import 'package:historyar_app/widgets/input_text.dart';

class Lounge extends StatefulWidget {
  final int id;
  final int type;

  const Lounge({required this.id, required this.type, Key? key})
      : super(key: key);

  @override
  _LoungeState createState() => _LoungeState();
}

class _LoungeState extends State<Lounge> {

  ColorPalette _colorPalette = ColorPalette();
  var _salaProvider = LoungeProvider();
  InputText _inputText = InputText();

  bool code = false;
  bool password = false;

  FocusNode focus_code = FocusNode();
  FocusNode focus_password = FocusNode();

  TextEditingController _codeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _colorPalette.lightBlue,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Salas',
          style: TextStyle(color: _colorPalette.yellow),
        ),
      ),
      backgroundColor: _colorPalette.cream,
      body: FutureBuilder(
        future: _salaProvider.getByUserId(widget.id, widget.type),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Container(
                      decoration: BoxDecoration(
                        color: _colorPalette.lightBlue,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: _colorPalette.yellow,
                          width: 2.0,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.event_note,
                          color: _colorPalette.yellow,
                        ),
                        title: Text(
                          'Ingresar a Sala',
                          style: TextStyle(
                              color: _colorPalette.yellow,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700),
                        ),
                        onTap: () {
                          createAlert(context);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: _colorPalette.lightBlue,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: _colorPalette.yellow,
                          width: 2.0,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.event_note,
                          color: _colorPalette.yellow,
                        ),
                        title: Text(
                          'Mis Salas',
                          style: TextStyle(
                              color: _colorPalette.yellow,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder:
                                  (BuildContext context) => MyLounges(id: widget.id, type: widget.type)
                          ));
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: _colorPalette.lightBlue,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: _colorPalette.yellow,
                          width: 2.0,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.event_note,
                          color: _colorPalette.yellow,
                        ),
                        title: Text(
                          'Crear sala',
                          style: TextStyle(
                              color: _colorPalette.yellow,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder:
                                  (BuildContext context) => LoungeCreation(id: widget.id, type: widget.type)
                          ));
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Estadísticas',
                          style: TextStyle(
                              color: _colorPalette.yellow,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.left,
                        )
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Salas creadas',
                                      style: TextStyle(
                                          color: _colorPalette.darkBlue,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.left,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                      },
                                      child: Text('25',
                                          style: TextStyle(
                                              color: _colorPalette.yellow,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Exámenes generados',
                                      style: TextStyle(
                                          color: _colorPalette.darkBlue,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.left,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                      },
                                      child: Text('10',
                                          style: TextStyle(
                                              color: _colorPalette.yellow,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Historias Creadas',
                                      style: TextStyle(
                                          color: _colorPalette.darkBlue,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.left,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                      },
                                      child: Text('100',
                                          style: TextStyle(
                                              color: _colorPalette.yellow,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Promedio de Notas',
                                      style: TextStyle(
                                          color: _colorPalette.darkBlue,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.left,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                      },
                                      child: Text('18.5',
                                          style: TextStyle(
                                              color: _colorPalette.yellow,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: historyarButtonApp(context, false, widget.id, widget.type),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: historyarBottomAppBar(
          context, false, true, false, false, widget.id, widget.type),
    );
  }

  void createAlert(BuildContext context) {

    _codeController.text = "";
    _passwordController.text = "";

    showDialog(
        barrierColor: _colorPalette.lightBlue.withOpacity(0.6),
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            title: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                    child: Text("Ingresar a una sala",
                        style: TextStyle(
                            color: _colorPalette.darkBlue,
                            fontWeight: FontWeight.w700,
                            fontSize: 24.0)))),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: _inputText.defaultIText(
                        focus_code,
                        _codeController,
                        TextInputType.text,
                        'Ingrese el código',
                        '',
                        true,
                        'Ingrese el código',
                        code),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: _inputText.defaultIText(
                        focus_password,
                        _passwordController,
                        TextInputType.text,
                        'Ingrese su contraeña',
                        '',
                        true,
                        'Ingrese su contraeña',
                        password),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 2.0),
                      child: default_button(context)),
                  Padding(
                      padding: EdgeInsets.only(top: 2.0),
                      child: accept_button(context))
                ],
              ),
            ),
          );
        });
  }

  Widget default_button(BuildContext context) {
    return MaterialButton(
        height: 36.0,
        minWidth: 126.0,
        color: _colorPalette.lightBlue,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
        child: Text("Cancelar",
            style: TextStyle(
                color: _colorPalette.text, fontWeight: FontWeight.w600)),
        onPressed: () {
          setState(() {
            _codeController.text = "";
            _passwordController.text = "";
          });
          Navigator.of(context).pop();
        });
  }

  Widget accept_button(BuildContext context) {
    return MaterialButton(
        height: 36.0,
        minWidth: 126.0,
        color: _colorPalette.lightBlue,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
        child: Text("Aceptar",
            style: TextStyle(
                color: _colorPalette.text, fontWeight: FontWeight.w600)),
        onPressed: () {
          if (_codeController.text.isNotEmpty) {
            _salaProvider.getByCode(_codeController.text, _passwordController.text,
                widget.id, widget.type, context);
          } else {
            setState(() {
              _codeController.text = "";
              _passwordController.text = "";
              code = true;
              password = true;
            });
          }
        });
  }
}
