import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Companies/Company.dart';
 
 
part 'Department.g.dart';
 
@HiveType(typeId: 5)

class Department {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final Company company;
	@HiveField(2)
	 
	final String? deptName;
	@HiveField(3)
	 
	final String? code;
	@HiveField(4)
	 
	final bool? isDefault;

  Department({
    this.id,
		required this.company,
		this.deptName,
		this.code,
		this.isDefault
  });

  factory Department.fromJson(Map<String, dynamic> map) {
    return Department(
      id: map['_id'] as String?,
			company : Company.fromJson(map['company']),
			deptName : map['deptName'] as String?,
			code : map['code'] as String?,
			isDefault : map['isDefault'] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"company" : company.id.toString(),
			"isDefault" : isDefault
    };
}

  @override
  String toString() => 'Department("_id" : $id,"company": $company.toString(),"deptName": $deptName.toString(),"code": $code.toString(),"isDefault": $isDefault)';
}