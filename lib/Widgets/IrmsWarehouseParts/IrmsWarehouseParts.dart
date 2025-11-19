import 'package:aims/Utils/Services/IdName.dart';
import 'package:hive/hive.dart';

part 'IrmsWarehouseParts.g.dart';

@HiveType(typeId: 50)
class IrmsWarehouseParts {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? part;

  @HiveField(2)
  final String? warehouse;

  @HiveField(3)
  final int? quantity;

  @HiveField(4)
  final int? costAmount;

  @HiveField(5)
  final int? reorderingQuantity;

  @HiveField(6)
  final int? reorderingPoint;

  @HiveField(7)
  final IdName? createdBy;

  @HiveField(8)
  final IdName? updatedBy;

  @HiveField(9)
  final DateTime? createdAt;

  @HiveField(10)
  final DateTime? updatedAt;

  IrmsWarehouseParts({
    this.id,
    this.part,
    this.warehouse,
    this.quantity,
    this.costAmount,
    this.reorderingQuantity,
    this.reorderingPoint,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory IrmsWarehouseParts.fromJson(Map<String, dynamic> json) {
    return IrmsWarehouseParts(
      id: json['_id'] as String?,
      part: json['part'] as String?,
      warehouse: json['warehouse'] as String?,
      quantity: json['quantity'] as int?,
      costAmount: json['costAmount'] as int?,
      reorderingQuantity: json['reorderingQuantity'] as int?,
      reorderingPoint: json['reorderingPoint'] as int?,
      createdBy: json['createdBy'] != null ? IdName.fromJson(json['createdBy']) : null,
      updatedBy: json['updatedBy'] != null ? IdName.fromJson(json['updatedBy']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'part': part,
      'warehouse': warehouse,
      'quantity': quantity,
      'costAmount': costAmount,
      'reorderingQuantity': reorderingQuantity,
      'reorderingPoint': reorderingPoint,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() => '''
  IrmsWarehouseParts: {
    "id": "$id",
    "part": "$part",
    "warehouse": "$warehouse",
    "quantity": "$quantity",
    "costAmount": "$costAmount",
    "reorderingQuantity": "$reorderingQuantity",
    "reorderingPoint": "$reorderingPoint",
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
