import 'package:aims/Utils/Services/IdName.dart';
import 'package:hive/hive.dart';

part 'IrmsParts.g.dart';

@HiveType(typeId: 48)
class IrmsParts {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? serialNo;

  @HiveField(2)
  final String? itemNo;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final IdName? createdBy;

  @HiveField(5)
  final IdName? updatedBy;

  @HiveField(6)
  final DateTime? createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  IrmsParts({
    this.id,
    this.serialNo,
    this.itemNo,
    this.description,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory IrmsParts.fromJson(Map<String, dynamic> json) {
    return IrmsParts(
      id: json['_id'] as String?,
      serialNo: json['serialNo'] as String?,
      itemNo: json['itemNo'] as String?,
      description: json['description'] as String?,
      createdBy: json['createdBy'] != null ? IdName.fromJson(json['createdBy']) : null,
      updatedBy: json['updatedBy'] != null ? IdName.fromJson(json['updatedBy']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serialNo': serialNo,
      'itemNo': itemNo,
      'description': description,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String get displayLabel {
    return '${serialNo ?? ''} - ${itemNo ?? ''} - ${description ?? ''}';
  }

  @override
  String toString() => '''
  IrmsParts: {
    "id": "$id",
    "serialNo": "$serialNo",
    "itemNo": "$itemNo",
    "description": "$description",
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
