import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)

class Departments {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	final String? companyIds;
	 
	@HiveField(2)
	final String? name;
	 
	@HiveField(3)
	final String? code;
	 
	@HiveField(4)
	final bool? isDefault;
	 

  Departments({
    this.id,
		this.companyIds,
		this.name,
		this.code,
		this.isDefault
  });

  factory Departments.fromJson(Map<String, dynamic> map) {
    return Departments(
      id: map['_id'] as String?,
			companyIds : map['companyIds'] as String?,
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
  String toString() => 'Departments("_id" : $id,"companyIds": $companyIds,"name": $name,"code": $code,"isDefault": $isDefault)';
}