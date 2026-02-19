import '../../Utils/Services/IdName.dart';
import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'Branches.g.dart';

@HiveType(typeId: 37)
class Branches {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final IdName companyId;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final bool isDefault;
  @HiveField(4)
  final String? createdBy;
  @HiveField(5)
  final String? updatedBy;
  @HiveField(6)
  final DateTime createdAt;
  @HiveField(7)
  final DateTime updatedAt;

  Branches({
    required this.id,
    required this.companyId,
    required this.name,
    required this.isDefault,
     this.createdBy,
     this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Branches.fromJson(Map<String, dynamic> map) {

    try {
      return Branches(
        id: map['_id'] as String,
        companyId: IdName.fromJson(map['companyId']),
        name: map['name'] as String,
        isDefault: map['isDefault'] as bool,
        createdBy: map['createdBy'] as String?,
        updatedBy: map['updatedBy'] as String?,
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.parse(map['updatedAt']),
      );
    }catch (e) {
      print(map);
      print("branches: $e");

      return Branches(
        id: "Id",
        companyId: IdName.fromJson({"_id": "company id", "name": "Company name"}),
        name: "name",
        isDefault: false,
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
      'companyId': companyId,
      'name': name,
      'isDefault': isDefault,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return '{"_id": "$id", "companyId": "${companyId.name}", "name": "$name", "isDefault": $isDefault, "createdBy": "$createdBy", "updatedBy": "$updatedBy", "createdAt": "$createdAt", "updatedAt": "$updatedAt"}';
  }
}
