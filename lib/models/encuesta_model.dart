import 'package:hive/hive.dart';

part 'encuesta_model.g.dart';

@HiveType(typeId: 1)
class Encuesta extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String usuarioId;

  /// Clave: texto completo de la pregunta
  /// Valor: "1", "2" o "3"
  @HiveField(2)
  Map<String, String> respuestas;

  @HiveField(3)
  DateTime fecha;

  @HiveField(4)
  bool enviada;

  Encuesta({
    required this.id,
    required this.usuarioId,
    required this.respuestas,
    required this.fecha,
    required this.enviada,
  });
}
