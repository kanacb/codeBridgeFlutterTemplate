import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'DeliveryOrderItems.g.dart';

@HiveType(typeId: 23) // Unique typeId for Hive storage
class DeliveryOrderItems {
  @HiveField(0)
  final String? id; // Unique identifier for the delivery order item

  @HiveField(1)
  final String deliveryOrders; // Reference to the delivery order

  @HiveField(2)
  final String part; // Reference to the part

  @HiveField(3)
  final int quantity; // Quantity of the part

  @HiveField(4)
  final String createdBy; // ID of the user who created the record

  @HiveField(5)
  final String updatedBy; // ID of the user who last updated the record

  @HiveField(6)
  final DateTime? createdAt; // Timestamp for when the record was created

  @HiveField(7)
  final DateTime? updatedAt; // Timestamp for when the record was last updated

  DeliveryOrderItems({
    this.id,
    required this.deliveryOrders,
    required this.part,
    required this.quantity,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into a DeliveryOrderItems instance
  factory DeliveryOrderItems.fromJson(Map<String, dynamic> map) {
    return DeliveryOrderItems(
      id: map['_id'] as String?,
      deliveryOrders: map['deliveryOrders'] as String,
      part: map['part'] as String,
      quantity: map['quantity'] as int,
      createdBy: map['createdBy'] as String,
      updatedBy: map['updatedBy'] as String,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Converts the DeliveryOrderItems instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'deliveryOrders': deliveryOrders,
      'part': part,
      'quantity': quantity,
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
    "deliveryOrders": "$deliveryOrders",
    "part": "$part",
    "quantity": $quantity,
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
