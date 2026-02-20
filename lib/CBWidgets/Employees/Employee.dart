import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)

class Employee {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	final String? empNo;
	 
	@HiveField(2)
	final String? name;
	 
	@HiveField(3)
	final String? fullname;
	 
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
	final DateTime? dateJoined;
	 
	@HiveField(10)
	final DateTime? dateTerminated;
	 
	@HiveField(11)
	final String? resigned;
	 
	@HiveField(12)
	final String? empGroup;
	 
	@HiveField(13)
	final String? empCode;
	 

  Employee({
    this.id,
		this.empNo,
		this.name,
		this.fullname,
		this.company,
		this.department,
		this.section,
		this.position,
		this.supervisor,
		this.dateJoined,
		this.dateTerminated,
		this.resigned,
		this.empGroup,
		this.empCode
  });

  factory Employee.fromJson(Map<String, dynamic> map) {
    return Employee(
      id: map['_id'] as String?,
			empNo : map['empNo'] != null ? map['empNo'] as String : "",
			name : map['name'] != null ? map['name'] as String : "",
			fullname : map['fullname'] != null ? map['fullname'] as String : "",
			company : map['company'] as String?,
			department : map['department'] as String?,
			section : map['section'] as String?,
			position : map['position'] as String?,
			supervisor : map['supervisor'] as String?,
			dateJoined : map['dateJoined'] != null ? DateTime.parse(map['dateJoined']) : null,
			dateTerminated : map['dateTerminated'] != null ? DateTime.parse(map['dateTerminated']) : null,
			resigned : map['resigned'] != null ? map['resigned'] as String : "",
			empGroup : map['empGroup'] != null ? map['empGroup'] as String : "",
			empCode : map['empCode'] != null ? map['empCode'] as String : ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			'dateJoined' : dateJoined?.toIso8601String(),
			'dateTerminated' : dateTerminated?.toIso8601String()
    };
}

  @override
  String toString() => 'Employee("_id" : $id,"empNo": $empNo,"name": $name,"fullname": $fullname,"company": $company,"department": $department,"section": $section,"position": $position,"supervisor": $supervisor,"dateJoined": ${dateJoined?.toIso8601String()},"dateTerminated": ${dateTerminated?.toIso8601String()},"resigned": $resigned,"empGroup": $empGroup,"empCode": $empCode)';
}