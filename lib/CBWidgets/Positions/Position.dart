import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)

class Position {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	final String? roleId;
	 
	@HiveField(2)
	final String? name;
	 
	@HiveField(3)
	final String? description;
	 
	@HiveField(4)
	final String? abbr;
	 
	@HiveField(5)
	final bool? isDefault;
	 

  Position({
    this.id,
		this.roleId,
		this.name,
		this.description,
		this.abbr,
		this.isDefault
  });

  factory Position.fromJson(Map<String, dynamic> map) {
    return Position(
      id: map['_id'] as String?,
			roleId : map['roleId'] as String?,
			name : map['name'] as String?,
			description : map['description'] as String?,
			abbr : map['abbr'] as String?,
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
  String toString() => 'Position("_id" : $id,"roleId": $roleId,"name": $name,"description": $description,"abbr": $abbr,"isDefault": $isDefault)';
}