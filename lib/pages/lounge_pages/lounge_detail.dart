import 'package:flutter/material.dart';
import 'package:historyar_app/model/attendance.dart';
import 'package:historyar_app/pages/lounge_pages/my_lounges.dart';
import 'package:historyar_app/pages/quiz_pages/quiz_creation.dart';
import 'package:historyar_app/pages/quiz_pages/quiz_detail.dart';
import 'package:historyar_app/providers/attendance_provider.dart';
import 'package:historyar_app/providers/lounge_provider.dart';
import 'package:historyar_app/providers/quiz_provider.dart';
import 'package:historyar_app/utils/alert.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/input_text.dart';

class LoungeDetail extends StatefulWidget {

  final int id;
  final int salaId;
  final String salaName;
  final int type;

  const LoungeDetail({
    required this.id,
    required this.salaId,
    required this.salaName,
    required this.type,
    Key? key
  }) : super(key: key);

  @override
  _LoungeDetailState createState() => _LoungeDetailState();
}

class _LoungeDetailState extends State<LoungeDetail> {

  Widget _buildIcon(int index, String name){
    return Container(
      height: 80.0,
      width: 80.0,
      child: Column(
        children: [
          GestureDetector(
            child: Icon(Icons.attribution_rounded, size: 60.0),
            onTap: (){

            },
          ),
          Center(child: Text(name,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.0),
              overflow: TextOverflow.clip,
              maxLines: 1,
              softWrap: false,
            )
          )
        ],
      ),
    );
  }

  ColorPalette _colorPalette = ColorPalette();
  InputText _inputText = InputText();
  Alert _alert = Alert();
  var _salaProvider = LoungeProvider();
  var _atencionProvider = AttendanceProvider();
  var _cuestionarioProvider = QuizProvider();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {

        Navigator.of(context).push(
          MaterialPageRoute(builder:
              (BuildContext context) => MyLounges(id: widget.id, type: widget.type)
          ),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: _colorPalette.cream,
        appBar: AppBar(
          backgroundColor: _colorPalette.darkBlue,
          title:
          Text('Sala ${widget.salaName}', style: TextStyle(fontWeight: FontWeight.w700)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder:
                    (BuildContext context) => MyLounges(id: widget.id, type: widget.type)
                ),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {

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
                      'Participantes',
                      style: TextStyle(
                          color: _colorPalette.yellow,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                FutureBuilder(
                    future: _atencionProvider.getAttendancesByLoungeId(2),
                    builder: (BuildContext context, AsyncSnapshot<List<Asistencia>> snapshot) {

                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return Container(
                            child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 5.0,
                              runSpacing: 5.0,
                              children:
                              snapshot.data!.map((e) =>
                                  _buildIcon(e.id, e.nombres)).toList()
                              ,
                            )
                        );
                      }
                    }
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cuestionario',
                      style: TextStyle(
                          color: _colorPalette.yellow,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.left,
                    ),
                    FutureBuilder(
                    future: _cuestionarioProvider.getQuizByLoungeId(widget.salaId),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null) {
                        return
                          MaterialButton(
                              height: 30.0,
                              minWidth: 100.0,
                              color: _colorPalette.lightBlue,
                              shape:
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                              child: Text("Crear",
                                  style: TextStyle(
                                      color: _colorPalette.text, fontWeight: FontWeight.w600)),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder:
                                      (BuildContext context) => QuizCreation(id: widget.id, type: widget.type, salaId: widget.salaId,
                                        salaName: widget.salaName)
                                  ),
                                );
                              }
                          );
                      } else {
                        return
                          MaterialButton(
                              height: 30.0,
                              minWidth: 100.0,
                              color: _colorPalette.lightBlue,
                              shape:
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
                              child: Text("Ver",
                                  style: TextStyle(
                                      color: _colorPalette.text, fontWeight: FontWeight.w600)),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder:
                                      (BuildContext context) => QuizDetail(id: widget.id, type: widget.type, salaId: widget.salaId, salaName: widget.salaName,)
                                  ),
                                );
                              }
                          );
                      }
                    }),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Descargar Notas',
                      style: TextStyle(
                          color: _colorPalette.yellow,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ),
    );


  }

}
