import 'dart:convert';
import 'package:hive/hive.dart';
import '../../Utils/Services/IdName.dart';
 
part 'DepartmentHO.g.dart';
 
@HiveType(typeId: 21)

class DepartmentHO {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String? name;

  DepartmentHO({
    this.id,
		this.name
  });

  factory DepartmentHO.fromJson(Map<String, dynamic> map) {
    return DepartmentHO(
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
  String toString() => 'DepartmentHO("_id" : $id,"name": $name)';
}