// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DocumentAdapter extends TypeAdapter<Document> {
  @override
  final int typeId = 0;

  @override
  Document read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Document(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      type: fields[3] as String,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime?,
      imagePaths: (fields[6] as List).cast<String>(),
      tags: (fields[7] as List).cast<String>(),
      status: fields[8] as String,
      location: fields[9] as String?,
      ownerName: fields[10] as String?,
      area: fields[11] as double?,
      aiAnalysis: fields[12] as String?,
      isFavorite: fields[13] as bool,
      pdfPath: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Document obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.imagePaths)
      ..writeByte(7)
      ..write(obj.tags)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.location)
      ..writeByte(10)
      ..write(obj.ownerName)
      ..writeByte(11)
      ..write(obj.area)
      ..writeByte(12)
      ..write(obj.aiAnalysis)
      ..writeByte(13)
      ..write(obj.isFavorite)
      ..writeByte(14)
      ..write(obj.pdfPath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
