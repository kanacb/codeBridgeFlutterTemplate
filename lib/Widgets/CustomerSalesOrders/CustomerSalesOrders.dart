import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'CustomerSalesOrders.g.dart';

@HiveType(typeId: 22) // Unique typeId for Hive storage
class CustomerSalesOrders {
  @HiveField(0)
  final String? id; // Unique identifier for the sales order record

  @HiveField(1)
  final String company; // Reference to the company

  @HiveField(2)
  final String salesOrderId; // Sales Order ID

  @HiveField(3)
  final DateTime salesOrderDate; // Sales order date

  @HiveField(4)
  final String createdBy; // ID of the user who created the record

  @HiveField(5)
  final String updatedBy; // ID of the user who last updated the record

  @HiveField(6)
  final DateTime? createdAt; // Timestamp for when the record was created

  @HiveField(7)
  final DateTime? updatedAt; // Timestamp for when the record was last updated

  CustomerSalesOrders({
    this.id,
    required this.company,
    required this.salesOrderId,
    required this.salesOrderDate,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into a CustomerSalesOrders instance
  factory CustomerSalesOrders.fromJson(Map<String, dynamic> map) {
    return CustomerSalesOrders(
      id: map['_id'] as String?,
      company: map['company'] as String,
      salesOrderId: map['salesOrderId'] as String,
      salesOrderDate: DateTime.parse(map['salesOrderDate']),
      createdBy: map['createdBy'] as String,
      updatedBy: map['updatedBy'] as String,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Converts the CustomerSalesOrders instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'company': company,
      'salesOrderId': salesOrderId,
      'salesOrderDate': salesOrderDate.toIso8601String(),
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
    "company": "$company",
    "salesOrderId": "$salesOrderId",
    "salesOrderDate": "$salesOrderDate",
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
