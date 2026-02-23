import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'UserChangePassword.g.dart';
 
@HiveType(typeId: 37)

class UserChangePassword {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String userEmail;
	@HiveField(2)
	 
	final String server;
	@HiveField(3)
	 
	final String? environment;
	@HiveField(4)
	 
	final String code;
	@HiveField(5)
	 
	final bool? status;
	@HiveField(6)
	 
	final int? sendEmailCounter;
	@HiveField(7)
	 
	final DateTime? lastAttempt;
	@HiveField(8)
	 
	final String? ipAddress;

  UserChangePassword({
    this.id,
		required this.userEmail,
		required this.server,
		this.environment,
		required this.code,
		this.status,
		this.sendEmailCounter,
		this.lastAttempt,
		this.ipAddress
  });

  factory UserChangePassword.fromJson(Map<String, dynamic> map) {
    return UserChangePassword(
      id: map['_id'] as String?,
			userEmail : map['userEmail'] as String,
			server : map['server'] as String,
			environment : map['environment'] as String?,
			code : map['code'] as String,
			status : map['status'] as bool,
			sendEmailCounter : map['sendEmailCounter'] as int,
			lastAttempt : map['lastAttempt'] != null ? DateTime.parse(map['lastAttempt']) : null,
			ipAddress : map['ipAddress'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"status" : status,
			"sendEmailCounter" : sendEmailCounter,
			'lastAttempt' : lastAttempt?.toIso8601String()
    };
}

  @override
  String toString() => 'UserChangePassword("_id" : $id,"userEmail": $userEmail.toString(),"server": $server.toString(),"environment": $environment.toString(),"code": $code.toString(),"status": $status,"sendEmailCounter": $sendEmailCounter,"lastAttempt": $lastAttempt?.toIso8601String()},"ipAddress": $ipAddress.toString())';
}