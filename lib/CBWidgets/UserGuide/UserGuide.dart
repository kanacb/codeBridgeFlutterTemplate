import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'UserGuide.g.dart';
 
@HiveType(typeId: 22)

class UserGuide {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String serviceName;
	@HiveField(2)
	 
	final DateTime? expiry;

  UserGuide({
    this.id,
		required this.serviceName,
		this.expiry
  });

  factory UserGuide.fromJson(Map<String, dynamic> map) {
    return UserGuide(
      id: map['_id'] as String?,
			serviceName : map['serviceName'] as String,
			expiry : map['expiry'] != null ? DateTime.parse(map['expiry']) : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			'expiry' : expiry?.toIso8601String()
    };
}

  @override
  String toString() => 'UserGuide("_id" : $id,"serviceName": $serviceName.toString(),"expiry": $expiry?.toIso8601String()})';
}