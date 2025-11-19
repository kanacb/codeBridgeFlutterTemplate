import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'irmsDeliveryOrders.g.dart';

@HiveType(typeId: 25) // Unique typeId for Hive storage
class irmsDeliveryOrders {
  @HiveField(0)
  final String? id; // Unique identifier for the delivery order

  @HiveField(1)
  final String purchaseOrder; // Reference to the customer purchase order

  @HiveField(2)
  final String deliveryOrderId; // Delivery Order ID

  @HiveField(3)
  final String createdBy; // ID of the user who created the record

  @HiveField(4)
  final String updatedBy; // ID of the user who last updated the record

  @HiveField(5)
  final DateTime? createdAt; // Timestamp for when the record was created

  @HiveField(6)
  final DateTime? updatedAt; // Timestamp for when the record was last updated

  irmsDeliveryOrders({
    this.id,
    required this.purchaseOrder,
    required this.deliveryOrderId,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into an IrmsDeliveryOrders instance
  factory irmsDeliveryOrders.fromJson(Map<String, dynamic> map) {
    return irmsDeliveryOrders(
      id: map['_id'] as String?,
      purchaseOrder: map['purchaseOrder'] as String,
      deliveryOrderId: map['deliveryOrderId'] as String,
      createdBy: map['createdBy'] as String,
      updatedBy: map['updatedBy'] as String,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Converts the IrmsDeliveryOrders instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'purchaseOrder': purchaseOrder,
      'deliveryOrderId': deliveryOrderId,
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
    "deliveryOrderId": "$deliveryOrderId",
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
