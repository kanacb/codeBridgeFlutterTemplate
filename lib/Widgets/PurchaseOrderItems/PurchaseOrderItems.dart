import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'PurchaseOrderItems.g.dart';

@HiveType(typeId: 28) // Unique typeId for Hive storage
class PurchaseOrderItems {
  @HiveField(0)
  final String? id; // Unique identifier for the purchase order item

  @HiveField(1)
  final String purchaseOrder; // Reference to the customer purchase order

  @HiveField(2)
  final String part; // Reference to the part from parts master

  @HiveField(3)
  final int quantity; // Quantity of the part ordered

  @HiveField(4)
  final double unitPrice; // Unit price of the part

  @HiveField(5)
  final String createdBy; // ID of the user who created the record

  @HiveField(6)
  final String updatedBy; // ID of the user who last updated the record

  @HiveField(7)
  final DateTime? createdAt; // Timestamp for when the record was created

  @HiveField(8)
  final DateTime? updatedAt; // Timestamp for when the record was last updated

  PurchaseOrderItems({
    this.id,
    required this.purchaseOrder,
    required this.part,
    required this.quantity,
    required this.unitPrice,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into a PurchaseOrderItems instance
  factory PurchaseOrderItems.fromJson(Map<String, dynamic> map) {
    return PurchaseOrderItems(
      id: map['_id'] as String?,
      purchaseOrder: map['purchaseOrder'] as String,
      part: map['part'] as String,
      quantity: map['quantity'] as int,
      unitPrice: (map['unitPrice'] as num).toDouble(),
      createdBy: map['createdBy'] as String,
      updatedBy: map['updatedBy'] as String,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Converts the PurchaseOrderItems instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'purchaseOrder': purchaseOrder,
      'part': part,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() => '''
  {
    "id": "$id",
    "purchaseOrder": "$purchaseOrder",
    "part": "$part",
    "quantity": $quantity,
    "unitPrice": $unitPrice,
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
