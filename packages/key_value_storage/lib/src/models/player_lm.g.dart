// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_lm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerLMAdapter extends TypeAdapter<PlayerLM> {
  @override
  final int typeId = 1;

  @override
  PlayerLM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerLM(
      username: fields[0] as String,
      uid: fields[1] as String,
      charactersIds: (fields[2] as List).cast<int>(),
      profilePictureUrl: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerLM obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.uid)
      ..writeByte(2)
      ..write(obj.charactersIds)
      ..writeByte(3)
      ..write(obj.profilePictureUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerLMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
