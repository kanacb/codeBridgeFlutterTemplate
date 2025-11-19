import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'AtlasChecks.g.dart';

@HiveType(typeId: 14) // Unique typeId for Hive storage
class AtlasChecks {
  @HiveField(0)
  final String? id; // Check ID (optional, for backend records)

  @HiveField(1)
  final String? checkListId; // ID of the related checklist

  @HiveField(2)
  final String name; // Name of the check

  @HiveField(3)
  final String? description; // Description of the check

  @HiveField(4)
  final String createdBy; // ID of the user who created this check

  @HiveField(5)
  final String updatedBy; // ID of the user who last updated this check

  @HiveField(6)
  final DateTime? createdAt; // Timestamp for when this check was created

  @HiveField(7)
  final DateTime? updatedAt; // Timestamp for when this check was last updated

  AtlasChecks({
    this.id,
    this.checkListId,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into an ExternalCheck instance
  factory AtlasChecks.fromJson(Map<String, dynamic> map) {
    return AtlasChecks(
      id: map['_id'] as String?,
      checkListId: map['atlasCheckListId'] as String?,
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

  // Converts the AtlasCheck instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'atlasCheckListId': checkListId,
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
  AtlasCheck: {
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
