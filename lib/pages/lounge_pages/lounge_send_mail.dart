import 'package:flutter/material.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_detail.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_story_rate.dart';
import 'package:historyar_app/providers/story_provider.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/input_text.dart';

class LoungeSendMail extends StatefulWidget {

  final int id;
  final int salaId;
  final String salaName;
  final int type;

  const LoungeSendMail({
    required this.id,
    required this.salaId,
    required this.salaName,
    required this.type,
    Key? key
  }) : super(key: key);

  @override
  _LoungeSendMailState createState() => _LoungeSendMailState();
}

class _LoungeSendMailState extends State<LoungeSendMail> {

  final List<String> listado = [];
  InputText _inputText = InputText();

  ColorPalette _colorPalette = ColorPalette();
  bool email = false;
  FocusNode focus_email = FocusNode();
  Alert _alert = Alert();
  TextEditingController _emailController = TextEditingController();
  var _storyProvider = StoryProvider();

  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).push(
          MaterialPageRoute(builder:
              (BuildContext context) => LoungeDetail(id: widget.id, type: widget.type, salaId: widget.salaId,
              salaName: widget.salaName)
          ),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: _colorPalette.cream,
        appBar: AppBar(
          backgroundColor: _colorPalette.darkBlue,
          title:
          Text('Enviar notificación', style: TextStyle(fontWeight: FontWeight.w700)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder:
                    (BuildContext context) => LoungeDetail(id: widget.id, type: widget.type, salaId: widget.salaId,
                    salaName: widget.salaName)
                ),
              );
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.salaName,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: _colorPalette.darkBlue),
                              textAlign: TextAlign.justify),
                          _sendButton(context)
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: _mailBox(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [Spacer(), _saveButton(context)],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: listado.length,
                      itemBuilder: (BuildContext context, int i) {
                        final item = listado[i];

                        return Column(
                            children: [
                              Divider(color: Colors.black),
                              Padding(
                                  padding: EdgeInsets.only(
                                      right: 10.0, left: 10.0),
                                  child: ListTile(
                                      title: Text(item,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: _colorPalette.darkBlue),
                                          textAlign: TextAlign.justify),
                                      trailing: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              listado.remove(item);
                                            });
                                          },
                                          icon: Icon(Icons.delete)
                                      )
                                  )
                              ),
                            ]
                        );
                      },
                    )
                  ],
                )),
          ),
        )
      ),
    );
  }

  Widget _mailBox() {
    return Container(
      width: double.maxFinite,
      height: 75.0,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: _inputText.defaultIText(
            focus_email,
            _emailController,
            TextInputType.text,
            'Correo electrónico',
            '',
            false,
            'Correo electrónico',
            email)
      ),
    );
  }

  Widget _saveButton(BuildContext context) {
    return Center(
      child: MaterialButton(
          height: 32.0,
          minWidth: 104.0,
          color: _colorPalette.darkBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
              side: BorderSide(color: _colorPalette.yellow)),
          child: Text('Agregar',
              style: TextStyle(
                  fontSize: 14.0,
                  color: _colorPalette.yellow,
                  fontWeight: FontWeight.w600)),
          onPressed: () async {
            if(_emailController.text.isNotEmpty) {
              setState(() {
                listado.add(_emailController.text);
              });
            }
            else{
              _alert.createAlert(
                  context, "Algo salió mal", "El correo está vacío.",
                  "aceptar");
            }
          }),
    );
  }


  Widget _sendButton(BuildContext context) {
    return Center(
      child: MaterialButton(
          height: 32.0,
          minWidth: 104.0,
          color: _colorPalette.darkBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
              side: BorderSide(color: _colorPalette.yellow)),
          child: Text('Agregar',
              style: TextStyle(
                  fontSize: 14.0,
                  color: _colorPalette.yellow,
                  fontWeight: FontWeight.w600)),
          onPressed: () async {
            if(_emailController.text.isNotEmpty) {
              setState(() {
                listado.add(_emailController.text);
              });
            }
            else{
              _alert.createAlert(
                  context, "Algo salió mal", "El correo está vacío.",
                  "aceptar");
            }
          }),
    );
  }
}
