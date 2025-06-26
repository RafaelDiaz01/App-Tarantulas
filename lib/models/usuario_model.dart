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
  String nivelEstudios;

  @HiveField(7)
  String fuenteTrabajo;

  @HiveField(8)
  String escolaridad;

  @HiveField(9)
  String tenenciaTierra;

  @HiveField(10)
  String estadoCivil;

  @HiveField(11)
  String lugarOrigen;

  @HiveField(12)
  int numeroHijos;

  @HiveField(13)
  String localidad;

  @HiveField(14)
  DateTime fechaRegistro;

  Usuario({
    required this.id,
    required this.nombre,
    required this.edad,
    required this.sexo,
    required this.lenguaMaterna,
    required this.grupoEtnico,
    required this.nivelEstudios,
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
