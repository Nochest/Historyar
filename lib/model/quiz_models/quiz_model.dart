import 'dart:convert';

import 'package:historyar_app/model/quiz_models/question_model.dart';

class Quiz {
  Quiz({
    required this.id,
    required this.tema,
    required this.descripcion,
    required this.preguntas,
  });

  final int id;
  final String tema;
  final String descripcion;
  final List<Question> preguntas;

  factory Quiz.fromJson(String str) => Quiz.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Quiz.fromMap(Map<String, dynamic> json) => Quiz(
        id: json['id'],
        tema: json['tema'],
        descripcion: json['descripcion'],
        preguntas: List<Question>.from(
            json['preguntas'].map((x) => Question.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'tema': tema,
        'descripcion': descripcion,
        'preguntas': List<dynamic>.from(preguntas.map((x) => x.toMap())),
      };
}
