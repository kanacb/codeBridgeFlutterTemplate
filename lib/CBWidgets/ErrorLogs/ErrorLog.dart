import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'ErrorLog.g.dart';
 
@HiveType(typeId: 42)

class ErrorLog {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String? serviceName;
	@HiveField(2)
	 
	final String? errorMessage;
	@HiveField(3)
	 
	final String? message;
	@HiveField(4)
	 
	final String? requestBody;
	@HiveField(5)
	 
	final String? stack;
	@HiveField(6)
	 
	final String? details;

  ErrorLog({
    this.id,
		this.serviceName,
		this.errorMessage,
		this.message,
		this.requestBody,
		this.stack,
		this.details
  });

  factory ErrorLog.fromJson(Map<String, dynamic> map) {
    return ErrorLog(
      id: map['_id'] as String?,
			serviceName : map['serviceName'] as String?,
			errorMessage : map['errorMessage'] as String?,
			message : map['message'] as String?,
			requestBody : map['requestBody'] as String?,
			stack : map['stack'] as String?,
			details : map['details'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id
    };
}

  @override
  String toString() => 'ErrorLog("_id" : $id,"serviceName": $serviceName.toString(),"errorMessage": $errorMessage.toString(),"message": $message.toString(),"requestBody": $requestBody.toString(),"stack": $stack.toString(),"details": $details.toString())';
}