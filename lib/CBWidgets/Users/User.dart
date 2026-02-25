import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'User.g.dart';
 
@HiveType(typeId: 2)

class User {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String name;
	@HiveField(2)
	 
	final String email;
	@HiveField(3)
	 
	final String password;
	@HiveField(4)
	 
	final bool? status;

  User({
    this.id,
		required this.name,
		required this.email,
		required this.password,
		this.status
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String?,
			name : map['name'] as String,
			email : map['email'] as String,
			password : map['password'] as String,
			status : map['status'] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"status" : status
    };
}

  @override
  String toString() => 'User("_id" : $id,"name": $name.toString(),"email": $email.toString(),"password": $password.toString(),"status": $status)';
}