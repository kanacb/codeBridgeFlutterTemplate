import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Users/User.dart';
 
 
part 'LoginHistory.g.dart';
 
@HiveType(typeId: 32)

class LoginHistory {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final User? userId;
	@HiveField(2)
	 
	final String? device;
	@HiveField(3)
	 
	final String? browser;
	@HiveField(4)
	 
	final String? userAgent;
	@HiveField(5)
	 
	final DateTime? loginTime;

  LoginHistory({
    this.id,
		this.userId,
		this.device,
		this.browser,
		this.userAgent,
		this.loginTime
  });

  factory LoginHistory.fromJson(Map<String, dynamic> map) {
    return LoginHistory(
      id: map['_id'] as String?,
			userId : map['userId'] != null ? User.fromJson(map['userId']) : null,
			device : map['device'] as String?,
			browser : map['browser'] as String?,
			userAgent : map['userAgent'] as String?,
			loginTime : map['loginTime'] != null ? DateTime.parse(map['loginTime']) : null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"userId" : userId?.id.toString(),
			'loginTime' : loginTime?.toIso8601String()
    };
}

  @override
  String toString() => 'LoginHistory("_id" : $id,"userId": $userId.toString(),"device": $device.toString(),"browser": $browser.toString(),"userAgent": $userAgent.toString(),"loginTime": $loginTime?.toIso8601String()})';
}