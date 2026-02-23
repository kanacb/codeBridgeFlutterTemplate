import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'Audit.g.dart';
 
@HiveType(typeId: 23)

class Audit {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String? serviceName;
	@HiveField(2)
	 
	final String? action;
	@HiveField(3)
	 
	final String? details;
	@HiveField(4)
	 
	final String method;

  Audit({
    this.id,
		this.serviceName,
		this.action,
		this.details,
		required this.method
  });

  factory Audit.fromJson(Map<String, dynamic> map) {
    return Audit(
      id: map['_id'] as String?,
			serviceName : map['serviceName'] as String?,
			action : map['action'] as String?,
			details : map['details'] as String?,
			method : map['method'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id
    };
}

  @override
  String toString() => 'Audit("_id" : $id,"serviceName": $serviceName.toString(),"action": $action.toString(),"details": $details.toString(),"method": $method.toString())';
}