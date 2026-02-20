import 'dart:convert';
import 'package:hive/hive.dart';
import '../../Utils/Services/IdName.dart';
 
part 'Branch.g.dart';
 
@HiveType(typeId: 4)

class Branch {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final IdName? companyId;
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
			companyId : map['companyId'] as IdName?,
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