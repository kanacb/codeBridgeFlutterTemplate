import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)

class Positions {
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
	 

  Positions({
    this.id,
		this.roleId,
		this.name,
		this.description,
		this.abbr,
		this.isDefault
  });

  factory Positions.fromJson(Map<String, dynamic> map) {
    return Positions(
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
  String toString() => 'Positions("_id" : $id,"roleId": $roleId,"name": $name,"description": $description,"abbr": $abbr,"isDefault": $isDefault)';
}