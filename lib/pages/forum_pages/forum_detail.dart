import 'package:flutter/material.dart';
import 'package:historyar_app/providers/forum_provider.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/app_bar.dart';
import 'package:historyar_app/widgets/button_app_bar.dart';

class ForumDetail extends StatefulWidget {
  final int id;
  final int type;
  final String title;
  final String description;
  final int userId;

  const ForumDetail(
      {Key? key,
      required this.id,
      required this.title,
      required this.description,
      required this.type,
      required this.userId})
      : super(key: key);

  @override
  _ForumDetailState createState() => _ForumDetailState();
}

class _ForumDetailState extends State<ForumDetail> {
  final alert = Alert();

  ColorPalette _colorPalette = ColorPalette();
  TextEditingController _controller = TextEditingController();

  var _forumProvider = ForumProvider();
  Alert _alert = Alert();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: _colorPalette.lightBlue,
          centerTitle: true,
          elevation: 0,
          title: Text(
            widget.title,
            style: TextStyle(color: _colorPalette.yellow),
          ),
        ),
        backgroundColor: _colorPalette.cream,
        body: FutureBuilder(
          future: _forumProvider.getCommments(widget.id, widget.userId),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(top: 24.0),
                              child: Container(
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    color: _colorPalette.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        color: _colorPalette.yellow,
                                        width: 2.0)),
                                child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: ListTile(
                                      title: Text(widget.title,
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              color: _colorPalette.darkBlue),
                                          textAlign: TextAlign.justify),
                                      subtitle: Text(widget.description,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              color: _colorPalette.text),
                                          textAlign: TextAlign.justify),
                                    )),
                              )),
                          Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: _comment_box(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [Spacer(), _commentButton(context)],
                            ),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 280.0,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, i) {
                                    return GestureDetector(
                                      child: Padding(
                                          padding: EdgeInsets.only(top: 20.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: _colorPalette.white,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                border: Border.all(
                                                    color: _colorPalette.yellow,
                                                    width: 2.0)),
                                            child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: ListTile(
                                                  title: Text(
                                                      snapshot.data[i].usuario,
                                                      style: TextStyle(
                                                          fontSize: 15.0,
                                                          color: _colorPalette
                                                              .darkBlue),
                                                      textAlign:
                                                          TextAlign.justify),
                                                  subtitle: Text(
                                                      snapshot
                                                          .data[i].descripcion,
                                                      style: TextStyle(
                                                          fontSize: 12.0,
                                                          color: _colorPalette
                                                              .text),
                                                      textAlign:
                                                          TextAlign.justify),
                                                )),
                                          )),
                                      onTap: () {
                                        //TODO: Go to journey detail passing data
                                      },
                                    );
                                  }),
                            ),
                          ),
                        ],
                      )),
                ),
              );
            }
          },
        ));
  }

  Widget _comment_box() {
    return Container(
      width: double.maxFinite,
      height: 75.0,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5.0)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: TextFormField(
          controller: _controller,
          expands: true,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          enableInteractiveSelection: false,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Ingrese su comentario',
              hintStyle: TextStyle(
                  fontSize: 16.0,
                  color: _colorPalette.yellow,
                  fontWeight: FontWeight.w400)),
          cursorColor: _colorPalette.lightBlue,
        ),
      ),
    );
  }

  Widget _commentButton(BuildContext context) {
    return Center(
      child: MaterialButton(
          height: 32.0,
          minWidth: 104.0,
          color: _colorPalette.darkBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
              side: BorderSide(color: _colorPalette.yellow)),
          child: Text('Comentar',
              style: TextStyle(
                  fontSize: 14.0,
                  color: _colorPalette.yellow,
                  fontWeight: FontWeight.w600)),
          onPressed: () async {
            var aux = false;
            //TODO: Push comment
            if (_controller.text.isNotEmpty) {
              aux = await _forumProvider.comentar(
                  _controller.text, 0, widget.userId, widget.id);
            } else {
              alert.createAlert(context, 'Error',
                  'No puede ingresar un comentario vacio', 'ok');
            }

            print(aux);
            if (aux == true) {
              setState(() {
                _controller.text = "";
              });
            } else {
              _alert.createAlert(context, "Algo salió mal",
                  "No se ha podido realizar el comentario.", "aceptar");
            }
          }),
    );
  }
}
