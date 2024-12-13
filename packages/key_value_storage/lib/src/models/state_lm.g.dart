// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_lm.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStateLMAdapter extends TypeAdapter<UserStateLM> {
  @override
  final int typeId = 0;

  @override
  UserStateLM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStateLM(
      status: fields[0] as int,
      errorMessage: fields[1] as String?,
      currentPlayer: fields[2] as Player?,
      players: (fields[3] as List).cast<Player>(),
      profilePictures: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserStateLM obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.errorMessage)
      ..writeByte(2)
      ..write(obj.currentPlayer)
      ..writeByte(3)
      ..write(obj.players)
      ..writeByte(4)
      ..write(obj.profilePictures);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStateLMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
