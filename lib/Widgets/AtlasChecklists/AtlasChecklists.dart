import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'AtlasChecklists.g.dart';

@HiveType(typeId: 13) // Unique typeId for Hive storage
class AtlasChecklists {
  @HiveField(0)
  final String? id; // Checklist ID (optional, for backend records)

  @HiveField(1)
  final String? vendingMachineId; // ID of the vending machine

  @HiveField(2)
  final String name; // Name of the checklist

  @HiveField(3)
  final String? description; // Description of the checklist

  @HiveField(4)
  final String createdBy; // ID of the user who created this checklist

  @HiveField(5)
  final String updatedBy; // ID of the user who last updated this checklist

  @HiveField(6)
  final DateTime? createdAt; // Timestamp for when this checklist was created

  @HiveField(7)
  final DateTime? updatedAt; // Timestamp for when this checklist was last updated

  AtlasChecklists({
    this.id,
    this.vendingMachineId,
    required this.name,
     this.description,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into an Atlashecklist instance
  factory AtlasChecklists.fromJson(Map<String, dynamic> map) {
    return AtlasChecklists(
      id: map['_id'] as String?,
      vendingMachineId: map['vendingMachineId'] as String?,
      name: map['name'] as String,
      description: map['description'] != null ? map['description'] as String : "",
      createdBy: map['createdBy'] as String,
      updatedBy: map['updatedBy'] as String,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
    );
  }

  // Converts the Atlas Checklist instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'vendingMachineId': vendingMachineId,
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() => '''
  AtlasChecklists: {
    "id": "$id",
    "vendingMachineId": "$vendingMachineId",
    "name": "$name",
    "description": "$description",
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
