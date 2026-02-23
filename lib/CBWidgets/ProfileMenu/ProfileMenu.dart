import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Users/User.dart';
import '../Roles/Role.dart';
import '../Positions/Position.dart';
import '../Profiles/Profile.dart';
import '../Companies/Company.dart';
import '../Branches/Branch.dart';
import '../Sections/Section.dart';
 
 
part 'ProfileMenu.g.dart';
 
@HiveType(typeId: 34)

class ProfileMenu {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final User? user;
	@HiveField(2)
	 
	final List<Role>? roles;
	@HiveField(3)
	 
	final List<Position>? positions;
	@HiveField(4)
	 
	final List<Profile>? profiles;
	@HiveField(5)
	 
	final String? menuItems;
	@HiveField(6)
	 
	final Company? company;
	@HiveField(7)
	 
	final Branch? branch;
	@HiveField(8)
	 
	final Section? section;

  ProfileMenu({
    this.id,
		this.user,
		this.roles,
		this.positions,
		this.profiles,
		this.menuItems,
		this.company,
		this.branch,
		this.section
  });

  factory ProfileMenu.fromJson(Map<String, dynamic> map) {
    return ProfileMenu(
      id: map['_id'] as String?,
			user : map['user'] != null ? User.fromJson(map['user']) : null,
			roles : map['roles'] != null ? (map['roles'] as List).map((e) => Role.fromJson(e)).toList() : null,
			positions : map['positions'] != null ? (map['positions'] as List).map((e) => Position.fromJson(e)).toList() : null,
			profiles : map['profiles'] != null ? (map['profiles'] as List).map((e) => Profile.fromJson(e)).toList() : null,
			menuItems : map['menuItems'] as String?,
			company : map['company'] != null ? Company.fromJson(map['company']) : null,
			branch : map['branch'] != null ? Branch.fromJson(map['branch']) : null,
			section : map['section'] != null ? Section.fromJson(map['section']) : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"user" : user?.id.toString(),
			"roles" : roles?.map((e) => e.toJson()).toList(),
			"positions" : positions?.map((e) => e.toJson()).toList(),
			"profiles" : profiles?.map((e) => e.toJson()).toList(),
			"company" : company?.id.toString(),
			"branch" : branch?.id.toString(),
			"section" : section?.id.toString()
    };
}

  @override
  String toString() => 'ProfileMenu("_id" : $id,"user": $user.toString(),"roles": $roles.toString(),"positions": $positions.toString(),"profiles": $profiles.toString(),"menuItems": $menuItems.toString(),"company": $company.toString(),"branch": $branch.toString(),"section": $section.toString())';
}