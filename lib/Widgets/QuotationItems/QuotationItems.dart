import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'QuotationItems.g.dart';

@HiveType(typeId: 29) // Unique typeId for Hive storage
class QuotationItems {
  @HiveField(0)
  final String? id; // Unique identifier for the quotation item

  @HiveField(1)
  final String quotation; // Reference to the IRMS quotation

  @HiveField(2)
  final String part; // Reference to the part from parts master

  @HiveField(3)
  final int quantity; // Quantity of the part quoted

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

  QuotationItems({
    this.id,
    required this.quotation,
    required this.part,
    required this.quantity,
    required this.unitPrice,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into a QuotationItems instance
  factory QuotationItems.fromJson(Map<String, dynamic> map) {
    return QuotationItems(
      id: map['_id'] as String?,
      quotation: map['quotation'] as String,
      part: map['part'] as String,
      quantity: map['quantity'] as int,
      unitPrice: (map['UnitPrice'] as num).toDouble(),
      createdBy: map['createdBy'] as String,
      updatedBy: map['updatedBy'] as String,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Converts the QuotationItems instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'quotation': quotation,
      'part': part,
      'quantity': quantity,
      'UnitPrice': unitPrice,
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
    "part": "$part",
    "quantity": $quantity,
    "unitPrice": $unitPrice,
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
