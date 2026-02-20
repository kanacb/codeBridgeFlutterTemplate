import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)

class Branches {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	final String? companyId;
	 
	@HiveField(2)
	final String? name;
	 
	@HiveField(3)
	final bool? isDefault;
	 

  Branches({
    this.id,
		this.companyId,
		this.name,
		this.isDefault
  });

  factory Branches.fromJson(Map<String, dynamic> map) {
    return Branches(
      id: map['_id'] as String?,
			companyId : map['companyId'] as String?,
			name : map['name'] as String?,
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
  String toString() => 'Branches("_id" : $id,"companyId": $companyId,"name": $name,"isDefault": $isDefault)';
}