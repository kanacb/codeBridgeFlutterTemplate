import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)

class Section {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	final String? departmentId;
	 
	@HiveField(2)
	final String? name;
	 
	@HiveField(3)
	final String? code;
	 
	@HiveField(4)
	final bool? isDefault;
	 

  Section({
    this.id,
		this.departmentId,
		this.name,
		this.code,
		this.isDefault
  });

  factory Section.fromJson(Map<String, dynamic> map) {
    return Section(
      id: map['_id'] as String?,
			departmentId : map['departmentId'] as String?,
			name : map['name'] as String?,
			code : map['code'] as String?,
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
  String toString() => 'Section("_id" : $id,"departmentId": $departmentId,"name": $name,"code": $code,"isDefault": $isDefault)';
}