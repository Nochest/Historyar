import 'package:historyar_app/model/alternatives.dart';

class Pregunta {
  final int id;
  final String descripcion;
  final int puntaje;
  final List<Alternativa> alternativas;

  Pregunta(this.id, this.descripcion, this.puntaje, this.alternativas);
}