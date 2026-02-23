import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Users/User.dart';
import '../Departments/Department.dart';
import '../Sections/Section.dart';
import '../Roles/Role.dart';
import '../Positions/Position.dart';
import '../Users/User.dart';
import '../Companies/Company.dart';
import '../Branches/Branch.dart';
import '../UserAddresses/UserAddress.dart';
import '../UserPhones/UserPhone.dart';
 
 
part 'Profile.g.dart';
 
@HiveType(typeId: 9)

class Profile {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String name;
	@HiveField(2)
	 
	final User? userId;
	@HiveField(3)
	 
	final String image;
	@HiveField(4)
	 
	final String? bio;
	@HiveField(5)
	 
	final Department department;
	@HiveField(6)
	 
	final bool hod;
	@HiveField(7)
	 
	final Section? section;
	@HiveField(8)
	 
	final bool hos;
	@HiveField(9)
	 
	final Role? role;
	@HiveField(10)
	 
	final Position position;
	@HiveField(11)
	 
	final User? manager;
	@HiveField(12)
	 
	final Company company;
	@HiveField(13)
	 
	final Branch? branch;
	@HiveField(14)
	 
	final String? skills;
	@HiveField(15)
	 
	final UserAddress? address;
	@HiveField(16)
	 
	final UserPhone? phone;

  Profile({
    this.id,
		required this.name,
		this.userId,
		required this.image,
		this.bio,
		required this.department,
		required this.hod,
		this.section,
		required this.hos,
		this.role,
		required this.position,
		this.manager,
		required this.company,
		this.branch,
		this.skills,
		this.address,
		this.phone
  });

  factory Profile.fromJson(Map<String, dynamic> map) {
    return Profile(
      id: map['_id'] as String?,
			name : map['name'] as String,
			userId : map['userId'] != null ? User.fromJson(map['userId']) : null,
			image : map['image'] as String,
			bio : map['bio'] as String?,
			department : Department.fromJson(map['department']),
			hod : map['hod'] as bool,
			section : map['section'] != null ? Section.fromJson(map['section']) : null,
			hos : map['hos'] as bool,
			role : map['role'] != null ? Role.fromJson(map['role']) : null,
			position : Position.fromJson(map['position']),
			manager : map['manager'] != null ? User.fromJson(map['manager']) : null,
			company : Company.fromJson(map['company']),
			branch : map['branch'] != null ? Branch.fromJson(map['branch']) : null,
			skills : map['skills'] as String?,
			address : map['address'] != null ? UserAddress.fromJson(map['address']) : null,
			phone : map['phone'] != null ? UserPhone.fromJson(map['phone']) : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"userId" : userId?.id.toString(),
			"department" : department.id.toString(),
			"hod" : hod,
			"section" : section?.id.toString(),
			"hos" : hos,
			"role" : role?.id.toString(),
			"position" : position.id.toString(),
			"manager" : manager?.id.toString(),
			"company" : company.id.toString(),
			"branch" : branch?.id.toString(),
			"address" : address?.id.toString(),
			"phone" : phone?.id.toString()
    };
}

  @override
  String toString() => 'Profile("_id" : $id,"name": $name.toString(),"userId": $userId.toString(),"image": $image.toString(),"bio": $bio.toString(),"department": $department.toString(),"hod": $hod.toString(),"section": $section.toString(),"hos": $hos.toString(),"role": $role.toString(),"position": $position.toString(),"manager": $manager.toString(),"company": $company.toString(),"branch": $branch.toString(),"skills": $skills.toString(),"address": $address.toString(),"phone": $phone.toString())';
}