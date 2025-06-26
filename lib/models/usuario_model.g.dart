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
      nivelEstudios: fields[6] as String,
      fuenteTrabajo: fields[7] as String,
      escolaridad: fields[8] as String,
      tenenciaTierra: fields[9] as String,
      estadoCivil: fields[10] as String,
      lugarOrigen: fields[11] as String,
      numeroHijos: fields[12] as int,
      localidad: fields[13] as String,
      fechaRegistro: fields[14] as DateTime,
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
      ..write(obj.nivelEstudios)
      ..writeByte(7)
      ..write(obj.fuenteTrabajo)
      ..writeByte(8)
      ..write(obj.escolaridad)
      ..writeByte(9)
      ..write(obj.tenenciaTierra)
      ..writeByte(10)
      ..write(obj.estadoCivil)
      ..writeByte(11)
      ..write(obj.lugarOrigen)
      ..writeByte(12)
      ..write(obj.numeroHijos)
      ..writeByte(13)
      ..write(obj.localidad)
      ..writeByte(14)
      ..write(obj.fechaRegistro);
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
