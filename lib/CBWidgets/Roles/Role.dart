import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'Role.g.dart';
 
@HiveType(typeId: 7)

class Role {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String? name;
	@HiveField(2)
	 
	final String? description;
	@HiveField(3)
	 
	final bool? isDefault;

  Role({
    this.id,
		this.name,
		this.description,
		this.isDefault
  });

  factory Role.fromJson(Map<String, dynamic> map) {
    return Role(
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
  String toString() => 'Role("_id" : $id,"name": $name.toString(),"description": $description.toString(),"isDefault": $isDefault)';
}