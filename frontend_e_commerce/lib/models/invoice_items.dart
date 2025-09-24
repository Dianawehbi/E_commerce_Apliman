import 'package:frontend_e_commerce/models/item.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';

part 'invoice_items.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class InvoiceItems extends HiveObject {
  @HiveField(0)
  @JsonKey(includeToJson: false)
  final int? id;

  @HiveField(1)
  @JsonKey(includeToJson: false)
  final int? invoiceId; // only id

  @HiveField(2)
  final int itemId; // only id

  @HiveField(3)
  final int quantity;

  @HiveField(4)
  final double unitPrice;

  @HiveField(5)
  @JsonKey(includeToJson: false) 
  final Item? item; // full product for UI only

  InvoiceItems({
    this.id,
    this.invoiceId,
    required this.itemId,
    required this.quantity,
    required this.unitPrice,
    this.item
  });

  factory InvoiceItems.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemsFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceItemsToJson(this);
}
