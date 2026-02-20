import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)

class Company {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	final String? name;
	 
	@HiveField(2)
	final String? companyNo;
	 
	@HiveField(3)
	final int? newCompanyNumber;
	 
	@HiveField(4)
	final DateTime? DateIncorporated;
	 
	@HiveField(5)
	final bool? isdefault;
	 

  Company({
    this.id,
		this.name,
		this.companyNo,
		this.newCompanyNumber,
		this.DateIncorporated,
		this.isdefault
  });

  factory Company.fromJson(Map<String, dynamic> map) {
    return Company(
      id: map['_id'] as String?,
			name : map['name'] as String?,
			companyNo : map['companyNo'] != null ? map['companyNo'] as String : "",
			newCompanyNumber : map['newCompanyNumber'] as int,
			DateIncorporated : map['DateIncorporated'] != null ? DateTime.parse(map['DateIncorporated']) : null,
			isdefault : map['isdefault'] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"newCompanyNumber" : newCompanyNumber,
			'DateIncorporated' : DateIncorporated?.toIso8601String(),
			"isdefault" : isdefault
    };
}

  @override
  String toString() => 'Company("_id" : $id,"name": $name,"companyNo": $companyNo,"newCompanyNumber": $newCompanyNumber,"DateIncorporated": ${DateIncorporated?.toIso8601String()},"isdefault": $isdefault)';
}