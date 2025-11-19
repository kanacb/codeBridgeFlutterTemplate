import 'package:hive/hive.dart';

part 'WarehouseMaster.g.dart';

@HiveType(typeId: 35)
class WarehouseMaster {
  @HiveField(0)
  final String id; // Unique identifier for the warehouse

  @HiveField(1)
  final String? name; // Name of the warehouse

  @HiveField(2)
  final String? location; // Location of the warehouse

  @HiveField(3)
  final String? createdBy; // User ID who created the warehouse record

  @HiveField(4)
  final String? updatedBy; // User ID who last updated the warehouse record

  WarehouseMaster({
    required this.id, // Ensure id is required
    this.name,
    this.location,
    this.createdBy,
    this.updatedBy,
  });

  factory WarehouseMaster.fromJson(Map<String, dynamic> json) {
    return WarehouseMaster(
      id: json['_id'], // Assuming the id is in the '_id' field in the response
      name: json['name'],
      location: json['location'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Include the id in the JSON output
      'name': name,
      'location': location,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }
}
