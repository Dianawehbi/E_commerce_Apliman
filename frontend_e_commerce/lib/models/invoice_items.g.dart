// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_items.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceItemsAdapter extends TypeAdapter<InvoiceItems> {
  @override
  final int typeId = 0;

  @override
  InvoiceItems read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceItems(
      id: fields[0] as int?,
      invoiceId: fields[1] as int?,
      itemId: fields[2] as int,
      quantity: fields[3] as int,
      unitPrice: fields[4] as double,
      item: fields[5] as Item?,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceItems obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.invoiceId)
      ..writeByte(2)
      ..write(obj.itemId)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.unitPrice)
      ..writeByte(5)
      ..write(obj.item);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceItemsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceItems _$InvoiceItemsFromJson(Map<String, dynamic> json) => InvoiceItems(
      id: (json['id'] as num?)?.toInt(),
      invoiceId: (json['invoiceId'] as num?)?.toInt(),
      itemId: (json['itemId'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$InvoiceItemsToJson(InvoiceItems instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
    };
