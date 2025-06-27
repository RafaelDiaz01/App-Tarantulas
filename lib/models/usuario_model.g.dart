// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UsuarioAdapter extends TypeAdapter<Usuario> {
  @override
  final int typeId = 0;

  @override
  Usuario read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Usuario(
      id: fields[0] as String,
      nombre: fields[1] as String,
      edad: fields[2] as int,
      sexo: fields[3] as String,
      lenguaMaterna: fields[4] as String,
      grupoEtnico: fields[5] as String,
      fuenteTrabajo: fields[6] as String,
      escolaridad: fields[7] as String,
      tenenciaTierra: fields[8] as String,
      estadoCivil: fields[9] as String,
      lugarOrigen: fields[10] as String,
      numeroHijos: fields[11] as int,
      localidad: fields[12] as String,
      fechaRegistro: fields[13] as DateTime,
      respuestas: (fields[14] as Map?)?.cast<String, String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Usuario obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nombre)
      ..writeByte(2)
      ..write(obj.edad)
      ..writeByte(3)
      ..write(obj.sexo)
      ..writeByte(4)
      ..write(obj.lenguaMaterna)
      ..writeByte(5)
      ..write(obj.grupoEtnico)
      ..writeByte(6)
      ..write(obj.fuenteTrabajo)
      ..writeByte(7)
      ..write(obj.escolaridad)
      ..writeByte(8)
      ..write(obj.tenenciaTierra)
      ..writeByte(9)
      ..write(obj.estadoCivil)
      ..writeByte(10)
      ..write(obj.lugarOrigen)
      ..writeByte(11)
      ..write(obj.numeroHijos)
      ..writeByte(12)
      ..write(obj.localidad)
      ..writeByte(13)
      ..write(obj.fechaRegistro)
      ..writeByte(14)
      ..write(obj.respuestas);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UsuarioAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
