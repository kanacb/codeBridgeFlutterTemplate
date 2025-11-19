import 'package:aims/Utils/Services/IdName.dart';
import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'IncomingMachineChecklists.g.dart';

@HiveType(typeId: 15) // Unique typeId for Hive storage
class IncomingMachineChecklists {
  @HiveField(0)
  final String? id; // Optional unique ID for Hive

  @HiveField(1)
  final String name; // Name of the checklist

  @HiveField(2)
  final String optionsType; // Type of the checklist

  @HiveField(3)
  final IdName? createdBy; // ID and name of the user who created the checklist

  @HiveField(4)
  final IdName? updatedBy; // ID and name of the user who last updated the checklist

  @HiveField(5)
  final DateTime? createdAt; // Timestamp when the checklist was created

  @HiveField(6)
  final DateTime? updatedAt; // Timestamp when the checklist was last updated

  @HiveField(7)
  final String? description;

  IncomingMachineChecklists({
    this.id,
    required this.name,
    required this.optionsType,
    this.description,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method for creating an instance from a JSON object
  factory IncomingMachineChecklists.fromJson(Map<String, dynamic> map) {
    return IncomingMachineChecklists(
      id: map['_id'] as String?,
      name: map['name'] as String,
      optionsType: map['optionsType'] as String,
      description: map['description'] as String?,
      createdBy: map['createdBy'] != null ? IdName.fromJson(map['createdBy']) : null,
      updatedBy: map['updatedBy'] != null ? IdName.fromJson(map['updatedBy']) : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Converts the instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'optionsType': optionsType,
      'description': description,
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
    "name": "$name",
    "optionsType": "$optionsType",
    "description": "$description",
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
