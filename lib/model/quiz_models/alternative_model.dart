import 'dart:convert';

class Alternative {
  Alternative({
    required this.id,
    required this.descripcion,
    required this.correcto,
  });

  final int id;
  final String descripcion;
  final bool correcto;

  factory Alternative.fromJson(String str) =>
      Alternative.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Alternative.fromMap(Map<String, dynamic> json) => Alternative(
        id: json['id'],
        descripcion: json['descripcion'],
        correcto: json['correcto'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'descripcion': descripcion,
        'correcto': correcto,
      };
}
