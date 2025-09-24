// flutter packages pub run build_runner build
import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
part 'item.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class Item {
  @JsonKey(includeToJson: false)
  final int? id;

  @HiveField(0)
  final String itemName;

  @HiveField(1)
  final String description;

  @JsonKey(name: 'image_path')
  @HiveField(2)
  final String? imagePath;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final int stockQuantity;

  @JsonKey(includeToJson: false)
  final int? categoryId;

  Item({
    this.id,
    required this.itemName,
    required this.description,
    this.imagePath,
    required this.price,
    required this.stockQuantity,
    this.categoryId,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
