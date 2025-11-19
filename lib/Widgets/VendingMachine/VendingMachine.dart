import '../../Utils/Services/IdName.dart';
import 'package:hive/hive.dart';

import '../../Utils/Globals.dart';
import '../Branches/Branches.dart';

part 'VendingMachine.g.dart';

@HiveType(typeId: 39)
class VendingMachine {
  @HiveField(0)
  String? id; // _id from API

  @HiveField(1)
  String name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String? createdBy;

  @HiveField(4)
  String? updatedBy;

  @HiveField(5)
  DateTime? createdAt; // New field from API

  @HiveField(6)
  DateTime? updatedAt; // New field from API

  VendingMachine(
      {this.id,
      required this.name,
      this.description,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt});

  factory VendingMachine.fromJson(Map<String, dynamic> json) {
    try {
      return VendingMachine(
        id: json['_id'] as String?,
        name: json['name'] as String,
        description: json['description'] as String?,
        createdBy: json['createdBy'] as String?,
        updatedBy: json['updatedBy'] as String?,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'])
            : null,
      );
    } catch (e) {
      return VendingMachine(
        id: "",
        name: "no name",
        description: "vendingMachineCode",
        createdBy: "createdBy",
        updatedBy: "updatedBy",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String()
    };
  }

  @override
  String toString() => '''
  MachineMaster: {
    "_id": "$id",
    "name": "$name",
    "description": "$description",
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
