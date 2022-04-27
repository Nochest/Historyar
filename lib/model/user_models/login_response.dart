import 'dart:convert';

class LoginResponse {
  LoginResponse({
    required this.id,
    required this.nombres,
    required this.apellidos,
    required this.email,
    required this.password,
    required this.fechaNacimiento,
    required this.tipoUsuario,
    required this.autorizado,
    required this.eliminado,
  });

  final int id;
  final String nombres;
  final String apellidos;
  final String email;
  final String password;
  final DateTime fechaNacimiento;
  final int tipoUsuario;
  final bool autorizado;
  final bool eliminado;

  factory LoginResponse.fromJson(String str) =>
      LoginResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
        id: json['id'],
        nombres: json['nombres'],
        apellidos: json['apellidos'],
        email: json['email'],
        password: json['password'],
        fechaNacimiento: DateTime.parse(json['fechaNacimiento']),
        tipoUsuario: json['tipoUsuario'],
        autorizado: json['autorizado'],
        eliminado: json['eliminado'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nombres': nombres,
        'apellidos': apellidos,
        'email': email,
        'password': password,
        'fechaNacimiento':
            '${fechaNacimiento.year.toString().padLeft(4, '0')}-${fechaNacimiento.month.toString().padLeft(2, '0')}-${fechaNacimiento.day.toString().padLeft(2, '0')}',
        'tipoUsuario': tipoUsuario,
        'autorizado': autorizado,
        'eliminado': eliminado,
      };
}
