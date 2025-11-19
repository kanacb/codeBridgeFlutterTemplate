import 'package:aims/Utils/Services/IdName.dart';
import 'package:hive/hive.dart';

part 'MemParts.g.dart';

@HiveType(typeId: 53)
class MemParts {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? item;

  @HiveField(2)
  final List<String>? machineType;

  @HiveField(3)
  final IdName? createdBy;

  @HiveField(4)
  final IdName? updatedBy;

  @HiveField(5)
  final DateTime? createdAt;

  @HiveField(6)
  final DateTime? updatedAt;

  MemParts({
    this.id,
    this.item,
    this.machineType,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory MemParts.fromJson(Map<String, dynamic> json) {
    return MemParts(
      id: json['_id'] as String?,
      item: json['item'] as String?,
      machineType: (json['machineType'] as List?)?.cast<String>(),
      createdBy: json['createdBy'] != null ? IdName.fromJson(json['createdBy']) : null,
      updatedBy: json['updatedBy'] != null ? IdName.fromJson(json['updatedBy']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': item,
      'machineType': machineType,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() => '''
  MemParts: {
    "id": "$id",
    "item": "$item",
    "machineType": "$machineType",
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
