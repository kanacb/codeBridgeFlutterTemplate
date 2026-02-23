import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Departments/Department.dart';
import '../Employees/Employee.dart';
 
 
part 'DepartmentAdmin.g.dart';
 
@HiveType(typeId: 18)

class DepartmentAdmin {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final Department? departmentId;
	@HiveField(2)
	 
	final Employee? employeeId;

  DepartmentAdmin({
    this.id,
		this.departmentId,
		this.employeeId
  });

  factory DepartmentAdmin.fromJson(Map<String, dynamic> map) {
    return DepartmentAdmin(
      id: map['_id'] as String?,
			departmentId : map['departmentId'] != null ? Department.fromJson(map['departmentId']) : null,
			employeeId : map['employeeId'] != null ? Employee.fromJson(map['employeeId']) : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"departmentId" : departmentId?.id.toString(),
			"employeeId" : employeeId?.id.toString()
    };
}

  @override
  String toString() => 'DepartmentAdmin("_id" : $id,"departmentId": $departmentId.toString(),"employeeId": $employeeId.toString())';
}