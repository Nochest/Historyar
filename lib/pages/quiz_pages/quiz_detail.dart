import 'package:flutter/material.dart';
import 'package:historyar_app/model/question.dart';
import 'package:historyar_app/model/quiz.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_detail.dart';
import 'package:historyar_app/pages/lounge_pages/my_lounges.dart';
import 'package:historyar_app/pages/main_menu_pages/lounge_page.dart';
import 'package:historyar_app/pages/question_pages/question_creation.dart';
import 'package:historyar_app/providers/quiz_provider.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/input_text.dart';

class QuizDetail extends StatefulWidget {

  final int id;
  final int salaId;
  final String salaName;
  final int type;

  const QuizDetail({
    required this.id,
    required this.salaId,
    required this.salaName,
    required this.type,
    Key? key
  }) : super(key: key);

  @override
  _QuizDetailState createState() => _QuizDetailState();
}

class _QuizDetailState extends State<QuizDetail> {

  Widget _buildQ(int index, Pregunta pregunta){
    return Padding(
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
                Text(pregunta.descripcion,
                    style: TextStyle(
                        color: _colorPalette.text,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400)),
                Text(pregunta.puntaje.toString() + " puntos",
                    style: TextStyle(
                        color: _colorPalette.yellow,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 8.0),
                Container(
                  child: Column(
                    children: pregunta.alternativas!.map((e) =>
                        _buildA(e.descripcion, e.correcto)).toList(),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }


  Widget _buildA(String alternativa, bool correcto){
    Color color = Colors.red;
    String texto = 'incorrecto';

    if(correcto == true) {
      color = Colors.green;
      texto = 'correcto';
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              alternativa,
              style: TextStyle(
                  color: _colorPalette.lightBlue,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.left,
            ),
          ),
          Text(
            texto,
            style: TextStyle(
                color: color,
                fontSize: 15.0,
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  ColorPalette _colorPalette = ColorPalette();
  InputText _inputText = InputText();
  Alert _alert = Alert();
  var _cuestionarioProvider = QuizProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _colorPalette.cream,
        appBar: AppBar(
          backgroundColor: _colorPalette.darkBlue,
          title:
          Text('Cuestionario', style: TextStyle(fontWeight: FontWeight.w700)),
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
        body: FutureBuilder(
        future: _cuestionarioProvider.getQuizByLoungeId(widget.salaId),
        builder: (BuildContext context, AsyncSnapshot<Cuestionario?> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Tema',
                            style: TextStyle(
                                color: _colorPalette.text,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400)),
                        Text(
                            snapshot.data!.tema,
                            style: TextStyle(
                                color: _colorPalette.yellow,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600)),
                        SizedBox(height: 8.0),
                        Text('Descripción',
                            style: TextStyle(
                                color: _colorPalette.text,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400)),
                        Text(
                            snapshot.data!.descripcion,
                            style: TextStyle(
                                color: _colorPalette.yellow,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Preguntas',
                          style: TextStyle(
                              color: _colorPalette.yellow,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700),
                          textAlign: TextAlign.left,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder:
                                  (BuildContext context) => QuestionCreation(id: widget.id, salaId: widget.salaId,
                                      salaName: widget.salaName, cuestionarioId: snapshot.data!.id, type: widget.type)
                              ),
                            );
                          },
                          child: Text('Agregar',
                              style: TextStyle(
                                  color: _colorPalette.lightBlue,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    FutureBuilder(
                        future: _cuestionarioProvider.getQuestionsByQuizId(snapshot.data!.id),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Pregunta>?> snapshots) {

                          if(snapshots.data == null) {
                            return Center(child: CircularProgressIndicator());
                          }
                          else {
                            return Column(
                              children: snapshots.data!.map((e) =>
                                    _buildQ(e.id, e)).toList()
                              ,
                            );
                          }
                        }
                    ),
                  ],
                ),
              ),
            );
          }
        }
      )
    );


  }

}
