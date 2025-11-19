import 'package:hive/hive.dart';

part 'StockInDetails.g.dart';

@HiveType(typeId: 32)
class StockInDetails {
  @HiveField(0)
  final String id; // Unique identifier for the stock-in details

  @HiveField(1)
  final String? model; // Model of the part

  @HiveField(2)
  final String? serialNo; // Serial Number of the part

  @HiveField(3)
  final String? partNo; // Part Number

  @HiveField(4)
  final double? pricing; // Pricing for the part

  @HiveField(5)
  final int? quantity; // Quantity of the part

  @HiveField(6)
  final DateTime? purchaseDate; // Purchase Date of the part

  @HiveField(7)
  final String? partDescription; // Description of the part

  @HiveField(8)
  final String? poNumber; // PO Number for the part

  @HiveField(9)
  final String? doNumber; // DO Number for the part

  @HiveField(10)
  final String? category; // Category of the part

  @HiveField(11)
  final String? unitOfMeasurement; // Unit of measurement

  @HiveField(12)
  final String? conditionOfTerms; // Condition of the terms

  @HiveField(13)
  final String? warehouse; // Warehouse ID

  @HiveField(14)
  final String? createdBy; // User ID of the creator

  @HiveField(15)
  final String? updatedBy; // User ID of the last updater

  StockInDetails({
    required this.id, // Ensure id is required
    this.model,
    this.serialNo,
    this.partNo,
    this.pricing,
    this.quantity,
    this.purchaseDate,
    this.partDescription,
    this.poNumber,
    this.doNumber,
    this.category,
    this.unitOfMeasurement,
    this.conditionOfTerms,
    this.warehouse,
    this.createdBy,
    this.updatedBy,
  });

  factory StockInDetails.fromJson(Map<String, dynamic> json) {
    return StockInDetails(
      id: json['_id'], // Assuming the id is in the '_id' field in the response
      model: json['model'],
      serialNo: json['serialNo'],
      partNo: json['partNo'],
      pricing: json['pricing']?.toDouble(),
      quantity: json['quantity'],
      purchaseDate: json['purchaseDate'] != null ? DateTime.parse(json['purchaseDate']) : null,
      partDescription: json['partDescription'],
      poNumber: json['poNumber'],
      doNumber: json['doNumber'],
      category: json['category'],
      unitOfMeasurement: json['unitOfMeasurement'],
      conditionOfTerms: json['conditionOfTerms'],
      warehouse: json['warehouse'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Include the id in the JSON output
      'model': model,
      'serialNo': serialNo,
      'partNo': partNo,
      'pricing': pricing,
      'quantity': quantity,
      'purchaseDate': purchaseDate?.toIso8601String(),
      'partDescription': partDescription,
      'poNumber': poNumber,
      'doNumber': doNumber,
      'category': category,
      'unitOfMeasurement': unitOfMeasurement,
      'conditionOfTerms': conditionOfTerms,
      'warehouse': warehouse,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }
}
