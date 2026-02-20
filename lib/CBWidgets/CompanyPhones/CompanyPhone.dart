import 'dart:convert';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)

class CompanyPhone {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	final String? companyId;
	 
	@HiveField(2)
	final int? countryCode;
	 
	@HiveField(3)
	final int? operatorCode;
	 
	@HiveField(4)
	final int? number;
	 
	@HiveField(5)
	final String? type;
	 
	@HiveField(6)
	final bool? isDefault;
	 

  CompanyPhone({
    this.id,
		this.companyId,
		this.countryCode,
		this.operatorCode,
		this.number,
		this.type,
		this.isDefault
  });

  factory CompanyPhone.fromJson(Map<String, dynamic> map) {
    return CompanyPhone(
      id: map['_id'] as String?,
			companyId : map['companyId'] as String?,
			countryCode : map['countryCode'] as int,
			operatorCode : map['operatorCode'] as int,
			number : map['number'] as int,
			type : map['type'] as String?,
			isDefault : map['isDefault'] as bool
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id' : id,
			"countryCode" : countryCode,
			"operatorCode" : operatorCode,
			"number" : number,
			"isDefault" : isDefault
    };
}

  @override
  String toString() => 'CompanyPhone("_id" : $id,"companyId": $companyId,"countryCode": $countryCode,"operatorCode": $operatorCode,"number": $number,"type": $type,"isDefault": $isDefault)';
}