import 'dart:convert';
import 'package:hive/hive.dart';
 
import '../Companies/Company.dart';
 
 
part 'CompanyPhone.g.dart';
 
@HiveType(typeId: 13)

class CompanyPhone {
  @HiveField(0)
	final String? id;
	 
	@HiveField(1)
	 
	final Company? companyId;
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
			companyId : map['companyId'] != null ? Company.fromJson(map['companyId']) : null,
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
			"companyId" : companyId?.id.toString(),
			"countryCode" : countryCode,
			"operatorCode" : operatorCode,
			"number" : number,
			"isDefault" : isDefault
    };
}

  @override
  String toString() => 'CompanyPhone("_id" : $id,"companyId": $companyId.toString(),"countryCode": $countryCode,"operatorCode": $operatorCode,"number": $number,"type": $type.toString(),"isDefault": $isDefault)';
}