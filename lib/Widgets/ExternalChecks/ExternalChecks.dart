import 'package:aims/Utils/Services/IdName.dart';
import 'package:hive/hive.dart';

// dart run build_runner build --delete-conflicting-outputs
part 'ExternalChecks.g.dart';

@HiveType(typeId: 11) // Unique typeId for Hive storage
class ExternalChecks {
  @HiveField(0)
  final String? id; // Check ID (optional, for backend records)

  @HiveField(1)
  final String? checkListId; // ID of the related checklist

  @HiveField(2)
  final String? name; // Name of the check

  @HiveField(3)
  final String? description; // Description of the check

  @HiveField(4)
  final IdName? createdBy; // ID of the user who created this check

  @HiveField(5)
  final IdName? updatedBy; // ID of the user who last updated this check

  @HiveField(6)
  final DateTime? createdAt; // Timestamp for when this check was created

  @HiveField(7)
  final DateTime? updatedAt; // Timestamp for when this check was last updated

  ExternalChecks({
    this.id,
    this.checkListId,
    this.name,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into an ExternalChecks instance
  factory ExternalChecks.fromJson(Map<String, dynamic> map) {
    return ExternalChecks(
      id: map['_id'] as String?,
      checkListId: map['checkListId'] as String?,
      name: map['name'] as String?,
      description: map['description'] as String?,
      createdBy: map['createdBy'] != null ? IdName.fromJson(map['createdBy']) : null,
      updatedBy: map['updatedBy'] != null ? IdName.fromJson(map['updatedBy']) : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Converts the ExternalChecks instance to a JSON map
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
    "updatedAt": "$updatedAt",
  }''';
}
