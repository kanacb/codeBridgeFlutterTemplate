import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Positions/Position.dart';
import '../Roles/Role.dart';
import '../Companies/Company.dart';
import '../Branches/Branch.dart';
import '../Departments/Department.dart';
import '../Sections/Section.dart';
 
 
part 'UserInvite.g.dart';
 
@HiveType(typeId: 38)

class UserInvite {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String emailToInvite;
	@HiveField(2)
	 
	final bool? status;
	@HiveField(3)
	 
	final Position? position;
	@HiveField(4)
	 
	final Role? role;
	@HiveField(5)
	 
	final Company? company;
	@HiveField(6)
	 
	final Branch? branch;
	@HiveField(7)
	 
	final Department? department;
	@HiveField(8)
	 
	final Section? section;
	@HiveField(9)
	 
	final int? code;
	@HiveField(10)
	 
	final int? sendMailCounter;

  UserInvite({
    this.id,
		required this.emailToInvite,
		this.status,
		this.position,
		this.role,
		this.company,
		this.branch,
		this.department,
		this.section,
		this.code,
		this.sendMailCounter
  });

  factory UserInvite.fromJson(Map<String, dynamic> map) {
    return UserInvite(
      id: map['_id'] as String?,
			emailToInvite : map['emailToInvite'] as String,
			status : map['status'] as bool,
			position : map['position'] != null ? Position.fromJson(map['position']) : null,
			role : map['role'] != null ? Role.fromJson(map['role']) : null,
			company : map['company'] != null ? Company.fromJson(map['company']) : null,
			branch : map['branch'] != null ? Branch.fromJson(map['branch']) : null,
			department : map['department'] != null ? Department.fromJson(map['department']) : null,
			section : map['section'] != null ? Section.fromJson(map['section']) : null,
			code : map['code'] as int,
			sendMailCounter : map['sendMailCounter'] as int
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"status" : status,
			"position" : position?.id.toString(),
			"role" : role?.id.toString(),
			"company" : company?.id.toString(),
			"branch" : branch?.id.toString(),
			"department" : department?.id.toString(),
			"section" : section?.id.toString(),
			"code" : code,
			"sendMailCounter" : sendMailCounter
    };
}

  @override
  String toString() => 'UserInvite("_id" : $id,"emailToInvite": $emailToInvite.toString(),"status": $status,"position": $position.toString(),"role": $role.toString(),"company": $company.toString(),"branch": $branch.toString(),"department": $department.toString(),"section": $section.toString(),"code": $code,"sendMailCounter": $sendMailCounter)';
}