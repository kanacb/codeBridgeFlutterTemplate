import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
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
	 
	final String fullName;
	@HiveField(4)
	 
	final String? company;
	@HiveField(5)
	 
	final String? department;
	@HiveField(6)
	 
	final String? section;
	@HiveField(7)
	 
	final String? position;
	@HiveField(8)
	 
	final String? supervisor;
	@HiveField(9)
	 
	final String? dateJoined;
	@HiveField(10)
	 
	final String? dateTerminated;
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
		required this.fullName,
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
			fullName : map['fullName'] as String,
			company : map['company'] as String?,
			department : map['department'] as String?,
			section : map['section'] as String?,
			position : map['position'] as String?,
			supervisor : map['supervisor'] as String?,
			dateJoined : map['dateJoined'] as String?,
			dateTerminated : map['dateTerminated'] as String?,
			resigned : map['resigned'] as String,
			empGroup : map['empGroup'] as String,
			empCode : map['empCode'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id
    };
}

  @override
  String toString() => 'Employee("_id" : $id,"empNo": $empNo.toString(),"name": $name.toString(),"fullName": $fullName.toString(),"company": $company.toString(),"department": $department.toString(),"section": $section.toString(),"position": $position.toString(),"supervisor": $supervisor.toString(),"dateJoined": $dateJoined.toString(),"dateTerminated": $dateTerminated.toString(),"resigned": $resigned.toString(),"empGroup": $empGroup.toString(),"empCode": $empCode.toString())';
}