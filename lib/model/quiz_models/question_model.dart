import 'dart:convert';

import 'package:historyar_app/model/quiz_models/alternative_model.dart';

class Question {
  Question({
    required this.id,
    required this.descripcion,
    required this.puntaje,
    required this.alternativas,
  });

  final int id;
  final String descripcion;
  final double puntaje;
  final List<Alternative> alternativas;

  factory Question.fromJson(String str) => Question.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Question.fromMap(Map<String, dynamic> json) => Question(
        id: json['id'],
        descripcion: json['descripcion'],
        puntaje: json['puntaje'],
        alternativas: List<Alternative>.from(
            json['alternativas'].map((x) => Alternative.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'descripcion': descripcion,
        'puntaje': puntaje,
        'alternativas': List<dynamic>.from(alternativas.map((x) => x.toMap())),
      };
}
