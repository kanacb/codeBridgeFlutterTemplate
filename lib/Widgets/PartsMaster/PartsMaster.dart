import 'package:hive/hive.dart';

part 'PartsMaster.g.dart';

@HiveType(typeId: 20)
class PartsMaster {
  @HiveField(0)
  String? itemNo;

  @HiveField(1)
  String? description;

  @HiveField(2)
  int? quantity;

  @HiveField(3)
  double? costAmount;

  @HiveField(4)
  String? createdBy;

  @HiveField(5)
  String? updatedBy;

  @HiveField(6)
  DateTime? createdAt;

  @HiveField(7)
  DateTime? updatedAt;

  PartsMaster({
    required this.itemNo,
    required this.description,
    required this.quantity,
    required this.costAmount,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory PartsMaster.fromJson(Map<String, dynamic> json) {
    return PartsMaster(
      itemNo: json['itemNo'] as String,
      description: json['description'] as String,
      quantity: json['quantity'] as int,
      costAmount: (json['costAmount'] as num).toDouble(),
      createdBy: json['createdBy'] as String,
      updatedBy: json['updatedBy'] as String,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemNo': itemNo,
      'description': description,
      'quantity': quantity,
      'costAmount': costAmount,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() => '''
  PartsMaster: {
    "itemNo": "$itemNo",
    "description": "$description",
    "quantity": $quantity,
    "costAmount": $costAmount,
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
