import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)

class DepartmentHOS {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	final String? name;
	 

  DepartmentHOS({
    this.id,
		this.name
  });

  factory DepartmentHOS.fromJson(Map<String, dynamic> map) {
    return DepartmentHOS(
      id: map['_id'] as String?,
			name : map['name'] != null ? map['name'] as String : ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id
    };
}

  @override
  String toString() => 'DepartmentHOS("_id" : $id,"name": $name)';
}