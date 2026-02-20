import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)

class UserGuide {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	final String? serviceName;
	 
	@HiveField(2)
	final DateTime? expiry;
	 

  UserGuide({
    this.id,
		this.serviceName,
		this.expiry
  });

  factory UserGuide.fromJson(Map<String, dynamic> map) {
    return UserGuide(
      id: map['_id'] as String?,
			serviceName : map['serviceName'] != null ? map['serviceName'] as String : "",
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
  String toString() => 'UserGuide("_id" : $id,"serviceName": $serviceName,"expiry": ${expiry?.toIso8601String()})';
}