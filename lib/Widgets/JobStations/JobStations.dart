import 'package:hive/hive.dart';

import '../../Utils/Services/IdName.dart';

part 'JobStations.g.dart';

@HiveType(typeId: 17) // Unique typeId for Hive storage
class JobStations {
  @HiveField(0)
  final String? id; // Unique identifier for the job station

  @HiveField(1)
  final String name; // Name of the job station

  @HiveField(2)
  final String description; // Description of the job station

  @HiveField(3)
  final IdName? createdBy; // ID of the user who created the job station

  @HiveField(4)
  final IdName? updatedBy; // ID of the user who last updated the job station

  @HiveField(5)
  final DateTime? createdAt; // Timestamp for when the record was created

  @HiveField(6)
  final DateTime? updatedAt; // Timestamp for when the record was last updated

  JobStations({
    this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into a JobStation instance
  factory JobStations.fromJson(Map<String, dynamic> map) {
    return JobStations(
      id: map['_id'] as String?,
      name: map['name'] as String,
      description: map['description'] as String,
      createdBy: map['createdBy'] == null ? null : IdName.fromJson(map['createdBy']),
      updatedBy: map['updatedBy'] == null ? null : IdName.fromJson(map['updatedBy']),
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Converts the JobStation instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Override the toString method for better debug logging
  @override
  String toString() {
    return '''
    JobStations {
      id: $id,
      name: $name,
      description: $description,
      createdBy: $createdBy,
      updatedBy: $updatedBy,
      createdAt: $createdAt,
      updatedAt: $updatedAt,
    }
    ''';
  }
}
