import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)

class Branch {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	final String? companyId;
	 
	@HiveField(2)
	final String? name;
	 
	@HiveField(3)
	final bool? isDefault;
	 

  Branch({
    this.id,
		this.companyId,
		this.name,
		this.isDefault
  });

  factory Branch.fromJson(Map<String, dynamic> map) {
    return Branch(
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
  String toString() => 'Branch("_id" : $id,"companyId": $companyId,"name": $name,"isDefault": $isDefault)';
}