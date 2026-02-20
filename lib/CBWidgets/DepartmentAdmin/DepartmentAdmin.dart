import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)

class DepartmentAdmin {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	final String? departmentId;
	 
	@HiveField(2)
	final String? employeeId;
	 

  DepartmentAdmin({
    this.id,
		this.departmentId,
		this.employeeId
  });

  factory DepartmentAdmin.fromJson(Map<String, dynamic> map) {
    return DepartmentAdmin(
      id: map['_id'] as String?,
			departmentId : map['departmentId'] as String?,
			employeeId : map['employeeId'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id
    };
}

  @override
  String toString() => 'DepartmentAdmin("_id" : $id,"departmentId": $departmentId,"employeeId": $employeeId)';
}