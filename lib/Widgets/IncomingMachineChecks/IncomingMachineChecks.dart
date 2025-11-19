import 'package:aims/Utils/Services/IdName.dart';
import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'IncomingMachineChecks.g.dart';

@HiveType(typeId: 16) // Unique typeId for Hive storage
class IncomingMachineChecks {
  @HiveField(0)
  final String? id; // Optional unique ID for Hive

  @HiveField(1)
  final String checkListId; // Reference to incoming_machine_checklists

  @HiveField(2)
  final String name; // Name of the check

  @HiveField(3)
  final String? description; // Description of the check

  @HiveField(4)
  final IdName? createdBy; // ID of the user who created the record

  @HiveField(5)
  final IdName? updatedBy; // ID of the user who last updated the record

  @HiveField(6)
  final DateTime? createdAt; // Timestamp when the record was created

  @HiveField(7)
  final DateTime? updatedAt; // Timestamp when the record was last updated

  IncomingMachineChecks({
    this.id,
    required this.checkListId,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method for creating an instance from a JSON object
  factory IncomingMachineChecks.fromJson(Map<String, dynamic> map) {
    return IncomingMachineChecks(
      id: map['_id'] as String?,
      checkListId: map['checkListId'] as String,
      name: map['name'] as String,
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
      'checkListId': checkListId,
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
  {
    "id": "$id",
    "checkListId": "$checkListId",
    "name": "$name",
    "description": "$description",
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
