import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:custom_radio_group_list/custom_radio_group_list.dart';
import 'package:historyar_app/model/quiz_models/alternative_model.dart';

import 'package:historyar_app/model/quiz_models/question_model.dart';
import 'package:historyar_app/model/quiz_models/quiz_model.dart';
import 'package:historyar_app/pages/lounge_pages/lounge_participants.dart';
import 'package:historyar_app/providers/quiz_provider.dart';
import 'package:historyar_app/utils/color_palette.dart';

class QuizResolution extends StatefulWidget {
  final int id;
  final int salaId;
  final String salaName;
  final int asistenciaId;
  final int type;

  const QuizResolution(
      {required this.id,
      required this.salaId,
      required this.salaName,
      required this.asistenciaId,
      required this.type,
      Key? key})
      : super(key: key);

  @override
  _QuizResolutionState createState() => _QuizResolutionState();
}

List<int> respuestas = [];

class _QuizResolutionState extends State<QuizResolution> {
  final _colorPalette = ColorPalette();
  final qProvider = QuizProvider();

  Quiz quiz = Quiz(id: 1, tema: 'tema', descripcion: 'descripcion', preguntas: []);

  getData() async {
    quiz = await qProvider.getQuiz(widget.salaId);
    setState(() {});
  }

  @override
  void initState() {
    respuestas = [];
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1));
    inspect(quiz);
    return WillPopScope(
      onWillPop: () async {

        Navigator.of(context).push(
          MaterialPageRoute(builder:
              (BuildContext context) => LoungeParticipant(id: widget.id, type: widget.type, salaId: widget.salaId,
            salaName: widget.salaName, asistenciaId: widget.asistenciaId,)
          ),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: _colorPalette.cream,
        appBar: AppBar(
          backgroundColor: _colorPalette.darkBlue,
          title:
              Text('Cuestionario', style: TextStyle(fontWeight: FontWeight.w700)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: _colorPalette.lightBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      quiz.tema,
                      style: TextStyle(
                        fontSize: 18,
                        color: _colorPalette.yellow,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      quiz.descripcion,
                      style: TextStyle(
                        fontSize: 14,
                        color: _colorPalette.yellow,
                      ),
                    ),
                    trailing: Icon(
                      Icons.quiz,
                      color: _colorPalette.yellow,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: quiz.preguntas.length,
                  itemBuilder: (context, i) {
                    return _QuizItem(question: quiz.preguntas[i]);
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                ),
                const SizedBox(height: 32),
                MaterialButton(
                  height: 32.0,
                  minWidth: 180.0,
                  color: _colorPalette.darkBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      side: BorderSide(color: _colorPalette.yellow)),
                  child: Text('Enviar',
                      style: TextStyle(
                          fontSize: 14.0,
                          color: _colorPalette.yellow,
                          fontWeight: FontWeight.w600)),
                  onPressed: () {
                    qProvider.responder(quiz.id,
                        respuestas,
                        widget.id,
                        widget.type,
                        widget.salaId,
                        widget.salaName,
                        widget.asistenciaId,
                        context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuizItem extends StatefulWidget {
  const _QuizItem({
    Key? key,
    required this.question
  }) : super(key: key);
  final Question question;
  @override
  State<_QuizItem> createState() => __QuizItemState();
}

class __QuizItemState extends State<_QuizItem> {
  int selected = -1;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.question.descripcion,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Column(
          children: widget.question.alternativas.map((data) {
            return RadioListTile<int>(
              title: Text("${data.descripcion}"),
              groupValue: selected,
              value: data.id,
              onChanged: (int? val) {

                try {
                  if(respuestas.length > 0) {
                    for(var aux in widget.question.alternativas)
                      if(respuestas.contains(aux.id))
                        respuestas.remove(aux.id);
                  }else {

                  }
                } catch (error) {
                  log(error.toString());
                }

                setState(() {

                  selected = val!;
                  print(selected);
                  respuestas.add(selected);

                });
                print(respuestas);

              },
            );
          }).toList(),
        )
      ],
    );
  }
}
