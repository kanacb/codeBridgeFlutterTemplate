import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Users/User.dart';
 
 
part 'Uploader.g.dart';
 
@HiveType(typeId: 36)

class Uploader {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String? serviceName;
	@HiveField(2)
	 
	final User? user;
	@HiveField(3)
	 
	final String? results;

  Uploader({
    this.id,
		this.serviceName,
		this.user,
		this.results
  });

  factory Uploader.fromJson(Map<String, dynamic> map) {
    return Uploader(
      id: map['_id'] as String?,
			serviceName : map['serviceName'] as String?,
			user : map['user'] != null ? User.fromJson(map['user']) : null,
			results : map['results'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"user" : user?.id.toString()
    };
}

  @override
  String toString() => 'Uploader("_id" : $id,"serviceName": $serviceName.toString(),"user": $user.toString(),"results": $results.toString())';
}