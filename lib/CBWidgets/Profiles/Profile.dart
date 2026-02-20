import 'dart:convert';
import 'package:hive/hive.dart';
import '../../Utils/Services/IdName.dart';
 
part 'Profile.g.dart';
 
@HiveType(typeId: 9)

class Profile {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String? name;
	@HiveField(2)
	 
	final IdName? userId;
	@HiveField(3)
	 
	final String? image;
	@HiveField(4)
	 
	final String? bio;
	@HiveField(5)
	 
	final IdName? department;
	@HiveField(6)
	 
	final bool? hod;
	@HiveField(7)
	 
	final IdName? section;
	@HiveField(8)
	 
	final bool? hos;
	@HiveField(9)
	 
	final IdName? position;
	@HiveField(10)
	 
	final IdName? manager;
	@HiveField(11)
	 
	final IdName? company;
	@HiveField(12)
	 
	final IdName? branch;
	@HiveField(13)
	 
	final String? skills;
	@HiveField(14)
	 
	final IdName? address;
	@HiveField(15)
	 
	final IdName? phone;

  Profile({
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

  factory Profile.fromJson(Map<String, dynamic> map) {
    return Profile(
      id: map['_id'] as String?,
			name : map['name'] != null ? map['name'] as String : "",
			userId : map['userId'] as IdName?,
			image : map['image'] != null ? map['image'] as String : "",
			bio : map['bio'] as String?,
			department : map['department'] != null ? map['department'] as ObjectId : "",
			hod : map['hod'] as bool,
			section : map['section'] as IdName?,
			hos : map['hos'] as bool,
			position : map['position'] != null ? map['position'] as ObjectId : "",
			manager : map['manager'] as IdName?,
			company : map['company'] != null ? map['company'] as ObjectId : "",
			branch : map['branch'] as IdName?,
			skills : map['skills'] as String?,
			address : map['address'] as IdName?,
			phone : map['phone'] as IdName?
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
  String toString() => 'Profile("_id" : $id,"name": $name,"userId": $userId,"image": $image,"bio": $bio,"department": $department,"hod": $hod,"section": $section,"hos": $hos,"position": $position,"manager": $manager,"company": $company,"branch": $branch,"skills": $skills,"address": $address,"phone": $phone)';
}