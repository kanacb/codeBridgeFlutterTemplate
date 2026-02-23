import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Companies/Company.dart';
import '../Departments/Department.dart';
import '../Sections/Section.dart';
import '../Positions/Position.dart';
import '../Employees/Employee.dart';
 
 
part 'Employee.g.dart';
 
@HiveType(typeId: 16)

class Employee {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String empNo;
	@HiveField(2)
	 
	final String name;
	@HiveField(3)
	 
	final String fullname;
	@HiveField(4)
	 
	final Company? company;
	@HiveField(5)
	 
	final Department? department;
	@HiveField(6)
	 
	final Section? section;
	@HiveField(7)
	 
	final Position? position;
	@HiveField(8)
	 
	final Employee? supervisor;
	@HiveField(9)
	 
	final DateTime? dateJoined;
	@HiveField(10)
	 
	final DateTime? dateTerminated;
	@HiveField(11)
	 
	final String resigned;
	@HiveField(12)
	 
	final String empGroup;
	@HiveField(13)
	 
	final String empCode;

  Employee({
    this.id,
		required this.empNo,
		required this.name,
		required this.fullname,
		this.company,
		this.department,
		this.section,
		this.position,
		this.supervisor,
		this.dateJoined,
		this.dateTerminated,
		required this.resigned,
		required this.empGroup,
		required this.empCode
  });

  factory Employee.fromJson(Map<String, dynamic> map) {
    return Employee(
      id: map['_id'] as String?,
			empNo : map['empNo'] as String,
			name : map['name'] as String,
			fullname : map['fullname'] as String,
			company : map['company'] != null ? Company.fromJson(map['company']) : null,
			department : map['department'] != null ? Department.fromJson(map['department']) : null,
			section : map['section'] != null ? Section.fromJson(map['section']) : null,
			position : map['position'] != null ? Position.fromJson(map['position']) : null,
			supervisor : map['supervisor'] != null ? Employee.fromJson(map['supervisor']) : null,
			dateJoined : map['dateJoined'] != null ? DateTime.parse(map['dateJoined']) : null,
			dateTerminated : map['dateTerminated'] != null ? DateTime.parse(map['dateTerminated']) : null,
			resigned : map['resigned'] as String,
			empGroup : map['empGroup'] as String,
			empCode : map['empCode'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"company" : company?.id.toString(),
			"department" : department?.id.toString(),
			"section" : section?.id.toString(),
			"position" : position?.id.toString(),
			"supervisor" : supervisor?.id.toString(),
			'dateJoined' : dateJoined?.toIso8601String(),
			'dateTerminated' : dateTerminated?.toIso8601String()
    };
}

  @override
  String toString() => 'Employee("_id" : $id,"empNo": $empNo.toString(),"name": $name.toString(),"fullname": $fullname.toString(),"company": $company.toString(),"department": $department.toString(),"section": $section.toString(),"position": $position.toString(),"supervisor": $supervisor.toString(),"dateJoined": $dateJoined?.toIso8601String()},"dateTerminated": $dateTerminated?.toIso8601String()},"resigned": $resigned.toString(),"empGroup": $empGroup.toString(),"empCode": $empCode.toString())';
}