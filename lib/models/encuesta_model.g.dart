// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encuesta_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EncuestaAdapter extends TypeAdapter<Encuesta> {
  @override
  final int typeId = 1;

  @override
  Encuesta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Encuesta(
      id: fields[0] as String,
      usuarioId: fields[1] as String,
      respuestas: (fields[2] as Map).cast<String, String>(),
      fecha: fields[3] as DateTime,
      enviada: fields[4] as bool,
      comentarioPersonal: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Encuesta obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.usuarioId)
      ..writeByte(2)
      ..write(obj.respuestas)
      ..writeByte(3)
      ..write(obj.fecha)
      ..writeByte(4)
      ..write(obj.enviada)
      ..writeByte(5)
      ..write(obj.comentarioPersonal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EncuestaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
