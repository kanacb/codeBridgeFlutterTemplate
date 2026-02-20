import 'dart:convert';
import 'package:hive/hive.dart';
import '../../Utils/Services/IdName.dart';
 
part 'Section.g.dart';
 
@HiveType(typeId: 6)

class Section {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final IdName? departmentId;
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
			departmentId : map['departmentId'] as IdName?,
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