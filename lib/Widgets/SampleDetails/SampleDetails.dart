import 'package:hive/hive.dart';

part 'SampleDetails.g.dart';

@HiveType(typeId: 31)
class SampleDetails {
  @HiveField(0)
  final String id; // Unique identifier for the sample details

  @HiveField(1)
  final String? sourceWarehouse; // Source warehouse ID

  @HiveField(2)
  final String? partNumber; // Part Number ID

  @HiveField(3)
  final int? quantity; // Quantity of the part

  @HiveField(4)
  final String? associatedNumber; // Associated number

  @HiveField(5)
  final DateTime? affectiveDate; // Affective date for the sample

  @HiveField(6)
  final String? createdBy; // User ID who created the record

  @HiveField(7)
  final String? updatedBy; // User ID who last updated the record

  SampleDetails({
    required this.id,
    this.sourceWarehouse,
    this.partNumber,
    this.quantity,
    this.associatedNumber,
    this.affectiveDate,
    this.createdBy,
    this.updatedBy,
  });

  factory SampleDetails.fromJson(Map<String, dynamic> json) {
    return SampleDetails(
      id: json['_id'], // Assuming the id is in the '_id' field in the response
      sourceWarehouse: json['sourceWarehouse'],
      partNumber: json['partNumber'],
      quantity: json['quantity'],
      associatedNumber: json['associatedNumber'],
      affectiveDate: json['affectiveDate'] != null ? DateTime.parse(json['affectiveDate']) : null,
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Include the id in the JSON output
      'sourceWarehouse': sourceWarehouse,
      'partNumber': partNumber,
      'quantity': quantity,
      'associatedNumber': associatedNumber,
      'affectiveDate': affectiveDate?.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }
}
