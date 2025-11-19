import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'DisposalDetails.g.dart';

@HiveType(typeId: 24) // Unique typeId for Hive storage
class DisposalDetails {
  @HiveField(0)
  final String? id; // Unique identifier for the disposal detail

  @HiveField(1)
  final String sourceWarehouse; // Reference to the source warehouse

  @HiveField(2)
  final String partNumber; // Reference to the part number

  @HiveField(3)
  final int quantity; // Quantity of the part to be disposed of

  @HiveField(4)
  final String associatedNumber; // Associated number

  @HiveField(5)
  final DateTime? affectiveDate; // Affective date for the disposal

  @HiveField(6)
  final String createdBy; // ID of the user who created the record

  @HiveField(7)
  final String updatedBy; // ID of the user who last updated the record

  @HiveField(8)
  final DateTime? createdAt; // Timestamp for when the record was created

  @HiveField(9)
  final DateTime? updatedAt; // Timestamp for when the record was last updated

  DisposalDetails({
    this.id,
    required this.sourceWarehouse,
    required this.partNumber,
    required this.quantity,
    required this.associatedNumber,
    this.affectiveDate,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into a DisposalDetails instance
  factory DisposalDetails.fromJson(Map<String, dynamic> map) {
    return DisposalDetails(
      id: map['_id'] as String?,
      sourceWarehouse: map['sourceWarehouse'] as String,
      partNumber: map['partNumber'] as String,
      quantity: map['quantity'] as int,
      associatedNumber: map['associatedNumber'] as String,
      affectiveDate: map['affectiveDate'] != null ? DateTime.parse(map['affectiveDate']) : null,
      createdBy: map['createdBy'] as String,
      updatedBy: map['updatedBy'] as String,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Converts the DisposalDetails instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'sourceWarehouse': sourceWarehouse,
      'partNumber': partNumber,
      'quantity': quantity,
      'associatedNumber': associatedNumber,
      'affectiveDate': affectiveDate?.toIso8601String(),
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
    "sourceWarehouse": "$sourceWarehouse",
    "partNumber": "$partNumber",
    "quantity": $quantity,
    "associatedNumber": "$associatedNumber",
    "affectiveDate": "$affectiveDate",
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
