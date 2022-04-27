import 'dart:convert';

class LoginRequest {
  LoginRequest({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  factory LoginRequest.fromJson(String str) =>
      LoginRequest.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LoginRequest.fromMap(Map<String, dynamic> json) => LoginRequest(
        email: json['email'],
        password: json['password'],
      );

  Map<String, dynamic> toMap() => {
        'email': email,
        'password': password,
      };
}
