import 'package:hive/hive.dart';

part 'usuario_model.g.dart';

@HiveType(typeId: 0)
class Usuario extends HiveObject {
  @HiveField(0)
  String id; // Puede ser UUID o un timestamp como string

  @HiveField(1)
  String nombre;

  @HiveField(2)
  int edad;

  @HiveField(3)
  String sexo;

  @HiveField(4)
  String lenguaMaterna;

  @HiveField(5)
  String grupoEtnico;

  @HiveField(6)
  String fuenteTrabajo;

  @HiveField(7)
  String escolaridad;

  @HiveField(8)
  String tenenciaTierra;

  @HiveField(9)
  String estadoCivil;

  @HiveField(10)
  String lugarOrigen;

  @HiveField(11)
  int numeroHijos;

  @HiveField(12)
  String localidad;

  @HiveField(13)
  DateTime fechaRegistro;

  Usuario({
    required this.id,
    required this.nombre,
    required this.edad,
    required this.sexo,
    required this.lenguaMaterna,
    required this.grupoEtnico,
    required this.fuenteTrabajo,
    required this.escolaridad,
    required this.tenenciaTierra,
    required this.estadoCivil,
    required this.lugarOrigen,
    required this.numeroHijos,
    required this.localidad,
    required this.fechaRegistro,
  });
}
