import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'CustomerPurchaseOrders.g.dart';

@HiveType(typeId: 21) // Unique typeId for Hive storage
class CustomerPurchaseOrders {
  @HiveField(0)
  final String? id; // Unique identifier for the purchase order record

  @HiveField(1)
  final String quotation; // Related to quotations

  @HiveField(2)
  final DateTime purchaseOrderDate; // Purchase order date

  @HiveField(3)
  final DateTime deliveryDate; // Delivery date

  @HiveField(4)
  final String purchaseOrderId; // Purchase Order ID

  @HiveField(5)
  final String createdBy; // ID of the user who created the record

  @HiveField(6)
  final String updatedBy; // ID of the user who last updated the record

  @HiveField(7)
  final DateTime? createdAt; // Timestamp for when the record was created

  @HiveField(8)
  final DateTime? updatedAt; // Timestamp for when the record was last updated

  CustomerPurchaseOrders({
    this.id,
    required this.quotation,
    required this.purchaseOrderDate,
    required this.deliveryDate,
    required this.purchaseOrderId,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into a CustomerPurchaseOrder instance
  factory CustomerPurchaseOrders.fromJson(Map<String, dynamic> map) {
    return CustomerPurchaseOrders(
      id: map['_id'] as String?,
      quotation: map['quotation'] as String,
      purchaseOrderDate: DateTime.parse(map['purchaseOrderDate']),
      deliveryDate: DateTime.parse(map['deliveryDate']),
      purchaseOrderId: map['purchaseOrderId'] as String,
      createdBy: map['createdBy'] as String,
      updatedBy: map['updatedBy'] as String,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Converts the CustomerPurchaseOrder instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'quotation': quotation,
      'purchaseOrderDate': purchaseOrderDate.toIso8601String(),
      'deliveryDate': deliveryDate.toIso8601String(),
      'purchaseOrderId': purchaseOrderId,
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
    "quotation": "$quotation",
    "purchaseOrderDate": "$purchaseOrderDate",
    "deliveryDate": "$deliveryDate",
    "purchaseOrderId": "$purchaseOrderId",
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
