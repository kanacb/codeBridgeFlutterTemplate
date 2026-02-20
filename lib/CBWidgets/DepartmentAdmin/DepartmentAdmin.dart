import 'dart:convert';
import 'package:hive/hive.dart';
import '../../Utils/Services/IdName.dart';
 
part 'DepartmentAdmin.g.dart';
 
@HiveType(typeId: 19)

class DepartmentAdmin {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final IdName? departmentId;
	@HiveField(2)
	 
	final IdName? employeeId;

  DepartmentAdmin({
    this.id,
		this.departmentId,
		this.employeeId
  });

  factory DepartmentAdmin.fromJson(Map<String, dynamic> map) {
    return DepartmentAdmin(
      id: map['_id'] as String?,
			departmentId : map['departmentId'] as IdName?,
			employeeId : map['employeeId'] as IdName?
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