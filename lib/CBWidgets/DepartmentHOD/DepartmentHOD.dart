import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'DepartmentHOD.g.dart';
 
@HiveType(typeId: 19)

class DepartmentHOD {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String name;

  DepartmentHOD({
    this.id,
		required this.name
  });

  factory DepartmentHOD.fromJson(Map<String, dynamic> map) {
    return DepartmentHOD(
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
  String toString() => 'DepartmentHOD("_id" : $id,"name": $name.toString())';
}