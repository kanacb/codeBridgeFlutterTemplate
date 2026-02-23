import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Companies/Company.dart';
 
 
part 'Branch.g.dart';
 
@HiveType(typeId: 4)

class Branch {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final Company companyId;
	@HiveField(2)
	 
	final String name;
	@HiveField(3)
	 
	final bool? isDefault;

  Branch({
    this.id,
		required this.companyId,
		required this.name,
		this.isDefault
  });

  factory Branch.fromJson(Map<String, dynamic> map) {
    return Branch(
      id: map['_id'] as String?,
			companyId : Company.fromJson(map['companyId']),
			name : map['name'] as String,
			isDefault : map['isDefault'] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"companyId" : companyId.id.toString(),
			"isDefault" : isDefault
    };
}

  @override
  String toString() => 'Branch("_id" : $id,"companyId": $companyId.toString(),"name": $name.toString(),"isDefault": $isDefault)';
}