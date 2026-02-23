import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'DepartmentHO.g.dart';
 
@HiveType(typeId: 20)

class DepartmentHO {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String name;

  DepartmentHO({
    this.id,
		required this.name
  });

  factory DepartmentHO.fromJson(Map<String, dynamic> map) {
    return DepartmentHO(
      id: map['_id'] as String?,
			name : map['name'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id
    };
}

  @override
  String toString() => 'DepartmentHO("_id" : $id,"name": $name.toString())';
}