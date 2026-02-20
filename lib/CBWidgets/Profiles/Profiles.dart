import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)

class Profiles {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	final String? name;
	 
	@HiveField(2)
	final String? userId;
	 
	@HiveField(3)
	final String? image;
	 
	@HiveField(4)
	final String? bio;
	 
	@HiveField(5)
	final String? department;
	 
	@HiveField(6)
	final bool? hod;
	 
	@HiveField(7)
	final String? section;
	 
	@HiveField(8)
	final bool? hos;
	 
	@HiveField(9)
	final String? position;
	 
	@HiveField(10)
	final String? manager;
	 
	@HiveField(11)
	final String? company;
	 
	@HiveField(12)
	final String? branch;
	 
	@HiveField(13)
	final String? skills;
	 
	@HiveField(14)
	final String? address;
	 
	@HiveField(15)
	final String? phone;
	 

  Profiles({
    this.id,
		this.name,
		this.userId,
		this.image,
		this.bio,
		this.department,
		this.hod,
		this.section,
		this.hos,
		this.position,
		this.manager,
		this.company,
		this.branch,
		this.skills,
		this.address,
		this.phone
  });

  factory Profiles.fromJson(Map<String, dynamic> map) {
    return Profiles(
      id: map['_id'] as String?,
			name : map['name'] != null ? map['name'] as String : "",
			userId : map['userId'] as String?,
			image : map['image'] != null ? map['image'] as String : "",
			bio : map['bio'] as String?,
			department : map['department'] != null ? map['department'] as String : "",
			hod : map['hod'] as bool,
			section : map['section'] as String?,
			hos : map['hos'] as bool,
			position : map['position'] != null ? map['position'] as String : "",
			manager : map['manager'] as String?,
			company : map['company'] != null ? map['company'] as String : "",
			branch : map['branch'] as String?,
			skills : map['skills'] as String?,
			address : map['address'] as String?,
			phone : map['phone'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"hod" : hod,
			"hos" : hos
    };
}

  @override
  String toString() => 'Profiles("_id" : $id,"name": $name,"userId": $userId,"image": $image,"bio": $bio,"department": $department,"hod": $hod,"section": $section,"hos": $hos,"position": $position,"manager": $manager,"company": $company,"branch": $branch,"skills": $skills,"address": $address,"phone": $phone)';
}