import '../../Utils/Services/IdName.dart';
import 'package:hive/hive.dart';

import '../Branches/Branches.dart';

part 'ExternalMachines.g.dart';

@HiveType(typeId: 45)
class ExternalMachines {
  @HiveField(0)
  String? id; // _id from API

  @HiveField(1)
  Branches ownership;

  @HiveField(2)
  String? vendingMachineCode;

  @HiveField(3)
  String? modelNo;

  @HiveField(4)
  String? serialNumber; // Convert serialNumber to String

  @HiveField(5)
  IdName? vendingMachineType;

  @HiveField(6)
  DateTime? commissionDate;

  @HiveField(7)
  String? createdBy;

  @HiveField(8)
  String? updatedBy;

  @HiveField(9)
  DateTime? createdAt;

  @HiveField(10)
  DateTime? updatedAt;

  ExternalMachines(
      {this.id,
      required this.ownership,
      this.vendingMachineCode,
      this.modelNo,
      this.serialNumber,
      this.vendingMachineType,
      this.commissionDate,
      this.createdBy,
      this.updatedBy,
      this.createdAt,
      this.updatedAt});

  factory ExternalMachines.fromJson(Map<String, dynamic> json) {
    try {
      return ExternalMachines(
        id: json['_id'] as String?,
        ownership: Branches.fromJson(json['ownership']),
        vendingMachineCode: json['vendingMachineCode'] as String?,
        modelNo: json['modelNo'] as String?,
        serialNumber: json['serialNumber']?.toString(),
        // Ensure string format
        vendingMachineType: json['vendingMachineType'] is Map<String, dynamic>
            ? IdName.fromJson(json['vendingMachineType'])
            : null,
        commissionDate: json['commissionDate'] != null
            ? DateTime.tryParse(json['commissionDate'])
            : null,
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
      print(e);
      print(json);
      return ExternalMachines(
        id: "",
        ownership: Branches.fromJson(json['ownership']),
        vendingMachineCode: "vendingMachineCode",
        modelNo: "modelNo",
        serialNumber: "serialNumber",
        vendingMachineType: IdName.fromJson({"_id": "_id", "name": "name"}),
        commissionDate: DateTime.now(),
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
      'ownership': ownership,
      'vendingMachineCode': vendingMachineCode,
      'modelNo': modelNo,
      'serialNumber': serialNumber,
      'vendingMachineType': vendingMachineType?.toJson(),
      'commissionDate': commissionDate?.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String()
    };
  }

  @override
  String toString() => '''
  ExternalMachines: {
    "_id": "$id",
    "ownership": "$ownership",
    "vendingMachineCode": "$vendingMachineCode",
    "modelNo": "$modelNo",
    "serialNumber": "$serialNumber",
    "vendingMachineType": "${vendingMachineType?.name}",
    "commissionDate": "$commissionDate",
    "createdBy": "$createdBy",
    "updatedBy": "$updatedBy",
    "createdAt": "$createdAt",
    "updatedAt": "$updatedAt"
  }''';
}
