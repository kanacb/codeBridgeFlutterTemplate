import 'dart:convert';

import 'package:hive/hive.dart';
import '../../../Utils/Services/IdName.dart';
import '../../../Widgets/Addresses/Address.dart';
import '../../../Widgets/Phones/Phone.dart';
import '../../../Widgets/Users/User.dart';

part 'Profile.g.dart';

@HiveType(typeId: 1)
class Profile {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final User userId;

  @HiveField(3)
  late final bool? hod;

  @HiveField(4)
  late final bool? hos;

  @HiveField(5)
  late final IdName? role;

  @HiveField(6)
  late final IdName? position;

  @HiveField(7)
  late final List<String>? skills;

  @HiveField(8)
  late final String? bio;

  @HiveField(9)
  late final String? image;

  @HiveField(10)
  late final IdName? branch;

  @HiveField(11)
  late final IdName? company;

  @HiveField(12)
  late final IdName? department;

  @HiveField(13)
  late final IdName? section;

  @HiveField(14)
  late final Address? address;

  @HiveField(15)
  late final Phone? phone;

  @HiveField(16)
  final DateTime createdAt;

  @HiveField(17)
  final DateTime updatedAt;

  Profile({
    required this.id,
    required this.name,
    required this.userId,
    this.hod,
    this.hos,
     this.role,
    this.position,
    this.skills,
    this.bio,
    this.image,
    this.branch,
    this.company,
    this.department,
    this.section,
    this.address,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> map) {
    // Handle image: if it's a list, take the first element, otherwise use it directly.
    String? imageValue = '';
    if(map['image'] != null){
      if (map['image'] is List) {
        final list = map['image'] as List;
        imageValue = list.isNotEmpty ? list[0].toString() : "";
      } else {
        imageValue = map['image'] ?? "";
      }
    }

    return Profile(
      id: map["_id"],
      name: map['name'],
      userId: User.fromJson(map['userId']),
      hod: map['hod'], // assuming this is a bool already
      hos: map['hos'], // assuming this is a bool already
      role: map["role"] != null ? IdName.fromJson(map['role']) : null,
      position: map['position'] != null ? IdName.fromJson(map['position']) : null,
      skills: map['skills'] is List ? List<String>.from(map['skills']) : [],
      bio: map['bio'] ?? "",
      image: imageValue,
      branch: map['branch'] != null ? IdName.fromJson(map['branch']) : null,
      company: map['company'] != null ? IdName.fromJson(map['company']) : null,
      department: map['department'] != null ? IdName.fromJson(map['department']) : null,
      section: map['section'] != null ? IdName.fromJson(map['section']) : null,
      address: map['address'] != null ? Address.fromJson(map['address']) : null,
      phone: map['phone'] != null ? Phone.fromJson(map['phone']) : null,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["_id"] = id;
    data['name'] = name;
    data['userId'] = userId.id;
    data['hod'] = hod;
    data['hos'] = hos;
    // Store the full position object if it exists
    data['role'] = role?.toJson();
    data['position'] = position?.toJson();
    data['skills'] = skills;
    data['bio'] = bio;
    data['image'] = image;
    data['branch'] = branch?.toJson();
    data['company'] = company?.toJson();
    data['department'] = department?.toJson();
    data['section'] = section?.toJson();
    data['address'] = address?.toJson();
    data['phone'] = phone?.toJson();
    data['createdAt'] = createdAt.toIso8601String();
    data['updatedAt'] = updatedAt.toIso8601String();
    data['role'] = role;
    return data;
  }


  @override
  String toString() =>
      'Profile(id: $id, name : $name, user: $userId, hod: $hod, hos: $hos, bio: $bio, company: ${company?.name}, branch: ${branch?.name}, department: ${department?.name}, section: ${section?.name})';
}
