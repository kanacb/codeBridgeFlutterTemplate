import 'dart:convert';
import 'package:hive/hive.dart';
 
 
 
part 'Company.g.dart';
 
@HiveType(typeId: 3)

class Company {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final String? name;
	@HiveField(2)
	 
	final String companyNo;
	@HiveField(3)
	 
	final String? newCompanyNumber;
	@HiveField(4)
	 
	final DateTime? DateIncorporated;
	@HiveField(5)
	 
	final bool? isdefault;

  Company({
    this.id,
		this.name,
		required this.companyNo,
		this.newCompanyNumber,
		this.DateIncorporated,
		this.isdefault
  });

  factory Company.fromJson(Map<String, dynamic> map) {
    return Company(
      id: map['_id'] as String?,
			name : map['name'] as String?,
			companyNo : map['companyNo'] as String,
			newCompanyNumber : map['newCompanyNumber'] as String?,
			DateIncorporated : map['DateIncorporated'] != null ? DateTime.parse(map['DateIncorporated']) : null,
			isdefault : map['isdefault'] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			'DateIncorporated' : DateIncorporated?.toIso8601String(),
			"isdefault" : isdefault
    };
}

  @override
  String toString() => 'Company("_id" : $id,"name": $name.toString(),"companyNo": $companyNo.toString(),"newCompanyNumber": $newCompanyNumber.toString(),"DateIncorporated": $DateIncorporated?.toIso8601String()},"isdefault": $isdefault)';
}