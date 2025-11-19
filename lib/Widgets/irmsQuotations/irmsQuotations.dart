import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'irmsQuotations.g.dart';

@HiveType(typeId: 26) // Unique typeId for Hive storage
class irmsQuotations {
  @HiveField(0)
  final String? id; // Unique identifier for the quotation

  @HiveField(1)
  final String salesOrder; // Reference to the customer sales order

  @HiveField(2)
  final DateTime? validDate; // Valid date of the quotation

  @HiveField(3)
  final String quotationIndex; // Quotation Index

  @HiveField(4)
  final String createdBy; // ID of the user who created the record

  @HiveField(5)
  final String updatedBy; // ID of the user who last updated the record

  @HiveField(6)
  final DateTime? createdAt; // Timestamp for when the record was created

  @HiveField(7)
  final DateTime? updatedAt; // Timestamp for when the record was last updated

  irmsQuotations({
    this.id,
    required this.salesOrder,
    this.validDate,
    required this.quotationIndex,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into an irmsQuotations instance
  factory irmsQuotations.fromJson(Map<String, dynamic> map) {
    return irmsQuotations(
      id: map['_id'] as String?,
      salesOrder: map['salesOrder'] as String,
      validDate: map['validDate'] != null ? DateTime.parse(map['validDate']) : null,
      quotationIndex: map['quotationIndex'] as String,
      createdBy: map['createdBy'] as String,
      updatedBy: map['updatedBy'] as String,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Converts the irmsQuotations instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'salesOrder': salesOrder,
      'validDate': validDate?.toIso8601String(),
      'quotationIndex': quotationIndex,
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
    "salesOrder": "$salesOrder",
    "validDate": "$validDate",
    "quotationIndex": "$quotationIndex",
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
