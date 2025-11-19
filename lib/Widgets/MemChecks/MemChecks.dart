import 'package:aims/Utils/Services/IdName.dart';
import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'MemChecks.g.dart';

@HiveType(typeId: 55) // Unique typeId for Hive storage
class MemChecks {
  @HiveField(0)
  final String? id; // Check ID (optional, for backend records)

  @HiveField(1)
  final String? memCheckListId; // ID of the related checklist

  @HiveField(2)
  final String name; // Name of the check

  @HiveField(3)
  final String? description; // Description of the check

  @HiveField(4)
  final IdName? createdBy; // ID and name of the user who created the check

  @HiveField(5)
  final IdName? updatedBy; // ID and name of the user who last updated the check

  @HiveField(6)
  final DateTime? createdAt; // Timestamp when the check was created

  @HiveField(7)
  final DateTime? updatedAt; // Timestamp when the check was last updated

  MemChecks({
    this.id,
    this.memCheckListId,
    required this.name,
    this.description,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory method for creating an instance from a JSON object
  factory MemChecks.fromJson(Map<String, dynamic> map) {
    return MemChecks(
      id: map['_id'] as String?,
      memCheckListId: map['memCheckListId'] as String?,
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
      'name': name,
      'memCheckListId': memCheckListId,
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
    "memCheckListId": "$memCheckListId",
    "description": "$description",
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
