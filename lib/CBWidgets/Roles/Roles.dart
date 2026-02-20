import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)

class Roles {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	final String? name;
	 
	@HiveField(2)
	final String? description;
	 
	@HiveField(3)
	final bool? isDefault;
	 

  Roles({
    this.id,
		this.name,
		this.description,
		this.isDefault
  });

  factory Roles.fromJson(Map<String, dynamic> map) {
    return Roles(
      id: map['_id'] as String?,
			name : map['name'] as String?,
			description : map['description'] as String?,
			isDefault : map['isDefault'] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"isDefault" : isDefault
    };
}

  @override
  String toString() => 'Roles("_id" : $id,"name": $name,"description": $description,"isDefault": $isDefault)';
}