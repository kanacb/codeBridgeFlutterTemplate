import 'dart:convert';
import 'package:hive/hive.dart';
import '../../Utils/Services/IdName.dart';
 
part 'DepartmentHOD.g.dart';
 
@HiveType(typeId: 20)

class DepartmentHOD {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String? name;

  DepartmentHOD({
    this.id,
		this.name
  });

  factory DepartmentHOD.fromJson(Map<String, dynamic> map) {
    return DepartmentHOD(
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
  String toString() => 'DepartmentHOD("_id" : $id,"name": $name)';
}