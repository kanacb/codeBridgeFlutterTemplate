import 'dart:convert';
import 'package:hive/hive.dart';
import '../../Utils/Services/IdName.dart';
 
part 'Department.g.dart';
 
@HiveType(typeId: 5)

class Department {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final IdName? companyIds;
	@HiveField(2)
	 
	final String? name;
	@HiveField(3)
	 
	final String? code;
	@HiveField(4)
	 
	final bool? isDefault;

  Department({
    this.id,
		this.companyIds,
		this.name,
		this.code,
		this.isDefault
  });

  factory Department.fromJson(Map<String, dynamic> map) {
    return Department(
      id: map['_id'] as String?,
			companyIds : map['companyIds'] as IdName?,
			name : map['name'] as String?,
			code : map['code'] as String?,
			isDefault : map['isDefault'] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"isDefault" : isDefault
    };
}

  @override
  String toString() => 'Department("_id" : $id,"companyIds": $companyIds,"name": $name,"code": $code,"isDefault": $isDefault)';
}