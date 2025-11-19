import 'package:hive/hive.dart';

part 'StockOutDetails.g.dart';

@HiveType(typeId: 33)
class StockOutDetails {
  @HiveField(0)
  final String id; // Unique identifier for the stock-out details

  @HiveField(1)
  final String? partName; // Reference to the part in parts master

  @HiveField(2)
  final String? stockOutType; // Type of the stock out action

  @HiveField(3)
  final String? associatedOrderNumber; // Associated order number

  @HiveField(4)
  final String? conditionOfItems; // Condition of the stock-out items

  @HiveField(5)
  final String? createdBy; // User ID of the creator

  @HiveField(6)
  final String? updatedBy; // User ID of the last updater

  StockOutDetails({
    required this.id, // Ensure id is required
    this.partName,
    this.stockOutType,
    this.associatedOrderNumber,
    this.conditionOfItems,
    this.createdBy,
    this.updatedBy,
  });

  factory StockOutDetails.fromJson(Map<String, dynamic> json) {
    return StockOutDetails(
      id: json['_id'], // Assuming the id is in the '_id' field in the response
      partName: json['partName'],
      stockOutType: json['stockOutType'],
      associatedOrderNumber: json['associatedOrderNumber'],
      conditionOfItems: json['conditionOfItems'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Include the id in the JSON output
      'partName': partName,
      'stockOutType': stockOutType,
      'associatedOrderNumber': associatedOrderNumber,
      'conditionOfItems': conditionOfItems,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }
}
