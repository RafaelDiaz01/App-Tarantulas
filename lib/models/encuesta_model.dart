import 'package:hive/hive.dart';
part 'encuesta_model.g.dart';

@HiveType(typeId: 1)
class Encuesta extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String usuarioId;

  @HiveField(2)
  Map<String, String> respuestas;

  @HiveField(3)
  DateTime fecha;

  @HiveField(4)
  bool enviada;

  // Nuevo campo para comentarios libres
  @HiveField(5)
  String? comentarioPersonal;

  Encuesta({
    required this.id,
    required this.usuarioId,
    required this.respuestas,
    required this.fecha,
    required this.enviada,
    this.comentarioPersonal,
  });
}
