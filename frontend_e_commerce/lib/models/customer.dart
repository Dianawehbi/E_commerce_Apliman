import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  @JsonKey(includeToJson: false) 
  final int id;
  
  final String username;
  final String email;
  final String address;
  final String phone;

  @JsonKey(includeToJson: false)
  final List<int>? invoiceIds;
  // here we have list of invoices

  Customer({
    required this.id,
    required this.username,
    required this.email,
    required this.address,
    required this.phone,
    this.invoiceIds,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
