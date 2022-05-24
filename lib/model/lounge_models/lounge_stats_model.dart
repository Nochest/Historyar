import 'dart:convert';

class LoungeStatsModel {
  LoungeStatsModel({
    required this.salas,
    required this.examenes,
    required this.historias,
    required this.promedio,
  });

  final String? salas;
  final String? examenes;
  final String? historias;
  final String? promedio;

  factory LoungeStatsModel.fromJson(String str) =>
      LoungeStatsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoungeStatsModel.fromMap(Map<String, dynamic> json) =>
      LoungeStatsModel(
        salas: json['salas'] ?? '0',
        examenes: json['examenes'] ?? '0',
        historias: json['historias'] ?? '0',
        promedio: json['promedio'] ?? '0',
      );

  Map<String, dynamic> toMap() => {
        'salas': salas,
        'examenes': examenes,
        'historias': historias,
        'promedio': promedio,
      };
}
