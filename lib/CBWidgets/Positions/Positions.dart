import 'package:aims/Utils/Services/IdName.dart';
import 'package:hive/hive.dart';

part 'Positions.g.dart';

@HiveType(typeId: 56)
class Positions {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final IdName? roleId;

  @HiveField(2)
  final String? name;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final String? abbr;

  @HiveField(5)
  final bool? isDefault;

  @HiveField(6)
  final IdName? createdBy;

  @HiveField(7)
  final IdName? updatedBy;

  @HiveField(8)
  final DateTime? createdAt;

  @HiveField(9)
  final DateTime? updatedAt;

  Positions({
    this.id,
    this.roleId,
    this.name,
    this.description,
    this.abbr,
    this.isDefault,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory Positions.fromJson(Map<String, dynamic> json) {
    return Positions(
      id: json['_id'] as String?,
      roleId: json['roleId'] != null ? IdName.fromJson(json['roleId']) : null,
      name: json['item'] as String?,
      description: json['item'] as String?,
      abbr: json['item'] as String?,
      isDefault: json['item'] as bool?,
      createdBy: json['createdBy'] != null ? IdName.fromJson(json['createdBy']) : null,
      updatedBy: json['updatedBy'] != null ? IdName.fromJson(json['updatedBy']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roleId': roleId,
      'name': name,
      'description': description,
      'abbr': abbr,
      'isDefault': isDefault,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() => '''
  Positions: {
    "id": "$id",
    "roleId": "$roleId",
    "name": "$name",
    "description": "$description",
    "abbr": "$abbr",
    "isDefault": "$isDefault",
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
