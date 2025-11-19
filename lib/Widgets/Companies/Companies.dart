import 'package:hive/hive.dart';
// dart run build_runner build --delete-conflicting-outputs
part 'Companies.g.dart';

@HiveType(typeId: 38)
class Companies {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? companyNo;
  @HiveField(3)
  final dynamic newCompanyNumber;
  @HiveField(4)
  final String? companyType;
  @HiveField(5)
  final bool isDefault;
  @HiveField(6)
  final String? createdBy;
  @HiveField(7)
  final String? updatedBy;
  @HiveField(8)
  final DateTime createdAt;
  @HiveField(9)
  final DateTime updatedAt;

  Companies({
    required this.id,
    required this.name,
    this.companyNo,
    required this.newCompanyNumber,
    this.companyType,
    required this.isDefault,
     this.createdBy,
     this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Companies.fromJson(Map<String, dynamic> map) {
    try {
      return Companies(
        id: map['_id'] as String,
        name: map['name'] as String,
        companyNo: map['companyNo'] as String?,
        newCompanyNumber: map['newCompanyNumber'] as dynamic,
        companyType: map['companyType'] as String,
        isDefault: map['isdefault'] as bool,
        createdBy: map['createdBy'] as String?,
        updatedBy: map['updatedBy'] as String?,
        createdAt: DateTime.parse(map['createdAt']),
        updatedAt: DateTime.parse(map['updatedAt']),
      );
    } catch (e) {
      print("ERROR Companies.dart $e");
      print(map);
      return Companies(
        id: "id",
        name: "name",
        companyNo: "companyNo",
        newCompanyNumber: 1242529,
        companyType: "companyType",
        isDefault: false,
        createdBy: "",
        updatedBy: "",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'companyNo': companyNo,
      'newCompanyNumber': newCompanyNumber,
      'companyType': companyType,
      'isdefault': isDefault,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return '{"_id": "$id", "name": "$name", "companyNo": "$companyNo", "newCompanyNumber": $newCompanyNumber, "isdefault": $isDefault, "createdBy": "$createdBy", "updatedBy": "$updatedBy", "createdAt": "$createdAt", "updatedAt": "$updatedAt"}';
  }
}
