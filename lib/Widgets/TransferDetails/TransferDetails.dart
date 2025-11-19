import 'package:hive/hive.dart';

part 'TransferDetails.g.dart';

@HiveType(typeId: 34)
class TransferDetails {
  @HiveField(0)
  final String id; // Unique identifier for the transfer details

  @HiveField(1)
  final String? sourceWarehouse; // Source warehouse ID

  @HiveField(2)
  final String? destinationWarehouse; // Destination warehouse ID

  @HiveField(3)
  final String? partNumber; // Reference to the part number

  @HiveField(4)
  final int? quantity; // Quantity being transferred

  @HiveField(5)
  final DateTime? transferDate; // Transfer date

  @HiveField(6)
  final String? transferStatus; // Status of the transfer

  @HiveField(7)
  final String? createdBy; // User ID of the creator

  @HiveField(8)
  final String? updatedBy; // User ID of the last updater

  TransferDetails({
    required this.id, // Ensure id is required
    this.sourceWarehouse,
    this.destinationWarehouse,
    this.partNumber,
    this.quantity,
    this.transferDate,
    this.transferStatus,
    this.createdBy,
    this.updatedBy,
  });

  factory TransferDetails.fromJson(Map<String, dynamic> json) {
    return TransferDetails(
      id: json['_id'], // Assuming the id is in the '_id' field in the response
      sourceWarehouse: json['sourceWarehouse'],
      destinationWarehouse: json['destinationWarehouse'],
      partNumber: json['partNumber'],
      quantity: json['quantity'],
      transferDate: json['transferDate'] != null ? DateTime.parse(json['transferDate']) : null,
      transferStatus: json['transferStatus'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Include the id in the JSON output
      'sourceWarehouse': sourceWarehouse,
      'destinationWarehouse': destinationWarehouse,
      'partNumber': partNumber,
      'quantity': quantity,
      'transferDate': transferDate?.toIso8601String(),
      'transferStatus': transferStatus,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }
}
