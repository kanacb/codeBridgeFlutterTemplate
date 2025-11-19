import '../../Utils/Services/IdName.dart';
import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'ExternalChecklists.g.dart';

@HiveType(typeId: 10) // Unique typeId for Hive storage
class ExternalChecklists {
  @HiveField(0)
  final String? id; // Checklist ID (optional, for backend records)

  @HiveField(1)
  final IdName? vendingMachineId; // ID of the vending machine

  @HiveField(2)
  final String? name; // Name of the checklist

  @HiveField(3)
  final String? description; // Description of the checklist

  @HiveField(4)
  final IdName? createdBy; // ID of the user who created this checklist

  @HiveField(5)
  final IdName? updatedBy; // ID of the user who last updated this checklist

  @HiveField(6)
  final DateTime? createdAt; // Timestamp for when this checklist was created

  @HiveField(7)
  final DateTime? updatedAt; // Timestamp for when this checklist was last updated

  ExternalChecklists({
    this.id,
    this.vendingMachineId,
    this.name,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to parse JSON data into an ExternalChecklist instance
  factory ExternalChecklists.fromJson(Map<String, dynamic> map) {
    // print(map);
    return ExternalChecklists(
      id: map['_id'] as String?,
      vendingMachineId: map['vendingMachineId'] != null ? IdName.fromJson(map['vendingMachineId']) : null,
      name: map['name'] as String?,
      description: map['description'] as String?,
      createdBy: map['createdBy'] != null ? IdName.fromJson(map['createdBy']) : null,
      updatedBy: map['updatedBy'] != null ? IdName.fromJson(map['updatedBy']) : null,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Converts the ExternalChecklist instance to a JSON map
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
  ExternalChecklists: {
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
