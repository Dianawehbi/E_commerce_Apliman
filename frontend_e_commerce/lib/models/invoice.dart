import 'package:frontend_e_commerce/models/invoice_items.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invoice.g.dart';

@JsonSerializable()
class Invoice {
  @JsonKey(includeToJson: false)
  final int id;
  final int customerId; // only Id
  @JsonKey(includeToJson: false)
  final double? totalAmount;
  @JsonKey(includeToJson: false)
  final DateTime? invoiceDate;

  @JsonKey(name: "invoiceitems")
  final List<InvoiceItems> invoiceItems;

  Invoice({
    required this.id,
    required this.customerId,
    this.totalAmount,
    required this.invoiceItems,
    this.invoiceDate,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceToJson(this);
}
