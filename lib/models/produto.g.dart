// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProdutoAdapter extends TypeAdapter<Produto> {
  @override
  final int typeId = 0;

  @override
  Produto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Produto(
      nome: fields[0] as String,
      categoria: fields[1] as String,
      precoCusto: fields[2] as double,
      precoVenda: fields[3] as double,
      quantidade: fields[4] as int,
      estoqueMinimo: fields[5] as int,
      dataAdicao: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Produto obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.categoria)
      ..writeByte(2)
      ..write(obj.precoCusto)
      ..writeByte(3)
      ..write(obj.precoVenda)
      ..writeByte(4)
      ..write(obj.quantidade)
      ..writeByte(5)
      ..write(obj.estoqueMinimo)
      ..writeByte(6)
      ..write(obj.dataAdicao);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProdutoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
