import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'ChataiEnabler.g.dart';
 
@HiveType(typeId: 24)

class ChataiEnabler {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String? name;
	@HiveField(2)
	 
	final String? serviceName;
	@HiveField(3)
	 
	final String? description;

  ChataiEnabler({
    this.id,
		this.name,
		this.serviceName,
		this.description
  });

  factory ChataiEnabler.fromJson(Map<String, dynamic> map) {
    return ChataiEnabler(
      id: map['_id'] as String?,
			name : map['name'] as String?,
			serviceName : map['serviceName'] as String?,
			description : map['description'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id
    };
}

  @override
  String toString() => 'ChataiEnabler("_id" : $id,"name": $name.toString(),"serviceName": $serviceName.toString(),"description": $description.toString())';
}